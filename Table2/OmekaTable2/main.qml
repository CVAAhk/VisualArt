import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import "settings.js" as Settings

ApplicationWindow {
    visible: true
    width: Settings.SCREEN_WIDTH
    height: Settings.SCREEN_HEIGHT
    visibility: Settings.FULLSCREEN ? "FullScreen" : "Windowed";
    title: qsTr("OmekaTable2")

    Item
    {
        id: root
        focus: true
        Keys.onEscapePressed: Qt.quit()

        Gallery
        {
            width: Settings.SCREEN_WIDTH
            height: Settings.SCREEN_HEIGHT
        }

        AttractPoolItem
        {
            y: 539
        }
    }


}
