import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../utils"

Rectangle {
    anchors.fill: parent
    color: "red"
    opacity: enabled ? 1 : 0

    property alias progress: bar.value

    //fade transition
    Behavior on opacity {
        SequentialAnimation {
            PauseAnimation {duration: 200} //delay
            PropertyAnimation {}
        }
    }

    //progress indicator
    ProgressBar {
        id: bar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: Resolution.applyScale(100)
        minimumValue: 0
        maximumValue: 1
        Behavior on value { PropertyAnimation{} }
    }

    //disable on load
    onProgressChanged: {
        if(enabled && progress === 1) {
            enabled = false
        }
    }

    //block interaction
    MouseArea { anchors.fill: parent}

}
