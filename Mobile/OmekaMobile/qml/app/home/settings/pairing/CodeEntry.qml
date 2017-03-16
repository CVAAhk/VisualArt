import QtQuick 2.5
import "../../../base"
import "../../../../utils"

Column {

    id: root
    spacing: Resolution.applyScale(45)

    /*
     Unique device id for pairing with heist table user
    */
    property var deviceId: HeistManager.uid;

    /*
     Pairing code entered by device user in an attempt to pair with
     table generated session
    */
    property var code: []

    //revive state based on paired status
    Component.onCompleted: {
        root.state = HeistManager.deviceIsPaired(deviceId) ? "paired" : "unpaired";
        if(state === "paired") {
            receiver.code = HeistManager.getUserByDevice(deviceId);
            code = receiver.code.split('');
        }
    }

    //deactivate receiver
    Component.onDestruction: resetCode();

    ///////////////////////////////////////////////////////////
    //          UI
    ///////////////////////////////////////////////////////////

    //icon
    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        source: Style.pair
        width: Resolution.applyScale(180); height: Resolution.applyScale(180)
    }

    //instructions
    OmekaText {
        width: parent.width
        center: true
        text: "enter the code you see on the table"
        _font: Style.pairingInstructions
    }

    //code slots
    ListView {
        id: slots
        interactive: false
        width: childrenRect.width
        height: contentItem.children[0].height
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: ListView.Horizontal
        spacing: Resolution.applyScale(21)
        model: 4
        delegate: delegate
    }

    //slot
    Component {
        id: delegate
        Item {
            width: Resolution.applyScale(109)
            height: Resolution.applyScale(155)
            property alias digit: text.text

            //text field
            OmekaText {
                id: text
                center: true
                anchors.fill: parent
                _font: Style.keypadFont
            }

            //border
            Rectangle {
                anchors.fill: parent
                color: Style.transparent
                border.width: Resolution.applyScale(6)
                border.color: Style.color1
                radius: Resolution.applyScale(15)
            }
        }
    }

    /*
      Updates code according to values entered by the user via keypad
      \a value - key value
    */
    function submitEntry(value) {

        //back key
        if(value === "back" && code.length > 0) {
            code.pop();
            slots.contentItem.children[code.length].digit = "";
        }

        //valid entry
        else if(value !== "back" && code.length < 4) {
            slots.contentItem.children[code.length].digit = value;
            code.push(value);
        }

        //update receiver
        receiver.code = getCodeString();
    }

    /*! \internal
     Clears code entry
    */
    function resetCode() {
        for(var i=0; i<4; i++) {
            slots.contentItem.children[i].digit = "";
        }
        code.length = 0;
        receiver.code = getCodeString();
    }

    /*
      Code to string conversion
    */
    function getCodeString() {
        return code ? code.join(""): "";
    }


    ///////////////////////////////////////////////////////////
    //          DEVICE PAIRING
    ///////////////////////////////////////////////////////////

    //listens for iterative heist data updates
    HeistReceiver {
        id: receiver
        onSessionChanged: validateSession();
        onErrorChanged: pairingError();
    }

    /*
      Once a valid session is determined, established pairing. Once a session
      becomes invalid, terminate the pairing. A valid session is one that has
      an heist entry corresponding with the pairing code and does not have an
      assigned device.
    */
    function validateSession() {
        //valid session
        if(receiver.session) {
            if(receiver.device) {
                //code is already in use - terminate session on table
            } else {
                pair();
            }
        }
        //session terminated on table
        else {
            unpair();
        }
    }

    /*
      Create the pairing in the manager and update the ui state
    */
    function pair() {
        if(root.state === "unpaired") {
            HeistManager.setPairing(getCodeString(), deviceId);
            root.state = "paired";
        }
    }

    /*
      Destroy the pairing in the manager and update the ui state
    */
    function unpair() {
        if(root.state === "paired") {
            HeistManager.releasePairing(getCodeString(), deviceId);
            resetCode();
            root.state = "unpaired";
        }
    }

    /*
      Handles errors during pairing
    */
    function pairingError() {
        if(receiver.error) {
            HeistManager.removeSession(getCodeString());
            receiver.register = false;
        }
    }

    //heist paired states
    states: [
        State { name: "unpaired" },
        State { name: "paired" }
    ]
}
