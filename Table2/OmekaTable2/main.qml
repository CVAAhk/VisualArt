import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2

import "settings.js" as Settings

Item
{
    x: 0; y: 0
    width: Settings.SCREEN_WIDTH
    height: Settings.SCREEN_HEIGHT

    Item
    {
        id: root
        focus: true
        Keys.onEscapePressed: Qt.quit()

        property double screenScaleX: Screen.width / Settings.SCREEN_WIDTH
        property double screenScaleY: Screen.height / Settings.SCREEN_HEIGHT

        transform: Scale { xScale: root.screenScaleX; yScale: root.screenScaleY; }

        Rectangle
        {
            width: Settings.SCREEN_WIDTH
            height: Settings.SCREEN_HEIGHT
            color: "#e6e6e6"
        }

        Gallery
        {
            id: gallery
            width: Settings.SCREEN_WIDTH
            height: Settings.SCREEN_HEIGHT
            //onRemoveAttractImage:
            onCarouselActivate: {/*attract_pool.opacity = 0.0;*/ attract_pool.stopAttractTimer(); attract_pool.carouselActivate = true;}
        }

        AttractPoolItem
        {
            id: attract_pool
            onCreateImage:
            {
                //console.log("create an image!")
                //gallery.imageHolderCreateImage(source,imageX,imageY,imageRotation,imageWidth,imageHeight, tapOpen, whichScreen);
            }
        }

        Component.onCompleted:
        {
            Settings.SCREEN_SCALE_X = 1.0 / root.screenScaleX;
            Settings.SCREEN_SCALE_Y = 1.0 / root.screenScaleY;
        }
    }
}
