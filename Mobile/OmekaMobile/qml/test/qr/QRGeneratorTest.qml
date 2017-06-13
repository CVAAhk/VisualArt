import QtQuick 2.0
import QtQuick.Controls 1.4
import "../../app/home/settings/pairing"

ApplicationWindow {
    visible: true
    width: 470; height: 800

    Item {
        anchors.fill: parent

        QRCode {
            width: 320
            height: 320
            anchors.centerIn: parent
            value: "TEST"
        }
    }
}
