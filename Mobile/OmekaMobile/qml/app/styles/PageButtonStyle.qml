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
            color: control.checked ? Style.checkedTabColor: Style.uncheckedTabColor
            implicitWidth: control.width
            implicitHeight: control.height

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
