import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../../utils"

Flickable {
    id: flick
    interactive: visible

    property alias source: img.source
    property real imgWidth
    property real imgHeight
    property real initWidth
    property real initHeight
    property real initScale: 1
    property real minScale: 1
    property real maxScale: 10

    Binding on contentWidth { when: imgWidth; value: imgWidth }
    Binding on contentHeight { when: imgHeight; value: imgHeight }

    PinchArea {
        id: pinchArea        
        enabled: fullScreen
        width: flick.contentWidth
        height: flick.contentHeight

        onPinchStarted: {
            initWidth = flick.contentWidth
            initHeight = flick.contentHeight
            initScale = initWidth/imgWidth
        }

        onPinchUpdated: {
            flick.contentX += pinch.previousCenter.x - pinch.center.x
            flick.contentY += pinch.previousCenter.y - pinch.center.y
            initScale = (initWidth*pinch.scale)/imgWidth
            if(initScale > minScale && initScale < maxScale) {
                flick.resizeContent(initWidth*pinch.scale, initHeight*pinch.scale, pinch.center)
            }
        }

        onPinchFinished: {
           flick.returnToBounds()
        }        

        Rectangle {
            anchors.fill: parent
            MouseArea { anchors.fill: parent }

            Image {
                id: img
                anchors.fill: parent
                asynchronous: true
            }
        }
    }
}
