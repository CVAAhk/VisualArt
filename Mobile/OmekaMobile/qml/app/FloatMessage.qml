import QtQuick 2.5
import "../utils"

Rectangle {
    id: root

    state: "hide"

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom

    width: messageText.width + padding
    height: messageText.height + padding
    radius: 50

    property var minWidth: 200
    property var maxWidth: 400
    property var padding: 20
    property var autoHide: false
    property var autoHideDelay: 0

    property alias text: messageText.text

    Text {
        id: messageText
        color: "white"
        //text: "test errortest errortest errortest errortest errortest error"
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.pixelSize: 14

        onContentWidthChanged: {
            console.log(contentWidth)
            if(contentWidth < minWidth) {
                width = minWidth
            } else if(contentWidth > maxWidth) {
                width = maxWidth
            }
        }
    }

    function showError(message, autoHide, margin) {
        show(message, autoHide, margin ? margin : 100, "red");
    }

    function showMessage(message, autoHide, margin) {
        show(message, autoHide, margin ? margin : 100, "#656565");
    }

    function show(message, autoHide, margin, color) {
        root.color = color;
        root.text = message;
        root.autoHide = autoHide;
        root.anchors.bottomMargin = margin;
        root.state = "show"
    }

    function hide() {
        root.autoHideDelay = 0
        root.state = "hide"
    }

    onOpacityChanged: {
        if(opacity === 1 && autoHide) {
            root.autoHideDelay = 2000
            root.state = "hide"
        }
    }

    states: [
        State {
            name: "show"
            PropertyChanges { target: root; opacity: 1; autoHideDelay: 0 }
        },
        State {
            name: "hide"
            PropertyChanges { target: root; opacity: 0 }
        }
    ]

    transitions: Transition {
        SequentialAnimation {
            PauseAnimation { duration: root.autoHideDelay }
            PropertyAnimation { duration: 500; property: "opacity"; easing.type: Easing.OutQuad }
        }
    }
}
