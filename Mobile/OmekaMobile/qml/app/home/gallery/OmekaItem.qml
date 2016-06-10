import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0
import "../../../utils"
import "../../../js/storage.js" as Settings

/*! Omeka media item preview */
Component {
    Item{
        width: grid.cellWidth; height: grid.cellHeight

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
            onClicked: if(stack) stack.push(Qt.resolvedUrl("../detail/Detail.qml"))
        }

        /* registers like and unlikes */
        Button{
            id: like
            visible: img.progress === 1
            scale: Resolution.scaleRatio
            anchors.right: parent.right
            checkable: true
            checked: Settings.isLiked(item)
            style: ButtonStyle {
                background: Image{
                    source: "../../../../ui/like-indicator.png"
                    Image {
                        source: "../../../../ui/like-fill.png"
                        visible: like.checked
                    }
                }
            }
            onClicked: {
                if(checked){
                    Settings.addLike(item)
                }
                else{
                    Settings.removeLike(item)
                }
            }
        }
    }
}
