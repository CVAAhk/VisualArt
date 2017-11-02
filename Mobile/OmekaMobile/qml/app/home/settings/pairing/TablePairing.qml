import QtQuick 2.5
import "../../../base"
import "../../../../utils"
import "../../../clients"

Item {

    id: root
    state: "unpaired"

    /*
      Universally unique identifier to tag the device.
    */
    property var deviceId: User.getGUID()

    //clear float message when invisible
    onVisibleChanged: {
        if(!visible) {
            Foreground.hideMessage()
        }
    }

    ///////////////////////////////////////////////////////////
    //          UI
    ///////////////////////////////////////////////////////////

    /*!Pairing header and back button*/
    OmekaToolBar {
        id: bar
        backgroundColor: Style.color3
        z: 1

        OmekaText {
            anchors.centerIn: parent
            text: "pairing"
            _font: Style.titleFont
        }

        OmekaButton {
            id: back
            icon: Style.back
            iconScale: .7
            onClicked: if(homeStack) homeStack.pop()
        }
    }

    /*!QR Scanning View*/
    Column {
        id: scan_view

        anchors.right: parent.right
        anchors.top: bar.bottom
        width: parent.width
        height: parent.height - bar.height

        QRScanner {
            id: scanner
            width: parent.width
            height: parent.height * 0.6

            Image {
                id: scanner_frame
                source: Style.scannerFrame
                fillMode: Image.PreserveAspectFit
                width: parent.width/4
                height: parent.width/4
                anchors.centerIn: parent
            }

            onEndpointChanged: Heist.endpoint = endpoint
            onTableChanged: Heist.tableID = table
            onCodeChanged: receiver.code = code

        }

        Item {
            id: scan_instructions
            width: parent.width
            height: parent.height * 0.4

            OmekaText {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.2
                _font: Style.pairingInstructions
                text: "scan the qr code to pair with the table"
            }
        }

    }

    /*!Control to terminate pairing session*/
    Unpair {
        id: unpair_view
        anchors.top: parent.top
        anchors.topMargin: Resolution.applyScale(438)
        width: parent.width
        height: Resolution.applyScale(816)
        onUnpair: root.unpair()
    }

    //pairing states
    states: [
        State {
            name: "unpaired"
            AnchorChanges { target: scan_view; anchors.right: parent.right }
            PropertyChanges { target: scan_view; opacity: 1 }
            AnchorChanges { target: unpair_view; anchors.left: parent.right }
            PropertyChanges { target: unpair_view; opacity: 0 }
        },
        State {
            name: "paired"
            AnchorChanges { target: scan_view; anchors.right: parent.left }
            PropertyChanges { target: scan_view; opacity: 0 }
            AnchorChanges { target: unpair_view; anchors.left: parent.left }
            PropertyChanges { target: unpair_view; opacity: 1 }
        }
    ]

    //state animations
    transitions: Transition {
        AnchorAnimation { duration: 400; easing.type: Easing.OutQuad }
        PropertyAnimation { target: unpair_view; duration: 200; property: "opacity"; easing.type: Easing.OutQuad }
    }

    ///////////////////////////////////////////////////////////
    //          DEVICE PAIRING
    ///////////////////////////////////////////////////////////

    //listens for iterative heist data updates
    HeistReceiver {
        id: receiver
        onSessionChanged: validateSession();
        onAddItem: Heist.registerItem(item, scanner.code);
        onErrorChanged: pairingError(error);
    }

    /*
      Once a valid session is determined, established pairing. Once a session
      becomes invalid, terminate the pairing. A valid session is one that has
      a heist entry corresponding with the pairing code and does not have an
      assigned device.
    */
    function validateSession() {
        //valid session
        if(receiver.session) {
            if(receiver.device && receiver.device !== deviceId) {
               pairingError("This pairing code has been claimed by another device. Terminate the pairing session on the table and start a new one.")
            } else {
                pair();
            }
        }
        //session terminated
        else {
            unpair();
        }
    }

    /*
      Create the pairing in the manager and update the ui state
    */
    function pair() {
        if(state === "unpaired") {            
            scanner.start = false
            Foreground.hideMessage();
            Heist.setPairing(scanner.code, deviceId);
            state = "paired";
        }
    }

    /*
      Destroy the pairing in the manager and update the ui state
    */
    function unpair() {
        if(state === "paired") {
            scanner.start = true
            receiver.register = false;
            Foreground.showMessage("Pairing session has been terminated.", 3000, Resolution.applyScale(300));
            Heist.releasePairing(scanner.code, deviceId);
            state = "unpaired";            
        }
    }

    /*
      Handles errors during pairing
    */
    function pairingError(error) {
        if(error) {
            Foreground.showError(error, 0, Resolution.applyScale(1150));
            receiver.register = false;
        }
    }

}
