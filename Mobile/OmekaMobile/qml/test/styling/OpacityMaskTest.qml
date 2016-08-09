import QtQuick 2.5
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 470; height: 804

    Image {
        id: logo
        source: "qrc:///ui/logo-test.png"

        layer.enabled:  true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                    width: logo.width
                    height: logo.height
                    radius: 20
                }
        }
    }

}
