import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "../../home"
import "../../base"
import "../../../utils"

Item {
    width: parent.width
    height: parent.height

    ScrollView {
        width: parent.width
        height: parent.height
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

        property variant item: ItemManager.current

        Component.onCompleted: {
            image.source = item.image

            info.text = ""
            if(item.metadata){
                var element
                var metadata = ""
                for(var i=0; i<item.metadata.length; i++) {
                    element = item.metadata[i];
                    metadata += "<p><b>"+element.element.name+"</b><br/>"+element.text+"</p>"
                }
                info.text = metadata
            }
        }

        Item {            
            width: parent.parent.width
            height: content.height + margins
            property real margins: 10

            Rectangle {
                id: background
                anchors.fill: content
                radius: 10
            }

            Item {
                id: content
                width: parent.width - 2*parent.margins
                height: childrenRect.height
                y:  parent.margins
                anchors.horizontalCenter: parent.horizontalCenter

                OmekaToolBar {
                    id: bar
                    OmekaButton{
                        id: back
                        anchors.left: parent.left
                        icon: Style.back
                        onClicked: if(stack) stack.pop()
                    }
                    OmekaButton {
                        id: more
                        anchors.right: like.left
                        icon: Style.more
                    }
                    OmekaButton {
                        id: like
                        anchors.right: parent.right
                        icon: Style.likeIndicator2
                    }
                }

                Image {
                    id: image
                    width: parent.width
                    anchors.top: bar.bottom
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                }

                Text {
                    id: info
                    anchors.top: image.bottom
                    width: parent.width
                    height: contentHeight
                    wrapMode: Text.Wrap
                    font.pixelSize: 50 * Resolution.scaleRatio
                    textFormat: Text.RichText

                }
            }
        }
    }
}
