import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."
import "settings.js" as Settings
Item
{
    id: root
    width: 175
    property string color: "#2b89d9"//blue

    signal backToDragFiles();
    signal unpair();

    Rectangle
    {
        id: start_to_pair_icon_bkg
        anchors.fill: start_to_pair_icon
        color: root.color
        visible: false
        Image
        {
            source: "content/POI/link.png"
            x: 12;
            anchors.verticalCenter: parent.verticalCenter
            width: 22; height:22
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
        text: "ARE YOU SURE YOU WANT TO UNPAIR YOUR DEVICE?"
        _font: Style.settingFont
        width: 143
        anchors.horizontalCenter: root.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        y: 65
    }
    Image
    {
        id: back_to_drag
        source: "content/POI/cancel.png"
        anchors.horizontalCenter: root.horizontalCenter
        y: 150
        width: 85; height: 25
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: root.backToDragFiles();
        }
    }
    Image
    {
        id: unpair
        source: "content/POI/unpair-device.png"
        anchors.horizontalCenter: root.horizontalCenter
        y: 190
        width: 125; height: 25
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: root.unpair();
        }
    }

}
