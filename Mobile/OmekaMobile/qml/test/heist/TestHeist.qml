import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../utils"
import "../../app/home/settings/pairing"

ApplicationWindow {
    id: window
    visible: true
    width: 470; height: 600

    property var deviceId: null;
    property var paired: false;

    HeistReceiver {
        id: receiver
        onDeviceChanged: deviceId = device;
    }

    Column {
        width: parent.width-40
        height: childrenRect.height
        anchors.centerIn: parent
        spacing: 20

        RequestUI {
            operation: "Start Pairing"
            onSubmit: startSession(entry)
        }

        RequestUI {
            operation: "End Pairing"
            onSubmit: endSession(entry)
        }

        RequestUI {
            operation: "Add Item"
            onSubmit: {
                var args = entry.split(",");
                HeistManager.addItem(args[0], args[1], null);
            }
        }

        RequestUI {
            operation: "Clear Sessions"
            onSubmit: HeistManager.clearAllSessions();
        }

        StateLabel {
            name: "Paired:"
            value: paired
        }

    }

    function startSession(code) {
        HeistManager.startPairingSession(code);
        receiver.code = code;
    }

    function endSession(code) {
       HeistManager.endPairingSession(code);
       receiver.code = "";
       deviceId = null;
       paired = false;
    }

    onDeviceIdChanged: {
        if(deviceId === null) return;

        if(paired && deviceId.length === 0) {
            endSession(receiver.code);
        } else if(!paired && deviceId.length > 0) {
            paired = true;
        }
    }
}
