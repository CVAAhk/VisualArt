import QtQuick 2.5
import "../../../base"
import "../../../../utils"

Column {

    id: root
    spacing: Resolution.applyScale(45)

    /*
      \internal
     Pairing code entered by device user in an attempt to pair with
     table generated session
    */
    readonly property var code: []

    /*
     String conversion of entry code
    */
    property var codeString;

    //icon
    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        source: Style.pair
        width: Resolution.applyScale(180); height: Resolution.applyScale(180)
    }

    //instructions
    OmekaText {
        width: parent.width
        center: true
        text: "enter the code you see on the table"
        _font: Style.pairingInstructions
    }

    //code slots
    ListView {
        id: slots
        interactive: false
        width: childrenRect.width
        height: contentItem.children[0].height
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: ListView.Horizontal
        spacing: Resolution.applyScale(21)
        model: 4
        delegate: delegate
    }

    //slot
    Component {
        id: delegate
        Item {
            width: Resolution.applyScale(109)
            height: Resolution.applyScale(155)
            property alias digit: text.text

            //text field
            OmekaText {
                id: text
                center: true
                anchors.fill: parent
                _font: Style.keypadFont
            }

            //border
            Rectangle {
                anchors.fill: parent
                color: Style.transparent
                border.width: Resolution.applyScale(6)
                border.color: Style.color1
                radius: Resolution.applyScale(15)
            }
        }
    }

    /*
      Updates code according to values entered by the user via keypad
      \a value - key value
    */
    function submitEntry(value) {

        //back key
        if(value === "back" && code.length > 0) {
            code.pop();
            slots.contentItem.children[code.length].digit = "";
        }

        //valid entry
        else if(value !== "back" && code.length < 4) {
            slots.contentItem.children[code.length].digit = value;
            code.push(value);
        }

        //update receiver
        codeString = getCodeString();
    }

    /*! \internal
     Clears code entry
    */
    function resetCode() {
        for(var i=0; i<4; i++) {
            slots.contentItem.children[i].digit = "";
        }
        code.length = 0;
        codeString = getCodeString();
    }

    /*
      Code to string conversion
    */
    function getCodeString() {
        return code ? code.join(""): "";
    }
}
