import QtQuick 2.5

/*!
  \qmltype PageState

  PageState defines state properties of the page navigation bar
*/
State {
    id: state
    property variant target
    PropertyChanges { target: state.target; explicit: true; checked: true }
    AnchorChanges { target: bar; anchors.top: undefined; anchors.bottom: bar.parent.bottom }
}
