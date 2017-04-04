import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "."

Rectangle {
    id: load
    //anchors.fill: parent
    color: "#CCCCCC"
    enabled: bar.value !== 1
    opacity: enabled ? 1 : 0

    property real progress: 0

    //update progress bar
    onProgressChanged: {
        if(enabled) {
            bar.value = progress
            console.log("load bar value = ", bar.value)
        }
    }

    //fade transition
    Behavior on opacity {
        SequentialAnimation {
            PauseAnimation {duration: 200} //delay
            PropertyAnimation {}
        }
    }

    //block interaction
    MouseArea { anchors.fill: parent}
    //progress indicator
    ProgressBar {
        id: bar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 30//Resolution.applyScale(100)
        minimumValue: 0
        maximumValue: 1
        Behavior on value { PropertyAnimation{} }

        //custom style
        style: ProgressBarStyle {
            background: Rectangle {
                radius: 10//Resolution.applyScale(30)
                color: Style.color3
                implicitHeight: 15//Resolution.applyScale(45)
            }
            progress: Rectangle {
                radius: 10//Resolution.applyScale(30)
                color: Style.color2
            }
        }
    }

//    //load display
//    Column {
//        width: parent.width
//        height: parent.height//childrenRect.height
//        anchors.verticalCenter: parent.verticalCenter
//        spacing: 150//Resolution.applyScale(150)

//        //progress indicator
//        ProgressBar {
//            id: bar
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.margins: 150//Resolution.applyScale(100)
//            minimumValue: 0
//            maximumValue: 1
//            Behavior on value { PropertyAnimation{} }

//            //custom style
//            style: ProgressBarStyle {
//                background: Rectangle {
//                    radius: 30//Resolution.applyScale(30)
//                    color: Style.color3
//                    implicitHeight: 45//Resolution.applyScale(45)
//                }
//                progress: Rectangle {
//                    radius: 30//Resolution.applyScale(30)
//                    color: Style.color1
//                }
//            }
//        }

//        //cancel load
//        Button {
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.margins: 450//Resolution.applyScale(450)
//            height: 150//Resolution.applyScale(150)
//            //onClicked: navigator.pop()
//            text: "CANCEL"
//            style: ButtonStyle {
//                background: Rectangle {
//                    implicitWidth: control.width
//                    implicitHeight: control.height
//                    border.color: Style.color1
//                    color: load.color
//                }
////                label: Text {
////                    color: Style.color1
////                    verticalAlignment: Text.AlignVCenter
////                    horizontalAlignment: Text.AlignHCenter
////                    text: control.text
////                    font.pointSize: 13
////                }
//            }
//        }
//    }
}
