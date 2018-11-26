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
            x: 9;
            anchors.verticalCenter: parent.verticalCenter
            width: 23; height:29
        }

    }
    Image
    {
        id: start_to_pair_icon
        source: "content/POI/pairing-code-icon.png"
        visible: false
        anchors.horizontalCenter: root.horizontalCenter
        y: 10
        width: 40; height: 40
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
        text: "Take this gallery on the go!
You can send content from this collection to your phone with the Omeka Everywhere Mobile app.

Find Omeka Everywhere Mobile on the app store to get started."
        _font: Style.instructionsFont
        width: 160
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
        width: 105; height: 25
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: root.backToPairing();
        }
    }

}
