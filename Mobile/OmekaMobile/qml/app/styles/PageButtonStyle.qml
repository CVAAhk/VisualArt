import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import "../../utils"

/*!
  \qmltype PageButtonStyle

  PageButtonStyle is a custom appearance for the PageButton control
*/
ButtonStyle {

        //background
        background: Rectangle {
            color: control.checked ? Style.color1 : Style.color4
            implicitWidth: control.width
            implicitHeight: control.height

            //pulsating background to draw attention
            Rectangle {
                id: attention
                anchors.fill: parent
                color: "white"
                visible: control.pulse

                SequentialAnimation {
                    running: control.pulse
                    loops: Animation.Infinite
                    NumberAnimation { target: attention; property: "opacity"; from: 0; to: 1; duration: 500 }
                    NumberAnimation { target: attention; property: "opacity"; from: 1; to: 0; duration: 500 }
                }

            }

            //icons
            Item {
                anchors.centerIn: parent
                width: childrenRect.width
                height: childrenRect.height
                scale: (parent.height * .56)/height

                Image {
                    source: control.checkedIcon
                    visible: control.checked
                }

                Image {
                    source: control.uncheckedIcon
                    visible: !control.checked
                }
            }
        }
    }
