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
            id: gallery
            width: Settings.SCREEN_WIDTH
            height: Settings.SCREEN_HEIGHT
            onRemoveAttractImage: attract_pool
        }

        AttractPoolItem
        {
            id: attract_pool
            onCreateImage:
            {
                console.log("create an image!")
                gallery.imageHolderCreateImage(source,imageX,imageY,imageRotation,imageWidth,imageHeight, whichScreen)
            }
        }
//        AttractPoolItem
//        {
//            y: 539
//            rotation: 180
//            onCreateImage:
//            {
//                console.log("create an image!")
//                gallery.imageHolderCreateImage(source,imageX,imageY+y,imageRotation,imageWidth,imageHeight, "attract pool")
//            }
//        }
    }


}
