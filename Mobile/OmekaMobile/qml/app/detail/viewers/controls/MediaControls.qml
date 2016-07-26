import QtQuick 2.5
import QtMultimedia 5.5
import "../../../base"
import "../../../../utils"

Item {
    id: root
    visible: height
    z: 1

    property alias player: scrubber.player
    property var media
    property real scalar
    property Rectangle size

    //media bindings
    Binding on player { when: media; value: media.current.player }
    Binding on rotation { when: media; value: media.current.orientation }
    Binding on size { when: media; value: media.current.background }
    Binding on scalar { when: media; value: Resolution.portrait ? media.scale : 1 }
    Binding on width { when: size; value: size.width  }
    Binding on height { when: size; value: size.height * scalar }

    //on touch, toggle between play and pause states
    MouseArea {
        enabled: scrubber.visible
        anchors.fill: parent
        onClicked: {
            if(player.playbackState === MediaPlayer.PlayingState)
                player.pause()
            else
                player.play()
        }
     }

    //full screen mode toggle control
    OmekaToggle {
       id: toggle
       anchors.top: parent.top
       anchors.right: parent.right
       anchors.margins: 10
       defaultSource: Style.maximize
       checkedSource: Style.minimize
       iconScale: .5
       onCheckedChanged: ItemManager.fullScreen = checked
    }

    //playback scrubbing
    Scrubber {
       id: scrubber
    }
}
