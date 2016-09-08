import QtQuick 2.0
import "../../../base"
import "../../../../utils"

OmekaText {

    property int time: 0

    property int seconds: (time/1000)%60

    property int minutes: (time/1000)/60

    _font: Style.playbackTimeFont
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: Resolution.applyScale(30)

    text: format(minutes, '0', 2)+":"+format(seconds, '0', 2)

    function format(value, pad, length) {
        return (new Array(length+1).join(pad)+value).slice(-length)
    }
}
