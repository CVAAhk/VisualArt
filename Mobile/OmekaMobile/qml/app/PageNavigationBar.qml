import QtQuick 2.5
import QtQuick.Controls 1.4
import "../utils"
import "../app/likes"

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
    property bool hideBar: false

    /*! \qmlproperty
       Button state names
    */
    property var buttonStates: ["home", "search", "likes"]

    /*! \qmlproperty
       Pulses likes page button to draw user's attention
    */
    property alias pulseLikesButton : likes.pulse

    /*! \qmlproperty
       Selected index
    */
    property int index
    Binding { target:bar; property:"index"; when: state !== "hide"; value: buttonStates.indexOf(state) }

    //queue home page
    PageButton { id: home
        state: buttonStates[0]
        checkedIcon: Style.homeButtonOn
        uncheckedIcon: Style.homeButtonOff
    }
    //queue search page
    PageButton { id: search
        state: buttonStates[1]
        checkedIcon: Style.searchButtonOn
        uncheckedIcon: Style.searchButtonOff
    }
    //queue likes page
    PageButton { id: likes
        state: buttonStates[2]
        checkedIcon: Style.likesButtonOn
        uncheckedIcon: Style.likesButtonOff

        //notify number of likes added since last view
        NumberTag {
            id: likesTag

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenterOffset: Resolution.applyScale(-45)
            anchors.horizontalCenterOffset: Resolution.applyScale(90)

            number: ItemManager.newLikes
        }
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
            PropertyChanges { target: bar; explicit: true; enabled: false; anchors.bottomMargin: -bar.height }
            //AnchorChanges { target: bar; anchors.bottom: undefined; anchors.top: parent.bottom }
        }
    ]

    //update hide state
    onHideBarChanged: state = hideBar ? "hide" : buttonStates[index]

    //hide animations
    transitions: Transition {

        NumberAnimation {
            target: bar
            property: "anchors.bottomMargin"
            duration: 200
            easing.type: Easing.InOutQuad
        }
        //AnchorAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }
}

