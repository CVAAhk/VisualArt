import QtQuick 2.0
import QtGraphicalEffects 1.0
import "./TouchHelpers"
import "settings.js" as Settings


Item
{
    id: root

    property alias source: img.source

    property alias imageWidth: img.width

    property alias imageHeight: img.height

    property bool topScreen

    property int imageTimerDuration : 100000000 // Settings.IMAGE_TIMER_DURATION

    property alias imageTimer: image_timer

    readonly property double scaleFactor: 1.0

    signal imageDragged(var image);

    signal finishedDragging(var image);

    signal deleteImage(var image);


    Image
    {
        id: bkg
        source: "content/POI/_Image_.png"
        x: -20; y:-20
        width: root.imageWidth + 40
        height: root.imageHeight + title_bkg.height + description_bkg.height + 40
    }
    Rectangle
    {
        color: "#ffffff"
        anchors.fill: img
    }

    Image
    {
        id: img
        fillMode: Image.PreserveAspectFit

    }
    Image
    {
        id: close
        source: "content/POI/Asset 4.png"
        anchors.bottom: img.top
        anchors.right: img.right
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed:
            {
                root.deleteImage(root);
            }
        }
    }
    Image
    {
        id: title_bkg
        source: "content/POI/title_bkg.png"
        anchors.top: img.bottom
        anchors.left: root.left

    }
    Image
    {
        id: description_bkg
        source: "content/POI/description_bkg.png"
        anchors.top: title_bkg.bottom
        anchors.left: root.left
    }

    DropShadow
    {
        id: imageEffect
          anchors.fill: close
          horizontalOffset: 3
          verticalOffset: 0
          radius: 8.0
          samples: 17
          color: "#80000000"
          source: close
    }
    MultiPointPinchArea
    {
        anchors.fill: img

        dragOnPinch: true
        listenForRotation: false
        listenForScale: false

//        maximumScale: 2
//        minimumScale: 0.15

        mouseEnabled: true

        minimumX: 0
        maximumX: 1920 - root.imageWidth

        minimumY: 0
        maximumY: 1080 - root.imageHeight

        onDraggingChanged:
        {
//            if(!dragging)
//            {
//                root.finishedDragging(root);
//            }
        }

        onPositionUpdated:
        {
            root.x += delta_x;// * root.scale;
            root.y += delta_y;// * root.scale;

            root.imageDragged(root);
        }
        onRotationUpdated:
        {
            root.rotation += delta_rotation;
            image_timer.restart();
        }
        onScaleUpdated:
        {
            root.scale += delta_scale * root.scaleFactor;
            image_timer.restart();
        }

        debugView: Settings.DEBUG_VIEW
    }

    Rectangle
    {
        anchors.fill: parent
        color: "green"
        opacity: 0.5
        visible: parent.enabled && Settings.DEBUG_VIEW
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
