import QtQuick 2.8
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "./TouchHelpers"
import "settings.js" as Settings
import "."

/*! \qmltype Displays detailed view of media items and corresponding metadata */
Item
{
    id: root

    height: active ? root.imageHeight + scroll_bkg.height + controls.height : root.imageHeight + controls.height
    width: root.imageWidth
    objectName: "detail"
    visible: false

    property int imageWidth//: img.width

    property int imageHeight : media.height//: img.height

    property string whichScreen

    property int imageTimerDuration : 100000000 // Settings.IMAGE_TIMER_DURATION

    property alias imageTimer: image_timer

    readonly property double scaleFactor: 1.0

    property bool active: false

    property bool inUse: false

    signal imageDragged(var image);

    signal finishedDragging(var image);

    signal deleteImage(var image);

    /*! \qmlproperty
        Currently selected item
    */
    property var item: null //getSelectedItem();//: ItemManager.current

    /*
    function getSelectedItem()
    {
        return ItemManager.selectedItems[ItemManager.selectedItems.length - 1];

    }
    */

    Image
    {
        id: bkg
        source: "content/POI/_Image_.png"
        anchors.fill: root
        anchors.margins: -10
        visible: false // media.progress == 1
    }

    MultiPointPinchArea
    {
        anchors.fill: root

        dragOnPinch: true
        listenForRotation: true
        listenForScale: true

        maximumScale: 3
        minimumScale: 1

        mouseEnabled: true

        minimumX: 0
        maximumX: 1920 - root.imageWidth

        minimumY: 0
        maximumY: 1080 - root.imageHeight

        onPositionUpdated:
        {
            root.x += delta_x// * (detail.topScreen ? -1.0 : 1.0);// * detail.scale;
            root.y += delta_y// * (detail.topScreen ? -1.0 : 1.0);// * detail.scale;

            root.imageDragged(root);
        }
        onRotationUpdated:
        {
            root.rotation += delta_rotation;
        }
        onScaleUpdated:
        {
            root.scale += delta_scale * root.scaleFactor;
        }

        debugView: Settings.DEBUG_VIEW
    }
    MediaViewer
    {
        id: media
        anchors.top: controls.bottom
        sources: item ? item.media : null
        type: item ? item.mediaTypes[0] : ""
        //visible: media.progress == 1
    }
    MediaControls { media: media }
    Image
    {
        id: controls
        width: scroll_bkg.width
        source: "content/POI/info-panel-controls-bkg.png"

        height: 40 / root.scale

        Image
        {
            source: "content/POI/info-panel-controls-bkg-left.png"
            width: 32 / root.scale
            height: controls.height
        }

        Image
        {
            source: "content/POI/info-panel-controls-bkg-right.png"
            width: 32 / root.scale
            height: controls.height
            x: controls.width - width
        }

        Image
        {
            id: close
            source: "content/POI/close-off.png"

            x: 10 / root.scale
            y: 10 / root.scale

            transformOrigin: Item.TopLeft

            scale: 1.0 / root.scale

            MultiPointTouchArea
            {
                anchors.fill: parent
                anchors.margins: -10
                onPressed:
                {
                    root.deleteImage(root);
                }
            }
        }
        Image
        {
            id: info_btn
            source: "content/POI/info-icon-off.png"
            //anchors.left: controls.left
            //anchors.margins: 10

            x: controls.width + -24 - 10 / root.scale;
            y: 10 / root.scale

            transformOrigin: Item.TopRight

            scale: 1.0 / root.scale

            MultiPointTouchArea
            {
                anchors.fill: parent
                anchors.margins: -10
                onPressed:
                {
                    root.active = !root.active
                    scroll_bkg.opacity = root.active ? 1.0 : 0.0
                    info_btn.source = root.active ? "content/POI/info-icon-on.png" : "content/POI/info-icon-off.png"
                }
            }
        }
    }


    //primary display
    property DetailColumn column
    /*! scroll container */


    Image
    {
        id: scroll_bkg
        source: "content/POI/description_bkg.png"
        height: 200 / root.scale
        anchors.top: media.bottom
        anchors.left: root.left
        opacity: 0.0

        Image
        {
            source: "content/POI/description_bkg-left.png"
            width: 64 / root.scale
            height: scroll_bkg.height
        }

        Image
        {
            source: "content/POI/description_bkg-right.png"
            width: 64 / root.scale
            height: scroll_bkg.height
            x: scroll_bkg.width - width
        }

        /*! scroll container */
        OmekaScrollView
        {
            id: scroll
            width: root.imageWidth
            height: 180 / root.scale
            enabled: parent.opacity == 1.0
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            //media display
            DetailContent
            {
                id: detail_content;
                width: root.width
                rootScale: root.scale
            }
            Component.onCompleted: scroll_bar.flickable = scroll.flickableItem;
        }
        ScrollBar
        {
            id: scroll_bar
            //flickable: scroll.flickableItem
            handleSrc: "content/POI/scroll-handle.png"
            barSrc: "content/POI/scroll-bar.png"
            anchors.top: scroll_bkg.top
            anchors.bottom: scroll_bkg.bottom
            anchors.right: scroll_bkg.right
            anchors.rightMargin: 5
            anchors.bottomMargin: 15
            anchors.topMargin: 5
        }

    }

    LoadScreen
    {
        width: root.width
        height: controls.height
        progress: media ? media.progress : 0
    }

    Timer
    {
        id: image_timer

        interval: root.imageTimerDuration

        onTriggered:
        {
            //image back to the viewer
            root.deleteImage(root);
        }
    }
}
