import QtQuick 2.5
import QtQuick.Controls 1.4

ScrollView {
    verticalScrollBarPolicy: Qt.ScrollBarAlwaysOn
    Component.onCompleted: {
        flickableItem.maximumFlickVelocity = 8000
        flickableItem.flickDeceleration = 3000
        flickableItem.flickableDirection = Flickable.VerticalFlick
    }
}
