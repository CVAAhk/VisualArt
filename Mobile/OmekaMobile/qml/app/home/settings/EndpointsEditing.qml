import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../base"
import "../../../utils"
import "../../clients"

Item {

    ///////////////////////////////////////////////////////////
    //          UI
    ///////////////////////////////////////////////////////////

    Connections {
        target: Omeka
        onLoadComplete: {console.log("ENDPOINT LOADED: "+Omeka.endpoint);indicator.running = false;disable_all_buttons.visible = false;}
    }

    /*!Pairing header and back button*/
    OmekaToolBar {
        id: bar
        backgroundColor: Style.color3
        z: 1

        OmekaText {
            anchors.centerIn: parent
            text: "select an endpoint"
            _font: Style.titleFont
        }

        OmekaButton {
            id: back
            icon: Style.back
            iconScale: .7
            onClicked: if(homeStack) homeStack.pop()
        }
    }

    /*!List of endpoints*/
    OmekaScrollView {
        id: scroll
        width: parent.width
        height: parent.height - bar.height * 2
        anchors.top: bar.bottom
        anchors.topMargin: Resolution.applyScale(95)
        Column {
            ExclusiveGroup { id: endpointsGroup }
            width: scroll.width
            height: childrenRect.height
            spacing: Resolution.applyScale(5)

            //restore initial state when invisible
            onVisibleChanged: {
                if(!visible) {
                    console.log("endpoint visible is false!!")
                    //endpointsGroup.current = default_endpoint.endpointCategory;
                }
            }
            Endpoints
            {
                id: endpoints
                onEndpointChecked:
                {
                    disable_all_buttons.visible = true;
                    indicator.running = true;
                }
            }

        }
    }

    //Add new endpoint
    OmekaText
    {
        id: add_endpoint
        anchors.top: bar.bottom
        anchors.topMargin: Resolution.applyScale(714)
        anchors.left: parent.left
        anchors.leftMargin: Resolution.applyScale(60)
        text: "Add new endpoint"
        _font: Style.addEndpointFont

    }

    Rectangle
    {
        width: parent.width
        height: Resolution.applyScale(150)
        anchors.top: add_endpoint.bottom
        anchors.topMargin: Resolution.applyScale(18)
        color: "white"
        TextInput
        {
            font.capitalization: Font.MixedCase
            font.pixelSize: Resolution.applyScale(68)
            color: "#666666"
            focus: true
            validator: RegExpValidator { regExp: /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/ }
            x: Resolution.applyScale(60)
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            width: 1122
            //height: 26
            selectByMouse: true
            text: qsTr("http://www...")
            z: 1
            selectionColor: "#ffffff"
            onTextChanged:
            {
                var re = new RegExp('^(https?:\\/\\/)?'+ // protocol
                                    '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.?)+[a-z]{2,}|'+ // domain name
                                    '((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
                                    '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
                                    '(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
                                    '(\\#[-a-z\\d_]*)?$','i'); // fragment locator
                var domain = text//.replace("http://", "");
                if(!domain.match(re))
                {
                    color = "red"
                }
                else
                {
                    color = "green"
                }
            }
        }
    }

    Rectangle
    {
        id: disable_all_buttons
        color: "red"
        opacity: 0.8
        visible: false
        anchors.fill: parent
        enabled: visible

        MultiPointTouchArea
        {
            anchors.fill: parent

        }
        OmekaIndicator {
            id: indicator
            anchors.centerIn: parent
            //running: parent.visible
            scale: Resolution.applyScale(1.5)
        }
    }


}
