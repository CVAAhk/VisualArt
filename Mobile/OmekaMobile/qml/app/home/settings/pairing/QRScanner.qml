import QtQuick 2.5
import QtQuick.Controls 1.4
import QZXing 2.3
import QtMultimedia 5.5

Item {

    property var endpoint
    property var table
    property var code
    property var result

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

    QZXingFilter {
        id: zxingFilter

        decoder {
            enabledDecoders: QZXing.DecoderFormat_QR_CODE
            onTagFound: result = tag
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

        text.text = endpoint+"\n"+table+"\n"+code
    }

    function qrError() {
        text.text = "INVALID QR CODE FORMAT: "+result
        console.error("INVALID QR CODE FORMAT: "+result)
    }

    Text {
        id: text
        color: "yellow"
        anchors.centerIn: parent
    }
}
