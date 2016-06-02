import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import "../styling"

ApplicationWindow {
    id:window
    visible: true
    width: 470; height: 804

    property real refWidth: 1440
    property real refHeight: 2464
    property real h: Math.max(width, height)
    property real w: Math.min(width, height)
    property real scaleRatio: Math.min(h/refHeight, w/refWidth)

    toolBar: ToolBar{
        implicitHeight: 192 * scaleRatio
        style: ToolBarStyle {
            background: Rectangle {
                gradient: Gradient {
                    GradientStop { position: 0 ; color: Style.toolBarColor }
                }
            }
        }

        TitleText{
            id: title
            anchors.centerIn: parent
            text: "Styles Test"
            font.pixelSize: Style.titleFontSize * scaleRatio
        }
    }

}
