import QtQuick 2.5


Row {
    width: parent.width
    height: 40
    spacing: 20

    property alias name: label.text;
    property alias value: valueLabel.text;

    Text {
        id: label
        width: 100
        height: parent.height
    }

    Text {
        id: valueLabel
        width: parent.width - label.width
        height: parent.height
    }
}
