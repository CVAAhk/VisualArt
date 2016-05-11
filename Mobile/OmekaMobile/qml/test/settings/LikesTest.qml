import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.LocalStorage 2.0
import "../../js/storage.js" as Settings

ApplicationWindow {
    id: window
    visible: true
    width: 470; height: 800

    Component.onCompleted: {
       count.text = Settings.rows().length
    }

    Text{
        id: count
    }

    Row{
        anchors.bottom: parent.bottom
        Button{
            text: "Add"
            onClicked: {
                Settings.set(Settings.rows().length, 1)
            }
        }
        Button{
            text: "Remove"
            onClicked: {                
                Settings.clear()
            }
        }
    }

}
