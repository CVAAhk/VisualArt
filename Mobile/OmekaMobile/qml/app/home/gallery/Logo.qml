import QtQuick 2.5
import "../../../utils"

Rectangle {

    property alias source: logo.source

    property real contentY

    property real minY

    property real maxY

    property real minWidth

    property real maxWidth

    property real minHeight

    property real maxHeight

    color: Style.transparent

    width: NumberUtils.map(contentY, minY, maxY, minWidth, maxWidth)
    height: NumberUtils.map(contentY, minY, maxY, minHeight, maxHeight)
    y: NumberUtils.map(contentY, minY, maxY, maxHeight, 0)

    anchors.horizontalCenter: parent.horizontalCenter

    Image{
        id: logo
        anchors.centerIn: parent
        anchors.fill: parent
        anchors.margins: Resolution.applyScale(30)
        fillMode: Image.PreserveAspectFit
    }
}
