import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "./TouchHelpers"
import "settings.js" as Settings
import "."

/*! \qmltype Displays detailed view of media items and corresponding metadata */
Item
{
    id: detail

    height: active ? detail.imageHeight + scroll_bkg.height + controls.height : detail.imageHeight + controls.height
    width: detail.imageWidth
    objectName: "detail"
    property var source//: img.source

    property int imageWidth//: img.width

    property int imageHeight : media.height//: img.height

    property string whichScreen

    property int imageTimerDuration : 100000000 // Settings.IMAGE_TIMER_DURATION

    property alias imageTimer: image_timer

    readonly property double scaleFactor: 1.0

    property bool active: false

    signal imageDragged(var image);

    signal finishedDragging(var image);

    signal deleteImage(var image);

    /*! \qmlproperty
        Currently selected item
    */
    property var item: getSelectedItem();//: ItemManager.current

    function getSelectedItem()
    {
        return ItemManager.selectedItems[ItemManager.selectedItems.length - 1];

    }
    Image
    {
        id: bkg
        source: "content/POI/_Image_.png"
//        x: -20; y:-20
//        width: detail.imageWidth + 40
//        height: active ? detail.imageHeight + scroll_bkg.height + 40 : detail.imageHeight + 40
        anchors.fill: detail
        anchors.margins: -10
        visible: media.progress == 1
    }

    MediaViewer {
            id: media
            anchors.top: controls.bottom
            sources: item ? item.media : null
            type: item ? item.mediaTypes[0] : ""
            //visible: media.progress == 1
        }

//    Image
//    {
//        id: img
//        fillMode: Image.PreserveAspectFit
//        width: detail.width
//        anchors.top: controls.bottom

//    }
//    //load indicator
//    OmekaIndicator {
//        scale: 2
//        running: img.progress < 1
//    }
    MultiPointPinchArea
    {
        anchors.fill: detail
        //anchors.topMargin: -40

        dragOnPinch: true
        listenForRotation: true
        listenForScale: true

        maximumScale: 3
        minimumScale: 1

        mouseEnabled: true

        minimumX: 0
        maximumX: 1920 - detail.imageWidth

        minimumY: 0
        maximumY: 1080 - detail.imageHeight

        onDraggingChanged:
        {
//            if(!dragging)
//            {
//                detail.finishedDragging(detail);
//            }
        }

        onPositionUpdated:
        {
            detail.x += delta_x// * (detail.topScreen ? -1.0 : 1.0);// * detail.scale;
            detail.y += delta_y// * (detail.topScreen ? -1.0 : 1.0);// * detail.scale;

            detail.imageDragged(detail);
        }
        onRotationUpdated:
        {
            detail.rotation += delta_rotation;
            //image_timer.restart();
        }
        onScaleUpdated:
        {
            detail.scale += delta_scale * detail.scaleFactor;
            close.scale = 1/detail.scale;
            info_btn.scale = 1/detail.scale;
            //image_timer.restart();
        }

        debugView: Settings.DEBUG_VIEW
    }
    Image
    {
        id: controls
        width: scroll_bkg.width
        source: "content/POI/info-panel-controls-bkg.png"

        Image
        {
            id: close
            source: "content/POI/close-off.png"
            anchors.top: controls.top
            anchors.right: controls.right
            anchors.margins: 10
            MouseArea
            {
                anchors.fill: parent
                anchors.margins: -10
                onPressed:
                {
                    detail.deleteImage(detail);
                }
            }
        }
        Image
        {
            id: info_btn
            source: "content/POI/info-icon-off.png"
            anchors.top: controls.top
            anchors.left: controls.left
            anchors.margins: 10
            MouseArea
            {
                anchors.fill: parent
                anchors.margins: -10
                onPressed:
                {
                    detail.active = !detail.active
                    scroll_bkg.opacity = detail.active ? 1.0 : 0.0
                    info_btn.source = detail.active ? "content/POI/info-icon-on.png" : "content/POI/info-icon-off.png"
                }
            }
        }
    }


    //primary display item
    property DetailColumn column
    /*! scroll container */


    Image
    {
        id: scroll_bkg
        source: "content/POI/description_bkg.png"
        height: 200
        anchors.top: media.bottom
        anchors.left: detail.left
        opacity: 0.0

        /*! scroll container */
        OmekaScrollView {
            id: scroll
            width: detail.imageWidth
            height: 180
            //anchors.fill: parent
            enabled: parent.opacity == 1.0
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            //media display
            //DetailColumn { id: display; width: detail.imageWidth-35; }//height: 500 }
            DetailContent{id: detail_content}
        }

    }
    LoadScreen{
        width: detail.width
        height: controls.height
        progress: media ? media.progress : 0
    }

    Timer
    {
        id: image_timer

        interval: detail.imageTimerDuration

        onTriggered:
        {
            //image back to the viewer
            detail.deleteImage(detail);
        }
    }
}
