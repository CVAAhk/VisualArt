import QtQuick 2.5
import QtQuick.Controls 1.4
import "../base"
import "../styles"
import "../../utils"

OmekaToolBar {

    property alias text: textField.text
    property alias placeholderText: textField.placeholderText

    //search field
    TextField {
        id: textField
        anchors.fill: parent
        anchors.margins: Resolution.applyScale(15)
        horizontalAlignment: TextInput.AlignHCenter
        verticalAlignment: TextInput.AlignVCenter
        font.bold: true
        font.pixelSize: Resolution.applyScale(80)
        placeholderText: "SEARCH"
        style: SearchBarStyle {}
    }    
}
