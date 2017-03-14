import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "."

Component {
    Item
    {
        id: root
        width: 500; height: 500
        property var itemData: ({})
        property var title
        property var source

        //scale: changeScale()
        z: changeZ();//1 - Math.abs(index - path.currentIndex)
        opacity: Math.abs(index - path.currentIndex) < 3 || (path.count - index + path.currentIndex) < 3 ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation
            {
                duration: 200
            }
        }

        function changeScale()
        {
            if(!ListView.isCurrentItem)
            {
                return 1 /(Math.abs(index - path.currentIndex))
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
                return 1-(path.count - Math.abs(index - path.currentIndex))
            }
            else
            {
                return 1 - Math.abs(index - path.currentIndex)
            }
        }


//        //property alias source: img.source
//        property alias imageWidth: img.width
//        property alias imageHeight: img.height

        property bool inScene: false

//        property bool hasImage: img.source != ""

//        signal imageClicked(string source)

        function imageInScene()
        {
            inScene = true;
        }
        function imageRemovedFromScene()
        {
            inScene = false;
        }


        Component.onCompleted:
        {
            itemData.id = String(item)
            console.log("itemData.id = ", itemData.id)
            itemData.fileCount = parseInt(file_count)
            itemData.metadata = metadata
            itemData.media = []
            itemData.mediaTypes = []

            Omeka.getFiles(itemData.id, root)
        }
        function setInfo()
        {
            var name
            for(var i=0; i<metadata.count; i++) {
                name = metadata.get(i).element.name.toLowerCase();
                if(name === "title") {
                    title = metadata.get(i).text
                } else if(name === "source") {
                    source = metadata.get(i).text.split("View")[0]
                }
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
            //opacity: 0
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            anchors.margins: 30
//            MultiPointTouchArea
//            {
//                enabled: false

//                anchors.fill: parent

//                onPressed:
//                {
//                    root.imageClicked(image.source);
//                }

//                Rectangle
//                {
//                    anchors.fill: parent
//                    color: "blue"
//                    opacity: 0.5
//                    visible: parent.enabled && Settings.showDebugInfo
//                }
//            }
        }
    }
}
