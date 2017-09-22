import QtQuick 2.5
import QtQuick.Controls 1.4
import QZXing 2.3
import QtMultimedia 5.5

Item {

    property alias cameraOrientation: videoOutput.orientation

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
        orientation: -90

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
            onTagFound: {
                count++
                text.text = "QR Result "+tag;
            }
        }
    }

    Text {
        id: text
        color: "yellow"
        anchors.centerIn: parent
    }

}
