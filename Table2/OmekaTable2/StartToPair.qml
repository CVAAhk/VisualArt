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

    Component.onCompleted: HeistManager.clearHeist(); //temporary hack; see api doc for this call

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


}
