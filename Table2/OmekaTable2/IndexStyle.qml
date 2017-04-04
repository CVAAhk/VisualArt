import QtQuick 2.5
import QtQuick.Controls.Styles 1.4
import "."

RadioButtonStyle {
    indicator: Image {
        fillMode: Image.PreserveAspectFit
        source: Style.index
        width: 45 / fillScale//Resolution.applyScale(45) / fillScale

        Image {
            anchors.fill: parent
            source: Style.indexFill
            scale: 0.5
            visible: control.checked
        }
    }

}
