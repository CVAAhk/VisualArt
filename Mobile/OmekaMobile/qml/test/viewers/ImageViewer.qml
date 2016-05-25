import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    visible: true
    width: 470; height:800  

    Flickable{
        id: flick
        anchors.fill: parent
        contentWidth: 500
        contentHeight: 500

        PinchArea{
            id: zoom
            width: Math.max(flick.contentWidth, flick.width)
            height: Math.max(flick.contentHeight, flick.height)

            property real initialWidth
            property real initialHeight
            property real scaledWidth
            property real scaledHeight

            onPinchStarted: {
                initialWidth = flick.contentWidth
                initialHeight = flick.contentHeight
            }

            onPinchUpdated: {
                flick.contentX += pinch.previousCenter.x - pinch.center.x;
                flick.contentY += pinch.previousCenter.y - pinch.center.y;
                scaledWidth = clamp(initialWidth * pinch.scale, 500, 5000);
                scaledHeight = clamp(initialHeight * pinch.scale, 500, 5000);
                flick.resizeContent(scaledWidth, scaledHeight, pinch.center)
            }

            onPinchFinished: {
                flick.returnToBounds()
            }

            Rectangle{
                width: flick.contentWidth
                height: flick.contentHeight
                color: "white"
                Image{
                    anchors.fill: parent
                    source: "image://testprovider/http://mallhistory.org//files//original//0ef6913467dd1ef22e66e2c0b2cb63ae.jpg"
                    MouseArea{
                        anchors.fill: parent
                    }
                }
            }
        }
    }

    Button{
        anchors.right: parent
        id: button
        state: "FULL"

        states: [
            State{
                name: "FULL"
                PropertyChanges { target: button; text: "FULL" }
                PropertyChanges { target: zoom; enabled: false }
                PropertyChanges { target: flick; contentWidth: 500; contentHeight: 500 }
            },
            State{
                name: "MIN"
                PropertyChanges { target: button; text: "MIN" }
                PropertyChanges { target: zoom; enabled: true }
                PropertyChanges { target: flick; contentWidth: 500; contentHeight: 500 }
            }
        ]

        onClicked: {
            state = state === "FULL" ? "MIN" : "FULL"
        }
    }

    function clamp(value, min, max){
        return value < min ? min : value > max ? max : value;
    }
}
