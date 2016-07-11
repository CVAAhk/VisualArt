import QtQuick 2.0
import QtQuick.Controls 1.4
import "../base"
import "../../utils"

/*!
  \qmltype SearchDelegate

  SearchDelegate is search item representing a collection tag. When selected the repository
  is queried for all items with this tag and the browser is populated with the results.
*/
Rectangle {
    id: context
    color: Style.viewBackgroundColor
    height: Resolution.applyScale(150)
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: Resolution.applyScale(30)
    border.width: 1
    border.color: "#b1b1b1"

    property int count

    //query items with tag
    Component.onCompleted: {
        count = 0
        Omeka.getItemsByTag(tag, context);
    }

    //upate tag count
    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.context === context){
               count++;
            }
        }
    }

    //text display
    OmekaText {
        text: tag+" ("+count+")"
        anchors.centerIn: parent
        _font: Style.tagFont
    }

    //execute query
    MouseArea{
        anchors.fill: parent
        onClicked: {
            Omeka.getItemsByTag(tag, context)
            searchStack.push(Qt.resolvedUrl("SearchResults.qml"))
        }
    }
}
