import QtQuick 2.5
import QtQuick.Controls 1.4
import QZXing 2.3
import QtMultimedia 5.5
import Maker 1.0

Item {

    property var endpoint
    property var table
    property var code
    property var result
    property bool start

    Component.onCompleted:
    {
        setOrientation(MainWindow.getInitialOrientation())
        start = false;
    }
    onVisibleChanged: start = visible

    onStartChanged: {
        if(start) {
            camera.start()
        } else {
            camera.stop()
            text.text = ""
        }
    }

    Camera {
        id: camera
        focus {
            focusMode: CameraFocus.FocusContinuous
            focusPointMode: CameraFocus.FocusPointAuto
        }

    }

    VideoOutput {
        id: videoOutput
        source: camera
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
        filters: [zxingFilter]
        orientation: 90

        Rectangle {
            id: captureZone
            color: "red"
            opacity: 0.2
            width: parent.width/4
            height: parent.width/4
            anchors.centerIn: parent
        }
    }
    //Connect with C++ class
    QuickMaker
    {
        id: quick_maker
        objectName: "quick_maker"
        onOrientationChanged:
        {
            //console.log("orientation changes: ", orientation)
            setOrientation(orientation)
        }
    }

    QZXingFilter {
        id: zxingFilter

        decoder {
            enabledDecoders: QZXing.DecoderFormat_QR_CODE
            tryHarder: true
            onTagFound: result = tag
        }
        captureRect: {
                // setup bindings
                videoOutput.contentRect;
                videoOutput.sourceRect;
                // only scan the central quarter of the area for a barcode
                return videoOutput.mapRectToSource(videoOutput.mapNormalizedRectToItem(Qt.rect(
                0.25, 0.25, 0.5, 0.5
            )));
        }
    }

    onResultChanged: {
        var data = result.split(';')
        if(data.length !== 3)
            return qrError()

        var endpointKV = data[0].split(',')
        var tableKV = data[1].split(',')
        var codeKV = data[2].split(',')

        if(endpointKV[0] !== 'endpoint' || tableKV[0] !== 'table' || codeKV[0] !== 'code')
            return qrError()

        endpoint = endpointKV[1]
        table = tableKV[1]
        code = codeKV[1]
    }

    Text {
        id: text
        color: "yellow"
        anchors.centerIn: parent
    }

    function qrError() {
        text.text = "INVALID QR CODE FORMAT: "+result
        console.error("INVALID QR CODE FORMAT: "+result)
    }

    function setOrientation(orientation)
    {

        console.log("orientation: "+orientation)
        /***SET 1***/
//        if(orientation === 1)
//        {
//            videoOutput.orientation = 270;
//        }
//        if(orientation === 2)
//        {
//            videoOutput.orientation = 0;
//        }
//        else if(orientation === 8)
//        {
//            videoOutput.orientation = 180;
//        }
//        else if(orientation === 4)
//        {
//            videoOutput.orientation = 90;
//        }


        /***SET 2***/
        if(orientation === 1)
        {
            videoOutput.orientation = 90;
        }
        if(orientation === 2)
        {
            videoOutput.orientation = 180;
        }
        else if(orientation === 8)
        {
            videoOutput.orientation = 0;
        }
        else if(orientation === 4)
        {
            videoOutput.orientation = 270;
        }
    }

}
