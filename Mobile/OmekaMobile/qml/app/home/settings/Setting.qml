import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../../utils"
import "../../base"

/*!
  \qmltype Setting

  Setting is a control composed of a category item and content item used to modify
  or display user settings
*/
Item {
    id: setting
    width: parent.width
    height: childrenRect.height

    /*! \qml property string Setting::text
      Setting name
    */
    property alias text: category.text

    /*! \qml property Item Setting::content
      Setting name
    */
    property Item content

    //content bindings
    Binding { target: content; property: "parent"; value: setting }
    Binding { target: content; property: "width"; value: setting.width }
    Binding on state {when: content; value: category.checked ? "expand" : "collapse" }

    //toggles the expanded state of setting
    Button{
        id: category
        width: parent.width
        height: Resolution.applyScale(150)        
        z: 1
        checkable: true

        //cutom style
        style: ButtonStyle {
            background: Rectangle {}
            label: OmekaText {
                _font: Style.settingFont
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: control.text
            }
        }

        //expanded indicator
        Image {
            id: arrow
            source: Style.expand
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
        }
    }

    //collapse and expand states
    states: [
        State {
            name: "expand"
            AnchorChanges { target: content; anchors.top: category.bottom }
        },
        State {
            name: "collapse"
            PropertyChanges { target: content; explicit: true; height: category.height }
            PropertyChanges { target: arrow; explicit: true; opacity: 0 }
            AnchorChanges { target: content; anchors.top: category.top }
        }
    ]

    //state transitions
    transitions: Transition {
        AnchorAnimation { duration: 250; easing.type: Easing.OutQuad }
        PropertyAnimation { target: content; property: "height"; duration: 250; easing.type: Easing.OutQuad }
        PropertyAnimation { target: arrow; property: "opacity"; duration: 250; easing.type: Easing.OutQuad }
    }
}
