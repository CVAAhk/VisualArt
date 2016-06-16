import QtQuick 2.0
import "../../utils"

Text {
    property variant _font
    color: _font.color
    wrapMode: _font.wrapMode
    textFormat: _font.textFormat
    font.pixelSize: Resolution.applyScale(_font.size)
    font.weight: _font.weight
    font.capitalization: _font.capitalization
}
