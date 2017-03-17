import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "."

Component {
    Item
    {
        id: root
        width: 158; height: 190
        property var itemData: ({})
        property var title
        property string source:img.source

        scale: changeScale()
        z: changeZ();//1 - Math.abs(index - path.currentIndex)
        visible: Math.abs(index - path.currentIndex) < 3 || (path.count - index + path.currentIndex) < 3

        function changeScale()
        {
            if(Math.abs(index - path.currentIndex) == 1 || Math.abs(index - path.currentIndex) == path.count - 1)
            {
                return 0.9
            }
            else if(Math.abs(index - path.currentIndex) == 2 || Math.abs(index - path.currentIndex) == path.count - 2)
            {
                return 0.75
            }
            else
            {
                return 1
            }
        }
        function changeZ()
        {
            if(Math.abs(index - path.currentIndex) >= path.count - 2)
            {
                return path.count-(path.count - Math.abs(index - path.currentIndex))
            }
            else
            {
                return path.count - Math.abs(index - path.currentIndex)
            }
        }

        property bool inScene: false

        function imageInScene()
        {
            inScene = true;
            ItemManager.current = itemData;
            ItemManager.selectedItems.push(itemData);
        }
        function imageRemovedFromScene(source)
        {
            console.log("ImageViewer imageRemovedFromScene(source)= ", source)
            inScene = false;
//            for(var i = 0; i < ItemManager.selectedItems.length; i ++)
//            {
//                if(ItemManager.selectedItems[i].source === source)
//                {
//                    ItemManager.selectedItems.slice(i,1);
//                }
//            }
        }


        Component.onCompleted:
        {
            itemData.id = String(item)
            console.log("itemData.id = ", itemData.id)
            itemData.fileCount = parseInt(file_count)
            itemData.metadata = metadata
            itemData.media = []
            itemData.mediaTypes = []

            setInfo();

            Omeka.getFiles(itemData.id, root)
        }
        function setInfo()
        {
            var name
            for(var i=0; i<metadata.count; i++) {
                name = metadata.get(i).element.name.toLowerCase();
                if(name === "title") {
                    title = metadata.get(i).text
                } /*else if(name === "source") {
                    source = metadata.get(i).text.split("View")[0]
                }*/
            }
        }

        Connections {
            target: Omeka
            onRequestComplete: {
                if(result.context === root)
                {
                    console.log("thum = ", result.thumb)
                    itemData.thumb = result.thumb
                    itemData.media.push(result.media)
                    itemData.mediaTypes.push(result.media_type)

                    if(itemData.media.length === itemData.fileCount)
                    {
                        img.source = itemData.thumb
                        target = null
                    }
                }
            }
        }

        Image
        {
            id: bkg
            source: "content/POI/_Image_.png"
            anchors.fill: parent

        }
        Image
        {
            id: img
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            anchors.margins: 10
        }
    }
}
