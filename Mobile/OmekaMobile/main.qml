import QtQuick 2.4
import QtQuick.Controls 1.4
import "qml/utils"
import "qml/app"

ApplicationWindow {
    id: root
    visible: true
    width: 470; height: 804
    title: "Omeka Mobile"

    Component.onCompleted: {
        Resolution.appWindow = root
    }

   // AppView {}

    PageNavigation {}
}
