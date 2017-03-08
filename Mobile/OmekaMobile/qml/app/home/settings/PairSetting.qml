import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../base"
import "../../../utils"

Item {
    id: setting
    width: parent.width
    height: childrenRect.height

    /*! \qml property string Setting::title
      Setting name
    */
    property alias title: category.text

    /*! \qml property string Setting::checked
      Setting selected state
    */
    property alias selected: category.checked

    //toggles the expanded state of setting
    Button{
        id: category
        width: parent.width
        height: Resolution.applyScale(150)
        z: 1
        checkable: true
        exclusiveGroup: settingsGroup

        //cutom style
        style: ButtonStyle {
            background: Rectangle { color: "white" }
            label: OmekaText {
                text: control.text
                _font: Style.settingFont
                center: true
            }
        }
    }
}
