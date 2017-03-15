import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../utils"

ApplicationWindow {
    id: window
    visible: true
    width: 470; height: 600

    Column {
        width: parent.width-40
        height: childrenRect.height
        anchors.centerIn: parent
        spacing: 20

        RequestUI {
            operation: "Start Pairing"
            onSubmit: HeistManager.startPairingSession(entry);
        }

        RequestUI {
            operation: "End Pairing"
            onSubmit: HeistManager.endPairingSession(entry);
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

    }
}
