import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0
import "../gallery"
import "../../../utils"
import "../../../js/storage.js" as Settings

/*! Omeka media item preview */
Component {
    Item{
        width: grid.cellWidth; height: grid.cellHeight
        property variant itemData: ({})

        /*! query metadata */
        Component.onCompleted: {
            itemData.id = item
            itemData.full = full
            itemData.image = image
            Omeka.getMetaData(item)
        }

        /*! load metadata */
        Connections {
            target: Omeka
            onRequestComplete: {
               if(result.item === itemData.id && result.type === Omeka.metadata) {
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
            source: full
            fillMode: Image.PreserveAspectCrop
        }

        /*! loads detailed view */
        MouseArea{
            anchors.fill: parent
            onClicked: {
                ItemManager.current = itemData
                if(stack){
                    stack.push(Qt.resolvedUrl("../detail/Detail.qml"))
                }
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
                    source: "../../../../ui/like-indicator.png"
                    Image {
                        source: "../../../../ui/like-fill.png"
                        visible: like.checked
                    }
                }
            }

            //bind initial checked state to likes entry
            onVisibleChanged: checked = Settings.isLiked(item)

            //add or remove data entry based on checked state
            onClicked: {
                if(checked){
                    Settings.addLike(item, img.source)
                }
                else{
                    Settings.removeLike(item)
                }
            }
        }
    }
}
