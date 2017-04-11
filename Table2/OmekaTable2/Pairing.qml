import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."

Item
{
    id: root
    property string color: "#2b89d9"//blue
    property bool pair_success: false

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
        height: root.pair_success?145: 225
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

}
