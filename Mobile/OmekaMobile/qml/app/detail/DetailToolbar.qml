import QtQuick 2.5
import "../base"
import "../../utils"

/*
  \qmltype DetailToolbar

  DetailToolbar is a toolbar composed of detail operation controls.
*/
OmekaToolBar {

    //return to previous page
    OmekaButton{
        id: back
        anchors.left: parent.left
        icon: Style.back
        onClicked: navigator.pop()
    }

    //provides drop down menu of additional options
    OmekaButton {
        id: more
        anchors.right: like.left
        icon: Style.more
    }

    //locally stores item in database
    OmekaButton {
        id: like
        anchors.right: parent.right
        icon: Style.likeIndicator2
    }
}
