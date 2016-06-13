import QtQuick 2.0
import QtQuick.Controls 1.4
import "../../utils"

Rectangle {
    color: Style.backgroundColor
    width: parent.width
    height: 150 * Resolution.scaleRatio

    Text {
        text: tag
        anchors.centerIn: parent
        font.pointSize: Style.titleSize
        font.bold: true
        font.capitalization: Font.Capitalize
        color: Style.titleColor
    }
}
