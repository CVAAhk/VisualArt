import QtQuick 2.5
import "."

Text {
    property var _font
    property bool center: false
    property string textColor: ""
    color: textColor !== "" ? textColor : _font.color
    wrapMode: _font.wrapMode
    textFormat: _font.textFormat
    font.pixelSize: _font.size//Resolution.applyScale(_font.size)
    font.weight: _font.weight
    font.capitalization: _font.capitalization
    verticalAlignment: center ? Text.AlignVCenter : Text.AlignTop
    horizontalAlignment: center ? Text.AlignHCenter : Text.AlignTop
    font.family: _font.family
}
