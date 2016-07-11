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
    id: search

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
        text: ItemManager.tagSearch
        state: search.state
        onTextChanged: search.state = text.length ? "results" : "search"
        Keys.onReleased: ItemManager.searchTerm = text
    }

    //switch to results on search field entry
    states: [
        State {
            name: "results"
            StateChangeScript { script: searchStack.push(Qt.resolvedUrl("SearchResults.qml")) }
        },
        State {
            name: "search"
            StateChangeScript { script: searchStack.pop() }
        }
    ]

}
