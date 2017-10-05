import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../../utils"
import "../../base"

/*!
  \qmltype Endpoint

  Endpoint displays the endpoint entry
*/
Item {
    id: root
    width: parent.width
    height: childrenRect.height
    clip: true

    /*! \qml property string Endpoint::title
      Endpoint name
    */
    property alias title: category.text

    /*! \qml property string Endpoint::url
      Endpoint url
    */
    property alias url: url.text



    /*! \qml property bool Setting::uncheck
      Uncheck currently selected
    */
    property bool uncheck: false

    property real transitionTime: 0

    /*! \qml property bool Setting::checked
      Checked state
    */
    property alias checked: category.checked

    /*! \qml property bool Setting::enableArrow
      Enables/disables rendering of arrow
    */
    property alias enableArrow: arrow.visible

    property alias endpointCategory: category

    //change state on check
    onCheckedChanged: {
        console.log("endpoint ", title, " check is ", checked)
        arrow.visible = checked;
    }

    //set initial state after dimensions
    onWidthChanged: {
        if(width) {
            //state = "collapse"
            //transitionTime = 250
        }
    }

    //content bindings
//    Binding { target: content; property: "parent"; value: setting }
//    Binding { target: content; property: "width"; value: setting.width }
//    Binding { target: content.anchors; property: "topMargin"; value: 2 }

    //toggles the expanded state of setting
    Button{
        id: category
        width: parent.width
        height: Resolution.applyScale(150)
        z: 1
        checkable: true
        checked: true
        exclusiveGroup: endpointsGroup

        //cutom style
        style: ButtonStyle {
            background: Rectangle { color: "white" }
            label: OmekaText {
                _font: Style.endpointsTitleFont
                text: control.text

                //center: true
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: Resolution.applyScale(60)
                anchors.topMargin: Resolution.applyScale(10)
            }
        }

        OmekaText
        {
            id: url
            _font: Style.endpointsUrlFont
            text: ""
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: Resolution.applyScale(60)
            anchors.topMargin: Resolution.applyScale(86)
        }

        //checked indicator
        Image {
            id: arrow
            height: parent.height * .35
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: Resolution.applyScale(30)
            source: Style.checkMark
            //visible: exclusiveGroup.current === category
        }

        //check current selection
        onPressedChanged: {
            if(pressed&&!checked) {
                uncheck = exclusiveGroup.current === category

            }
        }
    }


}
