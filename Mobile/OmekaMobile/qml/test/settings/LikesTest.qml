import QtQuick 2.0
import QtQuick.Controls 1.4
import Qt.labs.settings 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 470; height: 800

    Component.onCompleted: {
        console.log(settings.likes.length)
    }

    Settings{
        id: settings
        category: "Likes"
        property var likes: []
    }

    Row{
        anchors.bottom: parent.bottom
        Button{
            text: "Add"
            onClicked: {
                var t = settings.likes
                t.push(1)
                settings.likes = t
            }
        }
        Button{
            text: "Remove"
            onClicked: {
                var t = settings.likes
                t.pop()
                settings.likes = t
            }
        }
    }

}
