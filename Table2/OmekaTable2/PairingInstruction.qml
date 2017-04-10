import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."
import "settings.js" as Settings
Item
{
    id: root
    width: 175
    property string color: "#2b89d9"//blue

    signal backToPairing();

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
        text: "By using the app " + Settings.APP_NAME +
              ", you can take your favorite discoveries with you.<br><br>Ask a docent how to download the app or search on your app store."
        _font: Style.settingFont
        width: 143
        anchors.horizontalCenter: root.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        y: 65
    }
    Image
    {
        id: back_to_pairing
        source: "content/POI/back-to-pairing.png"
        anchors.horizontalCenter: root.horizontalCenter
        y: 190
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: root.backToPairing();
        }
    }

}
