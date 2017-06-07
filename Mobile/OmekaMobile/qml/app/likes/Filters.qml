import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../base"
import "../../utils"

Item {
    id: root
    width: parent.width
    height: list.height
    clip: true
    state: "close"

    property var maxVerticalOffset: Resolution.applyScale(438)
    property var verticalOffset: Math.min(list.height + list.y, maxVerticalOffset)
    property alias current: group.current

    //prevent multiple selections
    ExclusiveGroup {
        id: group        
        current: list.contentItem.children[0]
    }

    //filter list
    ListView {
        id: list
        width: parent.width
        height: childrenRect.height
        spacing: Resolution.applyScale(-6)
        delegate: delegate
        maximumFlickVelocity: 8000
        flickDeceleration: 3000
        boundsBehavior: Flickable.StopAtBounds
        bottomMargin: height - verticalOffset

        model: ListModel {
            ListElement {
                name: "all"
            }
        }
    }

    //filter options
    Component {
        id: delegate
        Button {
            width: parent.width
            height: Resolution.applyScale(150)
            text: name
            checkable: true
            exclusiveGroup: group

            style: ButtonStyle {
                background: Rectangle {
                    border.color: Style.color1
                    border.width: Resolution.applyScale(6)
                    color: control.checked ? "white" : Style.color3
                }
                label: OmekaText {
                    text: control.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    _font: Style.headerFont
                }
            }
        }
    }

    //open/close states
    states: [
        State {
            name: "open"
            AnchorChanges { target: list; anchors.bottom: root.bottom }
            PropertyChanges { target: root; opacity: 1 }
        },
        State {
            name: "close"
            AnchorChanges { target: list; anchors.bottom: root.top }
            PropertyChanges { target: root; opacity: 0 }
        }
    ]

    //animations
    transitions: Transition {
        AnchorAnimation { duration: 250; easing.type: Easing.OutQuad }
        PropertyAnimation { target: root; property: "opacity"; duration:500; easing.type: Easing.OutQuad }
    }

    /*
      Add item to list
    */
    function addFilter(title) {
        list.model.append({name: title})
    }

    /*
      Remove item by index
    */
    function removeFilter(index) {
        list.model.remove(index+1)
    }

    /*
      Remove all but default list item
    */
    function clear() {
        while(list.model.count > 1) {
            list.model.remove(1)
        }
    }
}
