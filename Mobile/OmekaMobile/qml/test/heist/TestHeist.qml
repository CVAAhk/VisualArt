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
      The latest generated pairing code
     */
    property var currentCode;

    /**
      List of items ids added to heist
    */
    property var items: [];

    /*
      Delay time used postpone the descruction long enough to permit the table user to
      purge all created pairing sessions from heist
    */
    property var cleanDelay: 2000;        

    //sample items (TEST ONLY)
    Component.onCompleted: {
        Omeka.getPage(1, window)
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
        onRemoveItem: window.removeItem(item)
        code: currentCode;
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
        if(!currentCode) {
            currentCode = NumberUtils.randomInt(1111,9999);
            HeistManager.startPairingSession(currentCode);
        }
    }

    /*!
      Ends the pairing session and restores initial state
     */
    function endSession() {
        receiver.register = false;
        HeistManager.endPairingSession(currentCode);
        currentCode = "";
        paired = false;
    }

    /*!
     Synchronizes local items list with heist on heist item removal
    */
    function removeItem(item) {
        if(items.indexOf(item) !== -1) {
            items.splice(items.indexOf(item), 1);
            HeistManager.removeItem(currentCode, item, window);
        }
    }

    /*!
      Postpones destruction long enough to permit termination of all generated
      sessions. For actual implementation, there will only be one code.
      */
    function clean() {
        HeistManager.clearAllSessions();
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
            items.length = 0;
            HeistManager.removeAllItems(currentCode, null);
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
