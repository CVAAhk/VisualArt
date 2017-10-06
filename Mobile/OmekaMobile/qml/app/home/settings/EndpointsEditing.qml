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
        onLoadComplete: console.log("ENDPOINT LOADED: "+Omeka.endpoint)
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

            //default endpoint
            Endpoint
            {
                id: default_endpoint
                title: "UCONN"
                url: "http://oe.develop.digitalmediauconn.org/"
                enableArrow: true
                checked: true
                onCheckedChanged:
                {
                    if(checked) Omeka.endpoint = url;
                }
            }
            Endpoint
            {
                title: "Mall Copy"
                url: "http://dev.omeka.org/mallcopy/"
                enableArrow: false
                checked: false
                onCheckedChanged:
                {
                    if(checked) Omeka.endpoint = url;
                }
            }

        }
    }


}
