import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: home
    anchors.fill: parent

    StackView{
        id: stack
        anchors.fill: parent
        initialItem: Qt.resolvedUrl("gallery/Gallery.qml")
    }

}
