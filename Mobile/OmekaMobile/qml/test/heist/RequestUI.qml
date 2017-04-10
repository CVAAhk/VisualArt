import QtQuick 2.5
import QtQuick.Controls 1.4

Row {
    width: parent.width
    height: 40
    spacing: 20
    property alias operation: button.text
    property alias result: text.text

    signal submit();

    Button {
        id: button
        width: 100
        height: parent.height
        onClicked: submit()
    }
    Text {
        id: text
        width: parent.width - button.width - 20
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
