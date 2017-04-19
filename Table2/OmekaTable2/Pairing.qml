import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."

Item
{
    id: root
    width: pairing_bkg.width
    height: pairing_bkg.height
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
    property bool paired: false;
    property bool readyToUnpair: false;
    /*
      The latest generated pairing code
     */
    property var currentCode//: pair_code.currentCode

    /*
      List of item ids added to heist
     */
    property var items: [];

    /*
      Delay time used postpone the descruction long enough to permit the table user to
      purge all created pairing sessions from heist
    */
    property var cleanDelay: 2000;

    signal unpairDone();

    signal interactive();

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
        height: root.paired && !root.readyToUnpair?145: 225
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
        enabled: visible
        onWhatIsThis: {pairing_instruction.visible = true;pair_code.visible = false;interactive();}
        onCurrentCodeChanged: root.currentCode = currentCode;
    }
    PairingInstruction
    {
        id: pairing_instruction
        anchors.top: pairing_bkg.top
        color: root.color
        x: 12
        visible: false
        enabled: pairing_instruction.visible
        onBackToPairing: {pairing_instruction.visible = false;pair_code.visible = true;interactive();}
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
    ReadyToUnpair
    {
        id: ready_to_unpair
        color: root.color
        x:12
        anchors.top: pairing_bkg.top
        visible: readyToUnpair
        enabled: ready_to_unpair.visible
        onBackToDragFiles:
        {
            readyToUnpair = false;
            drag_files.visible = true;
            interactive();
        }
        onUnpair: {endSession();root.unpairDone();}
    }

    function startSession()
    {
        pair_code.startSession();
        interactive();
    }
    function startUnpair()
    {
        readyToUnpair = true;
        pair_successful.visible = false;
        drag_files.visible = false;
        send_success.visible = false;
        interactive();
    }
    function resetPairing()
    {
        pair_code.visible = true;
        pairing_instruction.visible = false;
    }

    /*! Listens to iterative heist data updates */
    HeistReceiver {
        id: receiver
        onDeviceChanged: {deviceId = device;/*console.log("devide id = ", deviceId);*/}
        onRemoveItem: root.removeItem(item)
        code: currentCode
    }

    /*!
      Ends the pairing session and restores initial state
     */
    function endSession() {
        receiver.register = false;
        HeistManager.endPairingSession(currentCode);
        if(HeistManager.codes.indexOf(currentCode) !== -1) {
            HeistManager.codes.splice(HeistManager.codes.indexOf(currentCode), 1);
        }
        currentCode = "";
        paired = false;
        root.readyToUnpair = false;
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
        //TODO
//        for(var i=0; i<item_list.count; i++) {
//            item_list.contentItem.children[i].reset();
//        }
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
            //console.log("cleaning");
        }
        console.log("cleaned");
    }

    //convenience function for removing by heist record id (TEST ONLY)
    function removeRecords(data) {
        for(var i in data) {
            HeistManager.removeData(data[i])
        }
    }

   /*
    Synchronizes local items list with heist on heist item removal
   */
   function removeItem(item) {
       if(items.indexOf(item) !== -1) {
           items.splice(items.indexOf(item), 1);
           HeistManager.removeItem(currentCode, item, root);
       }

   }

   function timeoutPairing()
   {
       deviceId = null;
       resetItems();
       items.length = 0;
       pair_code.visible = false;
       pair_successful.visible = false;
       drag_files.visible = false;
       send_success.visible = false;
   }

    /*! On unpair clear device id and remove associated items */
    onPairedChanged: {
        if(!paired) {
            root.timeoutPairing();
        }
        else
        {
            pair_successful.visible = true;
            pair_code.visible = false;
            root.enabled = false;
            switch_to_drag_files.start();
            interactive();
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
            console.log("paired = true")
        }
    }

    Timer
    {
        id: switch_to_drag_files
        interval: 1000
        onTriggered:
        {
            pair_successful.visible = false;
            drag_files.visible = true;
            root.enabled = true;
        }
    }
    SequentialAnimation
    {
        id: switch_between_add_and_drag
        ParallelAnimation
        {
            PropertyAction { target: drag_files; property: "visible"; value: false}
            PropertyAction { target: send_success; property: "visible"; value: true}
            PropertyAction { target: root; property: "enabled"; value: false}
        }

        PauseAnimation {
            duration: 2000
        }
        ParallelAnimation
        {
            PropertyAction { target: drag_files; property: "visible"; value: true}
            PropertyAction { target: send_success; property: "visible"; value: false}
            PropertyAction { target: root; property: "enabled"; value: true}
        }
    }
    function startAddSuccess()
    {
        switch_between_add_and_drag.start();
    }


}
