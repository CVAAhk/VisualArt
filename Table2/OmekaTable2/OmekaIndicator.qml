import QtQuick 2.5
import "."

Image {
    anchors.centerIn: img
    source: Style.indicator
    asynchronous: true
    visible: running
    width: 68; height: 68

    property alias running: indicator.running

    RotationAnimator on rotation {
        id: indicator
        from: 0
        to: 360
        duration: 1000
        loops: Animation.Infinite
    }
}
