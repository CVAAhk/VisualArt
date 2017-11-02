import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../base"
import "../../../utils"
import "../../clients"
import "../../styles"

Item {
    id: root

    property string endpoint_url: url_input.text

    //default endpoint title and url
    property var omekaIDs: ["omeka_mallcopy"]
    property var omekaTitles: ["MALL HISTORY COPY"]
    property var omekaUrls: ["http://dev.omeka.org/mallcopy/"]

    property int currentDeletingIndex: -1

    property int currentCheckedIndex: 0        

    ///////////////////////////////////////////////////////////
    //          UI
    ///////////////////////////////////////////////////////////

    //initialize loading endpoints from local storage
    Component.onCompleted: {
        var entry
        var url
        var omekaID

        var _endpoints = ItemManager.getEndpoints()
        for(var i=0; i<_endpoints.length; i++) {
            entry = _endpoints[i]
            omekaID = entry.setting
            url = entry.value
            Omeka.getSiteInfo(root, url + "api/");
        }
    }

    Connections {
        target: Omeka
        onLoadComplete: {
            indicator.running = false;
            disable_all_buttons.visible = false;
        }
        onSiteInfo: {
            if(result.context === root) {
                for(var i = 0; i < omekaIDs.length; i++)
                {
                    if(result.omekaID === omekaIDs[i])
                    {
                        return;
                    }
                }
                var revised_url = result.url.slice(0, (result.url.length - 4));
                omekaIDs.push(result.omekaID)
                omekaTitles.push(result.title)
                omekaUrls.push(revised_url)

                var revised_title
                if(result.title.length > 40)
                {
                    revised_title = result.title.slice(0, 40);
                    revised_title += "..."
                }
                else
                {
                    revised_title = result.title;
                }


                var url_length = result.url.length

                if(omekaTitles.length == 1)
                {
                    endpoints.addEndpoint(revised_title, revised_url, true)
                    Omeka.endpoint = revised_url;
                }
                else
                {
                    endpoints.addEndpoint(revised_title, revised_url, false)
                }


            }

            //add site title as endpoint
            if(result.context === add_endpoint_btn) {
                for(var i = 0; i < omekaIDs.length; i++)
                {
                    if(result.omekaID === omekaIDs[i])
                    {
                        return;
                    }
                }

                omekaIDs.push(result.omekaID)
                omekaTitles.push(result.title)
                omekaUrls.push(root.endpoint_url)

                var revised_title
                if(result.title.length > 40)
                {
                    revised_title = result.title.slice(0, 40);
                    revised_title += "..."
                }
                else
                {
                    revised_title = result.title;
                }

                endpoints.addEndpoint(revised_title, root.endpoint_url, false)

                var endpoint = ({});
                endpoint.omekaID = result.omekaID;
                endpoint.url = root.endpoint_url;
                endpoint.title = result.title;

                ItemManager.registerEndpoint(endpoint);
                resetAddNewEndpointArea();
            }
            //text input changes
            if(result.context === url_input){
                url_input.color = "green"

                add_endpoint_btn.visible = true

                Foreground.hideMessage();
            }

        }
        onDisabledAPI: {

            if(context === url_input)
            {
                url_input.color = "red"

                add_endpoint_btn.visible = false;

                root.endpointError("INVALID URL. MAKE SURE API IS ENABLED.");
            }
        }
    }

    /*!Pairing header and back button*/
    OmekaToolBar {
        id: bar
        backgroundColor: Style.color3
        z: 0

        OmekaText {
            anchors.centerIn: parent
            text: "select a site to load"
            _font: Style.titleFont
        }

        OmekaButton {
            id: back
            icon: Style.back
            iconScale: .7
            onClicked: if(homeStack) homeStack.pop()
        }
    }

    OmekaText {
        id: description
        anchors.top: bar.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.95
        height: contentHeight
        _font: Style.siteListFont
        text: User.omekaSiteList
    }

    /*!List of endpoints*/
    OmekaScrollView {
        id: scroll
        width: parent.width
        anchors.top: description.bottom
        anchors.topMargin: Resolution.applyScale(30)
        anchors.bottom: add_endpoint.top
        anchors.bottomMargin: Resolution.applyScale(30)

        Column {
            ExclusiveGroup { id: endpointsGroup }
            width: scroll.width
            height: childrenRect.height
            spacing: Resolution.applyScale(5)

            Endpoints
            {
                id: endpoints
                onEndpointChecked:
                {
                    disable_all_buttons.visible = true;
                    indicator.running = true;
                    for(var i = 0; i < omekaUrls.length; i++)
                    {
                        if(url == omekaUrls[i])
                        {
                            root.currentCheckedIndex = i
                        }
                    }
                }
                onEndpointPressAndHold:
                {
                    if(omekaUrls.length === 1)
                    {
                        return;
                    }
                    for(var i = 0; i < omekaUrls.length; i++)
                    {
                        if(url == omekaUrls[i])
                        {
                            root.currentDeletingIndex = i
                        }
                    }
                    confirm_delete_endpoint.visible = true;

                }
            }

        }
    }

    //Add new endpoint
    OmekaText
    {
        id: add_endpoint
        anchors.bottom: edit_url_area.top
        anchors.bottomMargin: Resolution.applyScale(30)
        anchors.left: parent.left
        anchors.leftMargin: Resolution.applyScale(30)
        text: "Add new site"
        _font: Style.addEndpointFont
    }

    Rectangle
    {
        id: edit_url_area
        width: parent.width
        height: Resolution.applyScale(150)
        anchors.bottom: add_endpoint_btn.top
        anchors.bottomMargin: Resolution.applyScale(100)
        color: "white"

        TextInput
        {
            id: url_input
            font.capitalization: Font.MixedCase
            font.pixelSize: Resolution.applyScale(68)
            //style: SearchBarStyle {}
            focus: true
            validator: RegExpValidator { regExp: /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/ }//TODO: better validator
            anchors.fill: parent
            anchors.margins: Resolution.applyScale(15)
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            width: 1122
            color: "#666666"
            selectByMouse: true
            text: qsTr("http://www...")
            //z: 1
            selectionColor: Style.color1
            onActiveFocusChanged:
            {
                if(activeFocus)
                {
                    if(url_input.text === "http://www...")
                        url_input.text = "http://"
                    clear.visible = true
                }
            }

            onTextChanged:
            {


//                var re = new RegExp('^(https?:\\/\\/)?'+ // protocol

//                                    '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.?)+[a-z]{2,}|'+ // domain name
//                                    '((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
//                                    '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
//                                    '(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
//                                    '(\\#[-a-z\\d_]*)?$','i'); // fragment locator

                if(text !== "http://www..." && text !== "http://")
                    Omeka.getSiteInfo(url_input, text + "api/");
            }
        }
        //clear field control
        OmekaButton {
            id: clear
            enabled: visible
            visible: false
            anchors.right: url_input.right
            icon: Style.clear
            iconScale: .52
            onClicked:
            {
                url_input.text = "http://www...";
                url_input.focus = false;
                clear.visible = false;
                url_input.color = "#666666"
                Foreground.hideMessage();
                add_endpoint_btn.visible = false;
            }
        }
    }

    Button {
        id: add_endpoint_btn
        width: parent.width/3
        height: Resolution.applyScale(122)
        anchors.horizontalCenter: root.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Resolution.applyScale(300)
        onClicked: {Omeka.getSiteInfo(add_endpoint_btn, root.endpoint_url + "api/"); console.log("add endpoint btn clicked!", root.endpoint_url + "/api/")}
        visible: false
        enabled: visible

        style: ButtonStyle {
            background: Rectangle {
                color: Style.color1
                radius: Resolution.applyScale(30)
            }
            label: OmekaText {
                center: true
                text: "ADD SITE"
                _font: Style.addEndpointBtnFont
            }
        }
    }

    Rectangle
    {
        id: disable_all_buttons
        color: "white"
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
    //confirm delete an endpoint
    Rectangle
    {
        id: confirm_delete_endpoint
        color: "white"
        opacity: 0.8
        visible: false
        anchors.fill: parent
        enabled: visible

        MultiPointTouchArea
        {
            anchors.fill: parent

        }
        OmekaText
        {
            width: root.width
            anchors.top: parent.top
            anchors.topMargin: Resolution.applyScale(400)
            anchors.horizontalCenter: parent.horizontalCenter
            center: true
            text: "ARE YOU SURE YOU WANT TO DELETE THE URL?"
            _font: Style.deleteFont
        }

        Button {
            id: delete_btn
            width: parent.width/4
            height: Resolution.applyScale(122)
            x: parent.width/6
            anchors.top: parent.top
            anchors.topMargin: Resolution.applyScale(800)
            property bool endpointIsChecked : false
            onClicked:
            {
                if(root.currentDeletingIndex == -1 || root.currentDeletingIndex >= omekaIDs.length)
                {
                    return;
                }
                endpointIsChecked = root.currentCheckedIndex === root.currentDeletingIndex;


                var endpoint = ({});
                endpoint.omekaID = omekaIDs[root.currentDeletingIndex]
                endpoint.url = omekaUrls[root.currentDeletingIndex];
                endpoint.title = omekaTitles[root.currentDeletingIndex];
                ItemManager.unregisterEndpoint(endpoint);

                omekaIDs.splice(root.currentDeletingIndex, 1)
                omekaUrls.splice(root.currentDeletingIndex, 1)
                omekaTitles.splice(root.currentDeletingIndex, 1)

                endpoints.removeEndpoint(root.currentDeletingIndex);

                delayCheck.start();

                confirm_delete_endpoint.visible = false;
            }

            style: ButtonStyle {
                background: Rectangle {
                    color: Style.color1
                    radius: Resolution.applyScale(30)
                }
                label: OmekaText {
                    center: true
                    text: "DELETE"
                    _font: Style.addEndpointBtnFont
                }
            }
            Timer
            {
                id: delayCheck
                interval: 500
                onTriggered:
                {
                    if(delete_btn.endpointIsChecked)
                    {
                        endpoints.checkFirstEndpoint();
                    }
                }
            }
        }

        Button {
            id: cancel_btn
            width: parent.width/4
            height: Resolution.applyScale(122)
            x: parent.width * 3/5
            anchors.top: parent.top
            anchors.topMargin: Resolution.applyScale(800)
            onClicked:
            {
                root.currentDeletingIndex = -1;
                confirm_delete_endpoint.visible = false;
            }

            style: ButtonStyle {
                background: Rectangle {
                    color: Style.color1
                    radius: Resolution.applyScale(30)
                }
                label: OmekaText {
                    center: true
                    text: "CANCEL"
                    _font: Style.addEndpointBtnFont
                }
            }
        }
    }

    function resetAddNewEndpointArea()
    {
        url_input.text = qsTr("http://www...");
        url_input.color = "#666666"
        add_endpoint_btn.visible = false;
        url_input.focus = false;
        clear.visible = false;
    }
    /*
      Handles errors during text changes
    */
    function endpointError(error) {
        if(error) {
            Foreground.showError(error, 3000, Resolution.applyScale(300));
        }
    }

}
