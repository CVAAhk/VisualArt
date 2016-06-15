import QtQuick 2.0

Text {
    property variant _font
    color: _font ? _font.color: "black"
    font.pixelSize: _font ? _font.size : 11
    font.weight: _font ? _font.weight : Font.Normal
    font.capitalization: _font ? _font.capitalization : Font.MixedCase
}
