import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."

Item
{
    id: root
    property string color: "#2b89d9"//blue
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
    property var currentCode: pair_code.currentCode

    /*
      Delay time used postpone the descruction long enough to permit the table user to
      purge all created pairing sessions from heist
    */
    property var cleanDelay: 2000;

    Rectangle
    {
        id: pairing_header_bkg
        anchors.fill: pairing_header
        color: root.color
        visible: false

    }
    Image
    {
        id: pairing_header
        source: "content/POI/pairing-header.png"
        visible: false

    }
    OpacityMask
    {
        anchors.fill: pairing_header_bkg
        source: pairing_header_bkg
        maskSource: pairing_header
    }


    Rectangle
    {
        id: pairing_footer_bkg
        anchors.fill: pairing_footer
        color: root.color
        visible: false

    }
    Image
    {
        id: pairing_footer
        source: "content/POI/pairing-footer.png"
        visible: false
        anchors.top: pairing_bkg.bottom
        x: 12
    }
    OpacityMask
    {
        anchors.fill: pairing_footer_bkg
        source: pairing_footer_bkg
        maskSource: pairing_footer
    }

    Image
    {
        id: pairing_bkg
        source: "content/POI/pairing-code-bkg.png"
        height: root.paired?145: 225
        anchors.top: pairing_header.bottom
        x: 12
    }

    StartToPair
    {
        id: pair_code
        anchors.top: pairing_bkg.top
        color: root.color
        x: 12
        visible: true
        onWhatIsThis: {pairing_instruction.visible = true;pair_code.visible = false;}
    }
    PairingInstruction
    {
        id: pairing_instruction
        anchors.top: pairing_bkg.top
        color: root.color
        x: 12
        visible: false
        onBackToPairing: {pairing_instruction.visible = false;pair_code.visible = true;}
    }
    PairSuccess
    {
        id: pair_successful
        color: root.color
        x: 12
        anchors.top: pairing_bkg.top
        visible: false
    }
    DragFiles
    {
        id: drag_files
        color: root.color
        x:12
        anchors.top: pairing_bkg.top
        visible: false
    }
    SendSuccess
    {
        id: send_success
        color: root.color
        x:12
        anchors.top: pairing_bkg.top
        visible: false
    }

    function startSession()
    {
        pair_code.startSession();
    }

    /*! Listens to iterative heist data updates */
    HeistReceiver {
        id: receiver
        onDeviceChanged: deviceId = device;
        code: currentCode
    }

    /*!
      Ends the pairing session and restores initial state
     */
    function endSession() {
        HeistManager.endPairingSession(currentCode);
        HeistManager.codes.pop();
        currentCode = HeistManager.codes[HeistManager.codes.length-1];
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
        HeistManager.codes.length = 0;
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
        cleanDelay *= HeistManager.codes.length;
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
            pair_code.visible = false;
            pair_successful.visible = false;
            drag_files.visible = false;
            send_success.visible = false;
        }
        else
        {
            pair_successful.visible = true;
            pair_code.visible = false;
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
