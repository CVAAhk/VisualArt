import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2

import "settings.js" as Settings
import "."

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
            onCarouselActivate: {/*attract_pool.opacity = 0.0;*/ attract_pool.stopAttractTimer(); attract_pool.carouselActivate = true;}
        }

        AttractPoolItem
        {
            id: attract_pool
            onCreateImage:
            {
                //gallery.imageHolderCreateImage(source,imageX,imageY,imageRotation,imageWidth,imageHeight, tapOpen, whichScreen);
            }
            onImageDragged: gallery.attractImageIsInPairingBox(image);
            onImageFinishedDragging: gallery.attractImageReleased(image);
            onMaxResultsChanged: gallery.maxResults = attract_pool.maxResults;
        }

        Component.onCompleted:
        {
            Settings.SCREEN_SCALE_X = 1.0 / root.screenScaleX;
            Settings.SCREEN_SCALE_Y = 1.0 / root.screenScaleY;
            HeistClient.clearDeviceRecords();
        }
    }
}
