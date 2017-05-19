import QtQuick 2.5
import "../../utils"

/*!
  \qmltype NumberTag

  NumberTag notifies the user that new items have been liked when the current view is not the
  likes view. The notification is in the form of a small number tag hovering over the likes menu
  item (heart icon) of the main navigation bar. The value will increment as new items are liked
  and will reset when the user navigates to the likes view to see the new additions.
*/
Rectangle {

    property int padding: Resolution.applyScale(42)
    property int number: 0
    visible: number > 0

    width: childrenRect.width + padding
    height: Resolution.applyScale(60)
    radius: height
    color: "red"

    Text {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: padding/2
        color: "white"
        text: String(number)
    }
}
