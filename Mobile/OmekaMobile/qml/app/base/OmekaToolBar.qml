import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../utils"

ToolBar {

    property color backgroundColor: Style.backgroundColor

    //scaled height
    implicitHeight: 192 * Resolution.scaleRatio

    /*!custom background*/
    style: ToolBarStyle{
        background: Rectangle{
            gradient:Gradient {
                GradientStop { position: 0; color: backgroundColor }
            }
        }
    }
}
