import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../gallery"
import "../../../utils"

/*! Omeka media item preview */
Component {
    Item{
        width: grid.cellWidth; height: grid.cellHeight
        property variant itemData: ({})

        /*! query metadata */
        Component.onCompleted: {
            itemData.id = String(item)
            itemData.full = full
            itemData.image = image
            itemData.media = media
            update()
        }

        onVisibleChanged: update()

        /*! load metadata */
        Connections {
            target: Omeka
            onRequestComplete: {
               if(String(result.item) === itemData.id && result.type === Omeka.metadata) {
                   itemData.metadata = result.metadata
                   target = null
               }
            }
        }

        /*! media thumbnail */
        Image{
            id: img
            anchors.fill: parent
            anchors.centerIn: parent           
            asynchronous: true
            source: full ? full : Style.thumbs[media]
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
        Button{
            id: like
            visible: img.progress === 1
            scale: Resolution.scaleRatio
            anchors.right: parent.right
            checkable: true

            //custom style
            style: ButtonStyle {
                background: Image{
                    source: Style.likeIndicator
                    Image {
                        source: Style.likeFill
                        visible: like.checked
                    }
                }
            }

            //add or remove data entry based on checked state
            onClicked: {
                if(checked){                    
                    ItemManager.registerLike(itemData)
                }
                else{
                    ItemManager.unregisterLike(itemData)
                }
            }
        }

        //update metadata and liked state
        function update() {
            Omeka.getMetaData(itemData.id)
            like.checked = ItemManager.isLiked(itemData)
        }
    }
}
