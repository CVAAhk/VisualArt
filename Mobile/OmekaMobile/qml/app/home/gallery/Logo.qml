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

    width: map(contentY, minY, maxY, minWidth, maxWidth)
    height: map(contentY, minY, maxY, minHeight, maxHeight)
    y: map(contentY, minY, maxY, maxHeight, 0)

    anchors.horizontalCenter: parent.horizontalCenter

    Image{
        id: logo
        anchors.centerIn: parent
        anchors.fill: parent
        anchors.margins: Resolution.applyScale(30)
        fillMode: Image.PreserveAspectFit
    }

    function map(num, min1, max1, min2, max2) {
        if(num < min1) return min2;
        if(num > max1) return max2;
        var num1 = (num - min1) / (max1 - min1)
        return (num1 * (max2 - min2)) + min2
    }
}
