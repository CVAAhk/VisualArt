import QtQuick 2.0
import QtQuick.Controls 1.4
import QtMultimedia 5.5

ApplicationWindow {
    visible: true
    width: 470; height: 800

    MediaPlayer{
        id: audio
        source: "https://s3.amazonaws.com/omeka-net/15770/archive/files/a0c9a286708c9818fd2b076627f00d6f.mp3?AWSAccessKeyId=AKIAI3ATG3OSQLO5HGKA&Expires=1464318723&Signature=j8Xk2bIp%2FRzAb%2BYGTZhcjp8jxZ8%3D"
    }

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
                audio.play()
            }
            else{
                button.state = "pause"
                audio.pause()
            }
        }
    }

    Text{
        id: elapsed
        anchors.verticalCenter: progress.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 15
        text: audio.position
    }

    Text{
        id: remaining
        anchors.verticalCenter: progress.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 15
        text: audio.duration - audio.position
    }

    ProgressBar{
        id: progress
        width: parent.width-100
        height: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 200
        minimumValue: 0
        maximumValue: audio.duration
        value: audio.position
    }

}
