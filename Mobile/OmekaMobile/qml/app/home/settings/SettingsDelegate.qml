import QtQuick 2.0
import QtQuick.Controls 1.4
import "../../../utils"

/*!Setting option*/
Rectangle{
    width: parent.width
    height: 150 * Resolution.scaleRatio

    //text value
    Text {
        id: setting
        text: name
        anchors.centerIn: parent
        font.pointSize: Style.titleSize
        color: Style.titleColor
    }

    //action
    MouseArea{
        anchors.fill: parent
        onClicked: print(setting.text)
    }
}
