import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../utils"

Rectangle {
    anchors.fill: parent
    color: "#CCCCCC"
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

        //custom style
        style: ProgressBarStyle {
            background: Rectangle {
                radius: Resolution.applyScale(30)
                color: Style.schemeColor3
                implicitHeight: Resolution.applyScale(45)
            }
            progress: Rectangle {
                radius: Resolution.applyScale(30)
                color: Style.schemeColor1
            }
        }
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
