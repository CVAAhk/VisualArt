import QtQuick 2.4
import QtQuick.Controls 1.4
import "qml/utils"
import "qml/app"

ApplicationWindow {
    id: root
    visible: true
    width: 470; height: 804
    title: "Omeka Mobile"
    color: Style.color3

    Component.onCompleted: {
        Resolution.appWindow = root
    }

    PageNavigation { }

    //orientation testing
    Item {
        focus: true
        Keys.onUpPressed: {
            root.width = 804
            root.height = 470
            Resolution.targetWidth = 2464
            Resolution.targetHeight = 1440
        }
        Keys.onDownPressed: {
            root.width = 470
            root.height = 804
            Resolution.targetWidth = 1440
            Resolution.targetHeight = 2464
        }
    }
}
