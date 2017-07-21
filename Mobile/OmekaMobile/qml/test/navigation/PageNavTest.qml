import QtQuick 2.5
import QtQuick.Controls 1.4

ApplicationWindow {
    id: root
    visible: true
    width: 470; height: 800
    property bool change: false

    StackView {
        id: nav
        anchors.fill: parent
        initialItem: first

        property FirstPage first: FirstPage {}
    }

    Item {
        focus: true
        Keys.onReturnPressed: {
            change = !change
            if(change) {
                nav.push(Qt.resolvedUrl("SecondPage.qml"))
            } else {
                nav.pop()
            }
        }
    }
}
