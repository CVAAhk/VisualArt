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
    property var omekaIDs: []
    property var omekaTitles: []
    property var omekaUrls: []

    property int currentDeletingIndex: -1

    property int currentCheckedIndex: 0

    property var defaultEndpoint: "http://dev.omeka.org/mallcopy"

    property var lastSelectedEndpoint

    //initialize loading endpoints from local storage
    Component.onCompleted: {
        var entry
        var url
        var omekaID
        var title

        var _endpoints = ItemManager.getEndpoints()
        lastSelectedEndpoint = User.getLastSelectedEndpoint() || defaultEndpoint

        var last = lastSelectedEndpoint.length-1
        if(lastSelectedEndpoint.charAt(last) === '/') {
            lastSelectedEndpoint = lastSelectedEndpoint.slice(0, last)
        }

        if(_endpoints.length < 1) {
            Omeka.getSiteInfo(root, defaultEndpoint+"/api/")
        }

        for(var i=0; i<_endpoints.length; i++) {
            entry = _endpoints[i]
            omekaID = entry.setting
            url = entry.value
            title = entry.title

            if(url.slice(-1) === "/")
            {
                url = url.slice(0, (url.length - 1));
            }

            Omeka.getSiteInfo(root, url + "/api/");
        }
    }

    Connections {
        target: Omeka
        onLoadComplete: {
            indicator.running = false;
            disable_all_buttons.visible = false;
        }
        onSiteInfo: {
            //when app starts, load the stored endpoints
            if(result.context === root) {
                for(var i = 0; i < omekaIDs.length; i++)
                {
                    if(result.omekaID === omekaIDs[i])
                    {
                        return;
                    }
                }

                var revised_url = result.url.slice(0, (result.url.length - 5));

                omekaIDs.unshift(result.omekaID)
                omekaTitles.unshift(result.title)
                omekaUrls.unshift(revised_url)

                if(ItemManager.getEndpoints().length === omekaIDs.length)
                {
                    for(var i = 0; i < omekaUrls.length; i++)
                    {
                        if(lastSelectedEndpoint === omekaUrls[i])
                        {
                            root.currentCheckedIndex = i
                        }
                    }
                }

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

                if(revised_url === lastSelectedEndpoint)
                {
                    endpoints.addEndpointToTop(revised_title, revised_url, true)

                    Omeka.endpoint = revised_url;
                }
                else
                {
                    endpoints.addEndpointToTop(revised_title, revised_url, false)
                }

                var endpoint = ({});
                endpoint.omekaID = result.omekaID;
                endpoint.url = revised_url;
                endpoint.title = result.title;
                if(!ItemManager.isRegistered(endpoint))
                {
                    ItemManager.registerEndpoint(endpoint);
                }

            }

            //add site title as endpoint
            if(result.context === clearAndAddButton) {
                for(var i = 0; i < omekaIDs.length; i++)
                {
                    if(result.omekaID === omekaIDs[i])
                    {
                        return;
                    }
                }
                var revised_url = result.url.slice(0, (result.url.length - 5));

                omekaIDs.unshift(result.omekaID)
                omekaTitles.unshift(result.title)
                omekaUrls.unshift(revised_url)

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

                endpoints.addEndpointToTop(revised_title, revised_url, false)


                var endpoint = ({});
                endpoint.omekaID = result.omekaID;
                endpoint.url = revised_url;
                endpoint.title = result.title;

                ItemManager.registerEndpoint(endpoint);
                resetAddNewEndpointArea();
                root.currentCheckedIndex++;
            }
            //text input changes
            if(result.context === url_input){
                for(var i = 0; i < omekaIDs.length; i++)
                {
                    if(result.omekaID === omekaIDs[i])
                    {
                        url_input.color = "red"
                        add_endpoint.state = "duplicate"
                        clearAndAddButton.state = "clear"

                        return;
                    }
                }
                url_input.color = "green"
                add_endpoint.state = "valid"
                clearAndAddButton.state = "add"
            }

        }
        onDisabledAPI: {

            if(context === url_input)
            {
                url_input.color = "red"
                add_endpoint.state = "invalid"
                clearAndAddButton.state = "clear"
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
                        if(url === omekaUrls[i])
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
                        if(url === omekaUrls[i])
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
        _font: Style.addEndpointFont
        state: "default"

        states: [
            State {
                name: "default"
                PropertyChanges { target: add_endpoint; text: "Add new site" }
            },
            State {
                name: "invalid"
                PropertyChanges { target: add_endpoint; text: "Invalid or incomplete url" }
            },
            State {
                name: "duplicate"
                PropertyChanges { target: add_endpoint; text: "Site already exists" }
            },
            State {
                name: "valid"
                PropertyChanges { target: add_endpoint; text: "Add site to list" }
            }

        ]
    }

    Rectangle
    {
        id: edit_url_area
        width: parent.width
        height: Resolution.applyScale(150)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Resolution.applyScale(230)
        color: "white"

        TextInput
        {
            id: url_input
            font.capitalization: Font.MixedCase
            font.pixelSize: Resolution.applyScale(68)
            focus: true
            validator: RegExpValidator { regExp: /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/ }//TODO: better validator
            anchors.fill: parent
            anchors.rightMargin: Resolution.applyScale(200)
            anchors.leftMargin: Resolution.applyScale(15)
            anchors.topMargin: Resolution.applyScale(15)
            anchors.bottomMargin: Resolution.applyScale(15)

            verticalAlignment: Text.AlignVCenter
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
                    clearAndAddButton.visible = true
                }
            }

            onTextChanged:
            {
                if(text !== "http://www..." && text !== "http://")
                    Omeka.getSiteInfo(url_input, text + "/api/");
            }

        }
        //clear field control
        OmekaButton {
            id: clearAndAddButton
            enabled: visible
            visible: false
            anchors.right: edit_url_area.right
            anchors.rightMargin: Resolution.applyScale(15)
            icon: Style.clear
            iconScale: .52
            state: "clear"

            property var clearRot: Rotation { origin.x: Resolution.applyScale(75); origin.y: Resolution.applyScale(75); angle: 0 }
            property var addRot: Rotation { origin.x: Resolution.applyScale(75); origin.y: Resolution.applyScale(75); angle: 45 }

            onClicked:
            {
                if(state === "clear") {
                    url_input.text = "http://www...";
                    url_input.focus = false;
                    clearAndAddButton.visible = false;
                    url_input.color = "#666666"
                    Foreground.hideMessage();
                    add_endpoint.state = "default"
                    clearAndAddButton.state = "clear"
                }
                else if(state === "add") {
                    Omeka.getSiteInfo(clearAndAddButton, root.endpoint_url + "/api/");
                }
            }

            states: [
                State {
                    name: "clear"
                    PropertyChanges { target: clearAndAddButton; transform: clearRot }
                },
                State {
                    name: "add"
                    PropertyChanges { target: clearAndAddButton; transform: addRot }
                }
            ]
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

                console.log("root.currentCheckedIndex = ", root.currentCheckedIndex, " root.currentDeletingIndex = ", root.currentDeletingIndex)
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

                if(!endpointIsChecked && root.currentCheckedIndex > root.currentDeletingIndex)
                    root.currentCheckedIndex--;
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
        url_input.focus = false;
        clearAndAddButton.visible = false;
        add_endpoint.state = "default"
        clearAndAddButton.state = "clear"
    }

}
