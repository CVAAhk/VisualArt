import QtQuick 2.5
import "../../base"
import "../../../utils"

Rectangle {
    anchors.left: parent.left
    anchors.leftMargin: Resolution.applyScale(30)
    anchors.top: img.top
    width: parent.width - anchors.leftMargin*2
    height: img.height
    color: "white"
    radius: Resolution.applyScale(30)

    property alias title: title.text
    property alias source: source.text

    Column {
        height: parent.height-anchors.topMargin*2
        width: parent.width - img.width - anchors.topMargin*2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: img.width + anchors.topMargin
        anchors.topMargin: Resolution.applyScale(30)

        OmekaText {
            id: title
            width: parent.width
            height: parent.height * .4
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            _font: Style.infoTitleFont
        }

        Rectangle {
            width: parent.width
            height: parent.height * .01
            color: "#adadad"
        }

        OmekaText {
            id: source
            width: parent.width
            height: parent.height * .4
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            _font: Style.infoSourceFont
        }

    }
}
