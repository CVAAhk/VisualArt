import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../../utils"
import "../../base"

/*!
  \qmltype LayoutSetting

  LayoutSetting is a user setting controlling the display of the application's item browsers
*/
Setting {

    id: setting

    /*! \internal
      Layout names
    */
    property var model: ["List", "Grid", "Cascade"]

    //ensures single layout selection and update database
    ExclusiveGroup {
        id: layout
        Component.onCompleted: current = list.contentItem.children[User.getLayout()]
        onCurrentChanged: User.setLayout(model.indexOf(current.text))
    }

    //list view of layout options
    content: ListView {
        id: list
        height: childrenRect.height
        spacing: 2
        model: setting.model
        delegate: delegate
    }

    //layout option delegate
    Component {
        id: delegate
        Button {
            width: parent.width
            height: Resolution.applyScale(150)
            text: list.model[index]
            checkable: true
            exclusiveGroup: layout

            style: ButtonStyle {
                background: Rectangle { color: control.checked ? Style.checkedTabColor : "white" }
                label: OmekaText {
                    text: control.text
                    color: control.checked ? "white" : Style.checkedTabColor
                    _font: Style.settingFont
                    font.pixelSize: Resolution.applyScale(55)
                    center: true
                }
            }
        }
    }

}
