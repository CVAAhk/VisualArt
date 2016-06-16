import QtQuick 2.0
import "../../utils"

Text {
    property variant _font
    color: _font ? _font.color: "black"
    wrapMode: _font ? _font.wrapMode: Text.NoWrap
    textFormat: _font ? _font.textFormat : Text.AutoText
    font.pixelSize: _font ? Resolution.applyScale(_font.size) : 11
    font.weight: _font ? _font.weight : Font.Normal
    font.capitalization: _font ? _font.capitalization : Font.MixedCase    
}
