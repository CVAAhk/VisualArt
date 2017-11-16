import QtQuick 2.5
import "../../../utils"
import "../../clients"
import "../../base"

Rectangle {

    property alias source: logo.source

    property real contentY

    property real minY

    property real maxY

    property real minWidth

    property real maxWidth

    property real minHeight

    property real maxHeight

    property var title: Omeka.title

    color: Style.transparent

    width: NumberUtils.map(contentY, minY, maxY, minWidth, maxWidth)
    height: NumberUtils.map(contentY, minY, maxY, minHeight, maxHeight)
    y: NumberUtils.map(contentY, minY, maxY, maxHeight, 0)

    anchors.horizontalCenter: parent.horizontalCenter

    onTitleChanged: site_title.text = title

    //main logo image
    Image{
        id: logo
        anchors.centerIn: parent
        anchors.fill: parent
        anchors.margins: Resolution.applyScale(30)
        fillMode: Image.PreserveAspectFit
        onWidthChanged: rect.width = paintedWidth * 0.5
        onHeightChanged: rect.height = paintedHeight * 0.5
    }

    //static image of title text to prevent dynamic text resizing
    //on scroll
    Image {
        id: title_img
        anchors.left: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.leftMargin: Resolution.applyScale(-15)
        width: rect.width
        height: rect.height
        opacity: NumberUtils.map(contentY, minY, maxY, 1, 0)

        onSourceChanged: rect.enabled = false
    }

    //site title display to be exported to an in-memory image
    Item {
        id: rect
        visible: false

        OmekaText {
            id: site_title
            anchors.fill: parent
            anchors.top: parent.top
            anchors.topMargin: Resolution.applyScale(80)
            maximumLineCount: 2
            _font: Style.siteTitleFont

            //using a timer because there is no signal indicating when
            //layout is complete on text change
            onTextChanged: update_timer.restart()
        }
    }

    //grab text to image after a delay permitting text layout to complete
    Timer{
        id: update_timer
        interval: 1000
        onTriggered: {
            rect.grabToImage(function(result){
                title_img.source = result.url
            })
        }
    }
}
