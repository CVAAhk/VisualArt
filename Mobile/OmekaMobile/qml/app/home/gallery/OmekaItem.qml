import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "../gallery"
import "../../../utils"

/*! Omeka media item preview */
Component {
    Item{
        id: object
        width: view.thumbWidth; height: width

        property var itemData: ({})

        //store result and query files
        Component.onCompleted: {

            itemData.id = String(item)
            itemData.fileCount = parseInt(file_count)
            itemData.metadata = metadata
            itemData.media = []
            itemData.mediaTypes = []

            Omeka.getFiles(itemData.id, object)
            like.refresh(itemData)
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

        //media thumbnail
        Image{
            id: img
            width: parent.width - view.spacing; height: parent.height - view.spacing
            anchors.centerIn: parent
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
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: view.spacing/2
            anchors.rightMargin: view.spacing/2
        }
    }
}
