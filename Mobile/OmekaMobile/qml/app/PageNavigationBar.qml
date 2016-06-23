import QtQuick 2.5
import QtQuick.Controls 1.4
import "../utils"

/*!
  \qmltype PageNavigationBar

  PageNavigationBar is the main navigation bar which queues the page corresponding to
  the current state.
*/
Row {
    id: bar
    width: parent.width
    height: Resolution.applyScale(192)
    anchors.bottom: parent.bottom
    z: 1

    state: "home"

    /*! \qmlproperty
       Selected index
    */
    property int index: 0

    //home page
    PageButton { id: home
        index: 0
        state: "home"
        checkedIcon: "../../ui/home-on.png"
        uncheckedIcon: "../../ui/home-off.png"
    }
    //search page
    PageButton { id: search
        index: 1
        state: "search"
        checkedIcon: "../../ui/search-on.png"
        uncheckedIcon: "../../ui/search-off.png"
    }
    //likes page
    PageButton { id: likes
        index: 2
        state: "likes"
        checkedIcon: "../../ui/likes-on.png"
        uncheckedIcon: "../../ui/likes-off.png"
    }

    //nav state
    states: [
        PageState {
            name: "home"
            target: home
        },
        PageState {
            name: "search"
            target: search
        },
        PageState {
            name: "likes"
            target: likes
        }

    ]
}

