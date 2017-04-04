import QtQuick 2.5
import "."

Item {
    opacity: 0
    property bool play: true

    Image {
        source: Style.play
        anchors.fill: parent
        visible: indicator.play
    }

    Image {
        source: Style.pause
        anchors.fill: parent
        visible: !indicator.play
    }

    onPlayChanged: animation.restart()
    ParallelAnimation {
        id: animation
        PropertyAnimation { target: indicator; property: "opacity"; from: 1; to: 0; duration: 500 }
        PropertyAnimation { target: indicator; property: "scale"; from: 1; to: 2.5; duration: 500 }
    }
}
