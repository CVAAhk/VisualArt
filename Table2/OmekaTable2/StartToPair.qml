import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."
import "settings.js" as Settings

Item
{
    id: root
    width: 175

    //property var codes: [];
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
    property var currentCode;

    /*
      Delay time used postpone the descruction long enough to permit the table user to
      purge all created pairing sessions from heist
    */
    property var cleanDelay: 2000;

    signal whatIsThis();

    //remove sessions from heist on app exit
    Component.onDestruction: clean();

    Rectangle
    {
        id: start_to_pair_icon_bkg
        anchors.fill: start_to_pair_icon
        color: root.color
        visible: false
        Image
        {
            source: "content/POI/code-icon.png"
            x: 12;
            anchors.verticalCenter: parent.verticalCenter
            width: 21; height:26
        }

    }
    Image
    {
        id: start_to_pair_icon
        source: "content/POI/pairing-code-icon.png"
        visible: false
        anchors.horizontalCenter: root.horizontalCenter
        y: 10

    }
    OpacityMask
    {
        anchors.fill: start_to_pair_icon_bkg
        source: start_to_pair_icon_bkg
        maskSource: start_to_pair_icon

    }

    OmekaText
    {
        id: pairing_text
        text: "To send to your device download and launch the " + Settings.APP_NAME +
              ", go to Settings, and enter the code:"
        _font: Style.settingFont
        width: 123
        anchors.horizontalCenter: root.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        y: 65
    }

    Rectangle
    {
        id: code_container_bkg
        anchors.fill: code_container
        color: root.color
        visible: false
    }
    Image
    {
        id: code_container
        source: "content/POI/code-containers.png"
        anchors.horizontalCenter: root.horizontalCenter
        y: 125
        visible: false
    }
    OpacityMask
    {
        anchors.fill: code_container_bkg
        source: code_container_bkg
        maskSource: code_container
    }
    Text
    {
        id: code_first_digit
        color: root.color
        font.pixelSize: 25
        anchors.verticalCenter: code_container.verticalCenter
        x: 35
    }
    Text
    {
        id: code_second_digit
        color: root.color
        font.pixelSize: 25
        anchors.verticalCenter: code_container.verticalCenter
        x: 66
    }
    Text
    {
        id: code_third_digit
        color: root.color
        font.pixelSize: 25
        anchors.verticalCenter: code_container.verticalCenter
        x: 96
    }
    Text
    {
        id: code_fourth_digit
        color: root.color
        font.pixelSize: 25
        anchors.verticalCenter: code_container.verticalCenter
        x: 128
    }
    Image
    {
        id: what_is_this
        source: "content/POI/pairing-what-is-this.png"
        anchors.horizontalCenter: root.horizontalCenter
        y: 190
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: root.whatIsThis();
        }
    }

    /*! Listens to iterative heist data updates */
    HeistReceiver {
        id: receiver
        onDeviceChanged: deviceId = device;
        code: currentCode
    }

    function randomInt(min, max) {

        return Math.floor(Math.random()*(max-min)+min);

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
            code = randomInt(1111,9999);
        }
        while (HeistManager.codes.indexOf(code) !== -1);
        currentCode = code;
        HeistManager.codes.push(code);
        var first_digit = Math.floor(code / 1000);
        var second_digit = Math.floor(code % 1000 /100);
        var third_digit = Math.floor(code % 100 /10);
        var fourth_digit = Math.floor(code % 10);

        code_first_digit.text = first_digit;
        code_second_digit.text = second_digit;
        code_third_digit.text = third_digit;
        code_fourth_digit.text = fourth_digit;
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
