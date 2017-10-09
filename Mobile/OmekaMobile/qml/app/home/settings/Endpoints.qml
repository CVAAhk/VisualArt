import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../../utils"
import "../../base"
import "../../clients"

/*!
  \qmltype Endpoint

  Endpoint displays the endpoint entry
*/
Item {
    id: root
    width: parent.width
    height: list.height
    clip: true

    property var maxVerticalOffset: Resolution.applyScale(438)
    property var verticalOffset: Math.min(list.height + list.y, maxVerticalOffset)
    property alias current: group.current

    signal endpointChecked();

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
                name: "OMEKA EVERYWHERE"
                urlText: "http://oe.develop.digitalmediauconn.org/"
                checked: true
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
            //property alias urlText: url.text

            style: ButtonStyle {
                background: Rectangle {
                    border.color: Style.color1
                    border.width: Resolution.applyScale(6)
                    color: control.checked ? "white" : Style.color3
                }
                label: OmekaText {
                    text: control.text
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: Resolution.applyScale(60)
                    anchors.topMargin: Resolution.applyScale(10)
                    _font: Style.headerFont
                    //font.pixelSize: Resolution.applyScale(40)
                }
            }

            OmekaText
            {
                id: url
                _font: Style.endpointsUrlFont
                text: urlText
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: Resolution.applyScale(60)
                anchors.topMargin: Resolution.applyScale(86)
            }
            onCheckedChanged:
            {
                if(checked)
                {
                    Omeka.endpoint = urlText;
                    root.endpointChecked();
                }
            }
        }
    }

    /*
      Add item to list
    */
    function addEndpoint(title, url) {
        list.model.append({name: title, urlText: url})
    }

    /*
      Remove item by index
    */
    function removeEndpoint(index) {
        if(list.model.count > 1) {
            list.model.remove(index+1)
        }
    }

    /*
      Remove all but default list item
    */
    function clear() {
        while(list.model.count > 1) {
            list.model.remove(1)
        }
    }

    /*
      Reset selection to default
    */
    function reset() {
        current = list.contentItem.children[0]
    }
}

