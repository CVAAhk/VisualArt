import QtQuick 2.5
import QtQuick.Controls 1.4
import "../utils"

/*!
  \qmltype PageLoader

  PageLoader is the main navigation bar which queues the page corresponding to
  the current state.
*/
Row {
    id: navigator
    width: parent.width
    height: Resolution.applyScale(192)
    anchors.bottom: parent.bottom
    state: "home"

    //home page
    PageButton { id: home
        onClicked: navigator.state = "home"
        checkedIcon: "../../ui/home-on.png"
        uncheckedIcon: "../../ui/home-off.png"
    }
    //search page
    PageButton { id: search
        onClicked: navigator.state = "search"
        checkedIcon: "../../ui/search-on.png"
        uncheckedIcon: "../../ui/search-off.png"
    }
    //likes page
    PageButton { id: likes
        onClicked: navigator.state = "likes"
        checkedIcon: "../../ui/likes-on.png"
        uncheckedIcon: "../../ui/likes-off.png"
    }

    //nav state
    states: [
        State {
            name: "home"
            PropertyChanges { target: home; explicit: true; checkable: true; checked: true }
        },
        State {
            name: "search"
            PropertyChanges { target: search; explicit: true; checkable: true; checked: true }
        },
        State {
            name: "likes"
            PropertyChanges { target: likes; explicit: true; checkable: true; checked: true }
        }
    ]
}

