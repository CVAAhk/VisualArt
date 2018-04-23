import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."
import "settings.js" as Settings

Item
{
    id: root
    width: 175

    property string color: "#2b89d9"//blue
    Rectangle
    {
        id: start_to_pair_icon_bkg
        anchors.fill: start_to_pair_icon
        color: root.color
        visible: false
        Image
        {
            source: "content/POI/check.png"
            width: 21; height:17
            anchors.centerIn: parent
        }

    }
    Image
    {
        id: start_to_pair_icon
        source: "content/POI/pairing-code-icon.png"
        visible: false
        anchors.horizontalCenter: root.horizontalCenter
        y: 36
        width: 40; height: 40

    }
    OpacityMask
    {
        anchors.fill: start_to_pair_icon_bkg
        source: start_to_pair_icon_bkg
        maskSource: start_to_pair_icon

    }
    Image
    {
        id: drag_files
        source: "content/POI/send-success.png"
        anchors.horizontalCenter: root.horizontalCenter
        y:86
        width: 141; height: 24
    }
}
