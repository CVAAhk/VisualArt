import QtQuick 2.0
import QtQuick.Controls 1.4
import "."

/*!
  \qmltype SearchDelegate

  SearchDelegate is search item representing a collection tag. When selected the repository
  is queried for all items with this tag and the browser is populated with the results.
*/
Rectangle {
    id: context
    color: Style.color3
    height: Resolution.applyScale(150)
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: Resolution.applyScale(30)
    border.width: 1
    border.color: "#b1b1b1"

    //text display
    OmekaText {
        text: tag+" ("+count+")"
        anchors.centerIn: parent
        _font: Style.tagFont
    }

    //tag search
    MouseArea{
        anchors.fill: parent
        onClicked: ItemManager.tagSearch = tag
    }
}
