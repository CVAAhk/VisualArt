import QtQuick 2.5
import "../../utils"

Image {
    anchors.centerIn: img
    //width: 50
    //height: 50
    source: Style.indicator
    asynchronous: true
    visible: running

    property alias running: indicator.running

    RotationAnimator on rotation {
        id: indicator
        from: 0
        to: 360
        duration: 1000
        loops: Animation.Infinite
        running: img.progress < 1
    }
}
