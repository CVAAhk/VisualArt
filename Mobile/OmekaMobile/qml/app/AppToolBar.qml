import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../utils"
import "settings"

ToolBar {
    property real targetHeight: 192
    implicitHeight: targetHeight * Resolution.scaleRatio        

    style: ToolBarStyle{
        background: Rectangle{
            gradient:Gradient {
                GradientStop { position: 0; color: Style.toolBarColor }
            }
        }
    }

    SettingsButton{ }
}
