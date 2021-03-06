import QtQuick 2.5

import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import QtQml.Models 2.2
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

    signal endpointChecked(var url);

    signal endpointPressAndHold(var url);

    //prevent multiple selections
    ExclusiveGroup {
        id: group
    }

    //endpoints list
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

        model: ListModel {}


    }

    //filter options
    Component {
        id: delegate
        Button {
            id: button
            width: parent.width
            height: Resolution.applyScale(150)
            text: name
            checkable: true
            checked: check
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
                    if(Omeka.endpoint != urlText && urlText !== null)
                    {
                        Omeka.endpoint = urlText;
                        root.endpointChecked(urlText);
                        User.setLastSelectedEndpoint(urlText);
                    }
                }
            }


               Timer {
                   id: longPressTimer

                   interval: 500 //your press-and-hold interval here
                   repeat: false
                   running: false

                   onTriggered: {
                       button.checkable = false;

                       root.endpointPressAndHold(urlText);
                   }
               }

               onPressedChanged: {
                   if ( pressed ) {
                       longPressTimer.running = true;

                   } else {
                       longPressTimer.running = false;
                   }
               }
        }
    }

    function checkFirstEndpoint()
    {
        root.current = null;
        if(list.contentItem.children[0].text !== undefined)
        {
            root.current = list.contentItem.children[0]
        }
        else
        {
            root.current = list.contentItem.children[1]
        }
    }


    /*
      Add item to list
    */
    function addEndpoint(title, url, check) {
        list.model.append({name: title, urlText: url, check: check})
    }

    /*
      Add item to top of list
    */
    function addEndpointToTop(title, url, check) {
        list.model.insert(0, {name: title, urlText: url, check: check})
    }

    function insertEndpoint(index, title, url, check)
    {
        list.model.insert(index, {name: title, urlText: url, check: check})
    }

    /*
      Remove item by index
    */
    function removeEndpoint(index) {
        if(list.model.count > 1) {
            list.model.remove(index)

        }
    }

    function getListCount()
    {
        return list.count;
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

