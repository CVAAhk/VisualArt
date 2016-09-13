import QtQuick 2.5
import com.lasconic 1.0
import "../base"
import "../../utils"

/*
  \qmltype DetailToolbar

  DetailToolbar is a toolbar composed of detail operation controls.
*/
OmekaToolBar {

    property alias liked: like.checked
    property int itemId

    ShareUtils { id: shareUtils }

    //return to previous page
    OmekaButton{
        id: back
        anchors.left: parent.left
        icon: Style.back
        iconScale: .7
        onClicked: navigator.pop()
    }

    //provides content sharing options
    OmekaButton {
        id: share
        anchors.right: like.left
        anchors.margins: 10
        icon: Style.more
        onClicked: shareUtils.share("Ignore Test", Omeka.link+itemId)
    }

    //locally stores item in database
    OmekaToggle {
        id: like
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 5
        defaultSource: Style.detailLikeIndicator
        checkedSource: Style.detailLikeFill
        iconScale: Resolution.applyScale(.60)
    }
}
