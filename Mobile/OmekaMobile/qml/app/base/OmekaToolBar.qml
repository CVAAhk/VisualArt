import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../utils"

ToolBar {

    property color backgroundColor: Style.toolBarColor

    //scaled height
    implicitHeight: Resolution.applyScale(192)

    /*!custom background*/
    style: ToolBarStyle{
        background: Rectangle{
            gradient:Gradient {
                GradientStop { position: 0; color: backgroundColor }
            }
        }
    }
}
