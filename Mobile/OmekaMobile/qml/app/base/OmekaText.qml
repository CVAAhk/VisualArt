import QtQuick 2.0
import "../../utils"

Text {
    property variant _font
    property bool center: false
    color: _font.color
    wrapMode: _font.wrapMode
    textFormat: _font.textFormat
    font.pixelSize: Resolution.applyScale(_font.size)
    font.weight: _font.weight
    font.capitalization: _font.capitalization   
    verticalAlignment: center ? Text.AlignVCenter : Text.AlignTop
    horizontalAlignment: center ? Text.AlignHCenter : Text.AlignTop
}
