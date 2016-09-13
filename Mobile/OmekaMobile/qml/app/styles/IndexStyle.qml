import QtQuick 2.5
import QtQuick.Controls.Styles 1.4
import "../../utils"

RadioButtonStyle {
    indicator: Image {
        fillMode: Image.PreserveAspectFit
        source: Style.index
        width: Resolution.applyScale(45)

        Image {
            anchors.fill: parent
            source: Style.indexFill
            visible: control.checked
        }
    }

}
