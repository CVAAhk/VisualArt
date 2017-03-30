import QtQuick 2.0
import QtQuick.Controls 1.4
import "."

/*!
  \qmltype SearchDelegate

  SearchDelegate is search item representing a collection tag. When selected the repository
  is queried for all items with this tag and the browser is populated with the results.
*/
Image {
    id: context
    source: "content/POI/tag-bkg.png"

    anchors.horizontalCenter: parent.horizontalCenter
    opacity: ItemManager.tagSearch == tag ? 0.5 : 1.0

    //anchors.margins: 12 //TODO: A-Z area

    //text display
    OmekaText {
        text: tag
        anchors.centerIn: parent
        _font: Style.tagFont
    }

    //tag search
    MouseArea{
        anchors.fill: parent
        onClicked:
        {
            ItemManager.tagSearch = tag;
        }
    }
}

