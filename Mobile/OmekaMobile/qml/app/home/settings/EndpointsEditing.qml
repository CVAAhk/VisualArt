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
