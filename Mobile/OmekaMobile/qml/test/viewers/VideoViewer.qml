import QtQuick 2.0
import QtQuick.Controls 1.4
import QtMultimedia 5.5

ApplicationWindow {
    visible:true
    width: 470; height:800

    Video{
        id: video
        anchors.fill: parent
        source: "http://mallhistory.org//files//original//0bde734d5564f2d10a2f6de6c8c6ba97.mp4"

        Button{
            id: button
            anchors.centerIn: parent
            state: "pause"

            states:[
                State{
                    name: "play"
                    PropertyChanges { target: button; text: "Pause" }
                },
                State{
                    name: "pause"
                    PropertyChanges { target: button; text: "Play" }
                }
            ]

            onClicked: {
                if(button.state === "pause"){
                    button.state = "play"
                    video.play()
                }
                else{
                    button.state = "pause"
                    video.pause()
                }
            }
        }

        Text{
            id: elapsed
            anchors.verticalCenter: progress.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15
            text: video.position
        }

        Text{
            id: remaining
            anchors.verticalCenter: progress.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 15
            text: video.duration - video.position
        }

        ProgressBar{
            id: progress
            width: parent.width-100
            height: 5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 200
            minimumValue: 0
            maximumValue: video.duration
            value: video.position
        }
    }
}
