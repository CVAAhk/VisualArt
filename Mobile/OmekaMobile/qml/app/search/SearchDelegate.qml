import QtQuick 2.0
import QtQuick.Controls 1.4
import "../base"
import "../../utils"

Rectangle {
    color: Style.viewBackgroundColor
    width: parent.width
    height: 150 * Resolution.scaleRatio

    OmekaText {
        text: tag
        anchors.centerIn: parent
        _font: Style.tagFont
    }
}
