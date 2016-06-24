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

    //initial state
    state: "home"

    /*! \qmlproperty
       Flag indicating the bar is invisible
    */
    property bool hide: false

    /*! \qmlproperty
       Button state names
    */
    property var buttonStates: ["home", "search", "likes"]

    /*! \qmlproperty
       Selected index
    */
    property int index
    Binding { target:bar; property:"index"; when: state !== "hide"; value: buttonStates.indexOf(state) }

    //queue home page
    PageButton { id: home
        state: buttonStates[0]
        checkedIcon: "../../ui/home-on.png"
        uncheckedIcon: "../../ui/home-off.png"
    }
    //queue search page
    PageButton { id: search
        state: buttonStates[1]
        checkedIcon: "../../ui/search-on.png"
        uncheckedIcon: "../../ui/search-off.png"
    }
    //queue likes page
    PageButton { id: likes
        state: buttonStates[2]
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
        },
        State {
            name: "hide"
            PropertyChanges { target:bar; explicit: true; enabled: false }
            AnchorChanges { target: bar; anchors.bottom: undefined; anchors.top: parent.bottom }
        }
    ]

    //update hide state
    onHideChanged: state = hide ? "hide" : buttonStates[index]

    //hide animations
    transitions: Transition {
        AnchorAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }
}

