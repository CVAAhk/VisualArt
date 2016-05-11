import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.LocalStorage 2.0
import "../../js/storage.js" as Settings

ApplicationWindow {
    id: window
    visible: true
    width: 470; height: 800
    property string table : "likes"

    Component.onCompleted: {
       count.text = Settings.rows(table).length
    }

    Text{
        id: count
    }

    Row{
        anchors.bottom: parent.bottom
        Button{
            text: "Add"
            onClicked: {
                console.log(Settings.set(table, Settings.rows(table).length, 1))
            }
        }
        Button{
            text: "Remove"
            onClicked: {
                console.log(Settings.remove(table, (Settings.rows(table).length-1).toString()))
            }
        }
    }

}
