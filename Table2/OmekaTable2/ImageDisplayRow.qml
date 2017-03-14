import QtQuick 2.0

Item
{
    property string defaultImage: "blank.png"

    property int imageHeight

    property int moveSpeed: 1000

    property var images: []

    property int currentX: 0

    property int columnSpacing: 20

    property int columnSize: 0

    property bool imagesAlwaysTouchActive: false

    property int set: 0
    property var delegate: ImageViewer{}

    signal imageClicked(string source)

    id: root

    width: 2000000000

    Item
    {
        Repeater
        {
            model: 200 // Settings.IMAGES_PER_COLUMN
            delegate:root.delegate

//            ImageDisplayEntry
//            {
//                source: root.defaultImage
//                imageWidth: root.imageWidth
//                alwaysTouchActive: root.imagesAlwaysTouchActive

//                onImageClicked:
//                {
//                    root.imageClicked(source);
//                }
//            }

            onItemAdded:
            {
//                item.source = collections.getNextImage(root.set);
//                if(item.source == "")
//                    return;

                item.x = widthOffset();
                item.imageWidth = 300;
                item.imageHeight = 350;
//                item.imageWidth = collections.getNextImageWidth(root.set, root.imageHeight);
//                item.imageHeight = collections.getNextImageHeight(root.set, item.imageWidth);
//                item.collection = collections.getNextImageCollection(root.set);

                item.y = (root.height - item.imageHeight) * 0.5;

                images.push(item);

                root.columnSize = item.x + item.imageWidth;
            }

        }
    }

    function moveFrontToBack()
    {
        var offset = heightOffset();

        var first = images.shift();

        first.x += offset;

        first.imageWidth = collections.getNextImageWidth(root.imageHeight);
        first.source = collections.getNextImage();

        images.push(first);
    }

    function widthOffset()
    {
        var offset = 0.0;
        for(var i = 0; i < images.length; i++)
        {
            offset += images[i].width + root.columnSpacing;
        }

        return offset;
    }

    function showAllCollections()
    {
        var offset = 0.0;
        for(var i = 0; i < images.length; i++)
        {
            images[i].visible = true;

            images[i].x = offset;

            offset += images[i].width + root.columnSpacing;
        }

        columnSize = offset;
    }

    function showCollection(selectedCollection)
    {
        if(selectedCollection == "View All" ||
                selectedCollection == "ALL CATEGORIES")
        {
            showAllCollections();
            return;
        }

        var offset = 0.0;
        for(var i = 0; i < images.length; i++)
        {
            if(images[i].collection !== selectedCollection)
            {
                images[i].visible = false;
                continue;
            }

            images[i].visible = true;

            images[i].x = offset;

            offset += images[i].width + root.columnSpacing;
        }

        columnSize = offset;
    }

    function getImageAtX(xPoint)
    {
        var offset = 0.0;
        for(var i = 0; i < images.length; i++)
        {
            if(!images[i].visible) // || images[i].inScene)
            {
                continue;
            }

            if(images[i].x <= xPoint &&
                    images[i].x + images[i].width >= xPoint)
            {
                return images[i].source;
            }
        }

        return "";
    }

    function imageInScene(source)
    {
        for(var i = 0; i < images.length; i++)
        {
            if(images[i].source === source)
            {
                images[i].inScene = true;
            }
        }
    }

    function imageRemovedFromScene(source)
    {
        for(var i = 0; i < images.length; i++)
        {
            if(images[i].source == source)
            {
                images[i].inScene = false;
            }
        }
    }

    function isImageInScene(source)
    {
        for(var i = 0; i < images.length; i++)
        {
            if(images[i].source === source)
            {
                return images[i].inScene;
            }
        }

        return false;
    }

    function clearInScene()
    {
        for(var i = 0; i < images.length; i++)
        {
            images[i].inScene = false;
        }
    }
}
