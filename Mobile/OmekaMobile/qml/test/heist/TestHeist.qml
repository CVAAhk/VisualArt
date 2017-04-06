import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../utils"
import "../../app/home/settings/pairing"

ApplicationWindow {
    id: window
    visible: true
    width: 470; height: 600    

    /*
      Id of paired device. When null or empty, the table user is not paired with a device.
      The value should be set to null initially to indicate a device has not yet been paired
      and an empty value, set by the device, indicates a once paired device is now unpaired.
    */
    property var deviceId: null;

    /*
      Indicates whether the table user is currently paired with a device.
    */
    property var paired: false;

    /*
      List of generated pairing session codes. For actual implementation, codes
      need to be tracked on a global level.
     */
    property var codes: [];

    /*
      The latest generated pairing code
     */
    property var currentCode;

    /*
      Delay time used postpone the descruction long enough to permit the table user to
      purge all created pairing sessions from heist
    */
    property var cleanDelay: 2000;

    //sample items (TEST ONLY)
    Component.onCompleted: {
        Omeka.getItemsByTerm("earth", window)
    }

    //remove sessions from heist on app exit
    Component.onDestruction: clean();

    //populate item list with search results (TEST ONLY)
    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.context === window) {
                item_list.model.append(result);
            }
        }
    }

    /*! Listens to iterative heist data updates */
    HeistReceiver {
        id: receiver
        onDeviceChanged: deviceId = device;
        code: currentCode
    }

    /* Heist table operations */
    Column {
        width: parent.width-40
        height: childrenRect.height
        anchors.horizontalCenter: window.horzontalCenter
        spacing: 20

        /*! Generate pairing session */
        RequestUI {
            id: start
            operation: "Start Pairing"
            onSubmit: startSession()
            result: currentCode ? currentCode : ""
        }

        /*! End pairing session */
        RequestUI {
            operation: "End Pairing"
            onSubmit: endSession()
        }

        //end all sessions (TEST ONLY)
        RequestUI {
            operation: "Clear Sessions"
            onSubmit: clearAll();
        }

        /* Displays paired state */
        StateLabel {
            name: "Paired:"
            value: paired
        }

        //item sample list (TEST ONLY)
        ListView {
            id: item_list
            clip: true
            width: parent.width
            height: 200
            anchors.horizontalCenter: parent.horizontalCenter
            model: ListModel {}
            delegate: ItemDelegate {}
        }
    }

    /*! Create new heist pairing sessions */
    function startSession() {
        generateCode();
        HeistManager.startPairingSession(currentCode);
    }

    /*! Generate unique pairing code. This needs to be tracked
        at a global level and not local to the table user*/
    function generateCode() {
        var code;
        do {
            code = NumberUtils.randomInt(1111,9999);
        }
        while (codes.indexOf(code) !== -1);
        currentCode = code;
        codes.push(code);
    }

    /*!
      Ends the pairing session and restores initial state
     */
    function endSession() {
        HeistManager.endPairingSession(currentCode);
        codes.pop();
        currentCode = codes[codes.length-1];
        paired = false;
    }

    /*!
      Removes all generated heist sessions and restores initial state. This is not
      applicable to the final implementation since a table user will only be responsible
      for one session at a time. (TEST ONLY)
      */
    function clearAll() {
        paired = false;
        currentCode = "";
        codes.length = 0;
        HeistManager.clearAllSessions();
    }

    /*!
      Removes all items and restores initial state of items in list (TEST ONLY)
      */
    function resetItems() {
        for(var i=0; i<item_list.count; i++) {
            item_list.contentItem.children[i].reset();
        }
        HeistManager.removeAllItems(currentCode, null);
    }

    /*!
      Postpones destruction long enough to permit termination of all generated
      sessions. For actual implementation, there will only be one code.
      */
    function clean() {
        HeistManager.clearAllSessions();
        cleanDelay *= codes.length;
        while(cleanDelay) {
            cleanDelay--;
            console.log("cleaning");
        }
        console.log("cleaned");
    }

    //convenience function for removing by heist record id (TEST ONLY)
    function removeRecords(data) {
        for(var i in data) {
            HeistManager.removeData(data[i])
        }
    }

    /*! On unpair clear device id and remove associated items */
    onPairedChanged: {
        if(!paired) {
            deviceId = null;
            resetItems();
        }
    }

    /*! Update paired status based on device id value */
    onDeviceIdChanged: {

        //ignore null values
        if(deviceId === null) return;

        //unpair on empty device id
        if(paired && deviceId.length === 0) {
            paired = false;            
        }
        //pair on non-empty device id
        else if(!paired && deviceId.length > 0) {
            paired = true;
        }
    }    

}
