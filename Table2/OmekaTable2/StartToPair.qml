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
      The latest generated pairing code
     */
    property var currentCode;

    signal whatIsThis();

    Component.onCompleted: HeistClient.clearHeist(); //temporary hack; see api doc for this call

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

    //    OmekaText
    //    {
    //        id: pairing_text
    //        text: "Thank you for exploring the beta version of our software. The mobile app is not yet available for download."
    //        /*"To send to your device download and launch the " + Settings.APP_NAME +
    //              ", go to Settings, and enter the code:"*/
    //        _font: Style.settingFont
    //        width: 143
    //        anchors.horizontalCenter: root.horizontalCenter
    //        horizontalAlignment: Text.AlignHCenter
    //        y: 65
    //    }

    QRCode
    {
        id: qr_code
        scale: 0.35
        width: 320
        height: 320
        anchors.horizontalCenter: root.horizontalCenter
        y: -40
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

    function randomInt(min, max) {
        return Math.floor(Math.random()*(max-min)+min);
    }

    /*! Create new heist pairing sessions */
    function startSession() {
        generateCode();
        HeistClient.startPairingSession(currentCode, HeistClient.uid);
    }

    /*! Generate unique pairing code. This needs to be tracked
        at a global level and not local to the table user*/
    function generateCode() {
        var code;
        do {
            code = randomInt(1111,9999);
        }
        while (HeistClient.codes.indexOf(code) !== -1);
        currentCode = code;
        HeistClient.codes.push(code);

        qr_code.value = "endpoint,"+Omeka.endpoint
                        +";table,"+HeistClient.uid
                        +";code,"+currentCode
    }


}
