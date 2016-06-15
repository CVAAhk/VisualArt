import QtQuick 2.0
import "../base"
import "../../utils"

OmekaText {
    width: parent.width
    height: 150 * Resolution.scaleRatio
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: "tags"
    _font: Style.headerFont
}
