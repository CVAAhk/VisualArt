import QtQuick 2.5
import "../utils"
import "../app/base"

Rectangle {
    id: root

    //initially invisible
    state: "hide"
    visible: opacity !== 0;

    //position
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom

    //display
    width: messageText.width + padding
    height: messageText.height + padding
    radius: 50

    //constraints
    property real minWidth: 200
    property real maxWidth: 400
    property real padding: 20

    /*! Triggers hide state after set interval */
    Timer {
        id: hideTimer
        onTriggered: hide();
    }

    /*! Message display */
    OmekaText {
        id: messageText
        _font: Style.floatMessageFont
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        //constrain message widh
        onTextChanged: {
            if(contentWidth < minWidth) {
                width = minWidth
            } else if(contentWidth > maxWidth) {
                width = maxWidth
            }
        }
    }

    /*!
      Set error message to display
      \a message  The message value
      \a duration  The time to display the message. Negative values imply display indefinitely until hide is explicitly called.
      \a margin  The margin between the bottom of the message and the bottom of the viewport.
    */
    function showError(message, duration, margin) {
        show(message, duration, margin, "red");
    }

    /*!
      Set standard message to display
      \a message  The message value
      \a duration  The time to display the message. Negative values imply display indefinitely until hide is explicitly called.
      \a margin  The margin between the bottom of the message and the bottom of the viewport.
    */
    function showMessage(message, duration, margin) {
        show(message, duration, margin, "#656565");
    }

    /*!
      Show message based on specified parameters
      \a message  The message value
      \a duration  The time to display the message. Negative values imply display indefinitely until hide is explicitly called.
      \a margin  The margin between the bottom of the message and the bottom of the viewport.
      \a color  The background color of text area to indicate message type
    */
    function show(message, duration, margin, color) {
        hideTimer.stop();

        root.color = color;
        messageText.text = message;
        root.anchors.bottomMargin = margin;
        root.state = "show";

        if(duration > 0) {
            hideTimer.interval = duration;
            hideTimer.start();
        }
    }

    /*!
      Hide message
    */
    function hide() {
        root.state = "hide";
    }

    //display states
    states: [
        State {
            name: "show"
            PropertyChanges { target: root; opacity: 1 }
        },
        State {
            name: "hide"
            PropertyChanges { target: root; opacity: 0 }
        }
    ]

    //state animations
    transitions: Transition {
        PropertyAnimation { duration: 1000; property: "opacity"; easing.type: Easing.OutQuad }
    }
}
