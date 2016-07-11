import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../utils"
import "../styles"
import "../base"

/*!
  \qmltype Search

  Search provides item filtering by generic keyword or item tags
*/
Item {


    //background
    Rectangle {
        anchors.fill: parent
        color: Style.viewBackgroundColor
    }

    //view
    StackView {
        id: searchStack
        anchors.fill: parent
        initialItem: Qt.resolvedUrl("TagSearch.qml")
    }

    //search control
    OmekaSearchField {
        id: field
    }

}
