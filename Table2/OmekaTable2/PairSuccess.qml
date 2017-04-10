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
            //x: 12;
//                anchors.verticalCenter: parent.verticalCenter
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

    }
    OpacityMask
    {
        anchors.fill: start_to_pair_icon_bkg
        source: start_to_pair_icon_bkg
        maskSource: start_to_pair_icon

    }
    Image
    {
        id: pair_success
        source: "content/POI/pairing-successful.png"
        anchors.horizontalCenter: root.horizontalCenter
        y:86
    }
}
