import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "../gallery"
import "../../../utils"
import "../../clients"
import "../../base"

/*! Omeka media item preview */
Component {
    Item{
        id: object
        state: User.layoutID

        property var itemData: ({})
        property var title
        property var source

        //Used to postpone likes unregistration when the likes list is the currently displayed view. The rationale being
        //the user having the option to relike an unliked item from the likes view and not until the view is disabled will
        //the unlikes finalized and removed from the list.
        property bool visibleLikesMember: context ? (context.objectName === "LikesList" && context.enabled) : false

        //store result and query files
        Component.onCompleted: {

            itemData.id = item
            itemData.fileCount = parseInt(file_count)
            itemData.metadata = metadata
            itemData.media = []
            itemData.mediaTypes = []
            itemData.url = url
            itemData.omekaID = Omeka.prettyName(url.substring(0, url.lastIndexOf("api")))

            setInfo();

            var api = url.substring(0, url.lastIndexOf("items"))
            Omeka.getFiles(itemData.id, object, api)
            like.refresh(itemData)
        }

        //set info panel content
        function setInfo() {
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

        //refresh liked state
        onVisibleChanged: like.refresh(itemData)

        //load media data
        Connections {
            target: Omeka
            onRequestComplete: {
               if(result.context === object) {
                   itemData.thumb = result.thumb || Style.thumbs[result.media_type]
                   itemData.media.push(result.media)
                   itemData.mediaTypes.push(result.media_type)

                   if(itemData.media.length === itemData.fileCount){
                      img.source = itemData.thumb
                      target = null
                   }
               }
            }
        }

        //info panel
        InfoPanel {
            id: panel
            visible: object.state === "list" || img.progress < 1
            title: object.title
            source: object.source ? "- "+object.source : ""
        }

        //media thumbnail
        Image{
            id: img
            opacity: 0
            anchors.verticalCenter: parent.verticalCenter
            asynchronous: true
            fillMode: Image.PreserveAspectCrop

            layer.enabled: true            
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    radius: Resolution.applyScale(30)
                    width: img.width
                    height: img.height
                    anchors.centerIn: parent
                }
            }

            Behavior on opacity { PropertyAnimation{} }
            onProgressChanged: if(progress === 1) opacity = 1
        }

        //load indicator
        OmekaIndicator {
            scale: Resolution.applyScale(2)
            running: img.progress < 1
        }

        //loads detailed view
        MouseArea{
            anchors.fill: parent
            onClicked: {
                ItemManager.current = itemData
            }
        }

        //registers like and unlikes
        LikeButton{
            id: like
            anchors.top: img.top
            anchors.right: img.right
            bypassRemoval: object.visibleLikesMember
        }

        states: [
            State {
                name: "grid"
                PropertyChanges { target: object; width: object.height; height: view.rowHeight }
                PropertyChanges { target: img; width: img.height; height: object.height - view.spacing }
                AnchorChanges { target: img; anchors.horizontalCenter: object.horizontalCenter; anchors.left: undefined }                
            },
            State {
                name: "list"
                PropertyChanges { target: object; width: parent.width; height: view.rowHeight }
                PropertyChanges { target: img; width: object.height * 1.4; height: object.height }
                AnchorChanges { target: img; anchors.horizontalCenter: undefined; anchors.left: panel.left }
            }
        ]
    }
}
