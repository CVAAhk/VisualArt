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
    property var codes: [];
    property var currentCode;

    HeistReceiver {
        id: receiver
        onDeviceChanged: deviceId = device;
        code: currentCode
    }

    Column {
        width: parent.width-40
        height: childrenRect.height
        anchors.horizontalCenter: window.horzontalCenter
        spacing: 20

        RequestUI {
            id: start
            operation: "Start Pairing"
            onSubmit: startSession()
            result: currentCode ? currentCode : ""
        }

        RequestUI {
            operation: "End Pairing"
            onSubmit: endSession()
        }

        RequestUI {
            operation: "Clear Sessions"
            onSubmit: clearAll();
        }

        StateLabel {
            name: "Paired:"
            value: paired
        }

    }

    function startSession() {
        generateCode();
        HeistManager.startPairingSession(currentCode);
    }

    function generateCode() {
        var code;
        do {
            code = NumberUtils.randomInt(1111,9999);
        }
        while (codes.indexOf(code) !== -1);
        currentCode = code;
        codes.push(code);
    }

    function endSession() {
        HeistManager.endPairingSession(currentCode);
        codes.pop();
        currentCode = codes[codes.length-1];
        paired = false;
    }

    function clearAll() {
        codes.length = 0;
        HeistManager.clearAllSessions();
        paired = false;
    }

    onPairedChanged: {
        if(!paired) {
            deviceId = null;
        }
    }

    onDeviceIdChanged: {
        if(deviceId === null) return;
        if(paired && deviceId.length === 0) {
            paired = false;
        } else if(!paired && deviceId.length > 0) {
            paired = true;
        }
    }
}
