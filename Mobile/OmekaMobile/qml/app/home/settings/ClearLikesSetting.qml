import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../base"
import "../../../utils"

/*!
  \qmltype ClearLikesSetting

  ClearLikesSetting is a user setting permitting the local removal of all likes collected by the user
*/
Setting {

    //container
    content: Rectangle {
        height: Resolution.applyScale(450)

        Column {
            width: parent.width
            height: childrenRect.height
            anchors.centerIn: parent
            spacing: 10

            //warning text
            OmekaText {
                id: warning
                width: parent.width
                _font: Style.metadataFont
                horizontalAlignment: Text.AlignHCenter
                text: User.clearLikesConfirm
            }

            //confirmation button
            Button {
                id: confirm
                enabled: User.likesExist()
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * .5
                height: Resolution.applyScale(150)
                text: "Clear"
                onClicked: {
                    User.clearAllLikes()
                    enabled = false
                }
            }
        }
    }
}
