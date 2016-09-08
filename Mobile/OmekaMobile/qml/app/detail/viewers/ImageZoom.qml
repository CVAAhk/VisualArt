import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../../utils"

Flickable {
    id: flick
    interactive: visible

    property Image source
    property real initWidth
    property real initHeight
    property real minScale: 1
    property real maxScale: 10

    property real minWidth
    property real maxWidth
    property real minHeight
    property real maxHeight

    Binding on minWidth {when: source; value: source.width * minScale}
    Binding on maxWidth {when: source; value: source.width * maxScale}
    Binding on minHeight {when: source; value: source.height * minScale}
    Binding on maxHeight {when: source; value: source.height * maxScale}


    PinchArea {
        id: pinchArea        
        enabled: fullScreen
        width: flick.contentWidth
        height: flick.contentHeight

        onPinchStarted: {
            initWidth = flick.contentWidth
            initHeight = flick.contentHeight
        }

        onPinchUpdated: {
            flick.contentX += pinch.previousCenter.x - pinch.center.x
            flick.contentY += pinch.previousCenter.y - pinch.center.y
            flick.resizeContent(initWidth*pinch.scale, initHeight*pinch.scale, pinch.center)
        }

        onPinchFinished: {
           flick.returnToBounds()
        }

        Rectangle {
            anchors.fill: parent
            MouseArea { anchors.fill: parent }

            Image {
                source: flick.source.source
                anchors.fill: parent
                asynchronous: true
            }
        }
    }
}
