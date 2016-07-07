import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../gallery"
import "../../../utils"

/*! Omeka media item preview */
Component {
    Item{
        id: object
        width: grid.cellWidth; height: grid.cellHeight

        property var itemData: ({})

        /*! store result and query files */
        Component.onCompleted: {
            itemData.id = item
            itemData.metadata = metadata
            itemData.media = []
            itemData.mediaTypes = []
            Omeka.getFiles(item, object)
            like.refresh(itemData)
        }
        onVisibleChanged: like.refresh(itemData)

        /*! load media data*/
        Connections {
            target: Omeka
            onRequestComplete: {
               if(result.context === object) {

                   itemData.thumb = result.thumb || Style.thumbs[result.media_type]
                   itemData.media.push(result.media)
                   itemData.mediaTypes.push(result.media_type)

                   if(itemData.media.length === file_count){
                      img.source = itemData.thumb
                      target = null
                   }
               }
            }
        }

        /*! media thumbnail */
        Image{
            id: img
            anchors.fill: parent
            anchors.centerIn: parent           
            asynchronous: true
            fillMode: Image.PreserveAspectCrop
        }

        /*! loads detailed view */
        MouseArea{
            anchors.fill: parent
            onClicked: {
                ItemManager.current = itemData
            }
        }

        /*! registers like and unlikes */
        LikeButton{ id: like }
    }
}
