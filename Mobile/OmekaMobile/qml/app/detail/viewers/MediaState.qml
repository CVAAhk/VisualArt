import QtQuick 2.0
import "../../../utils"

State {
    property variant viewer
    property variant media
    property real wScale: viewer.width > media.sourceWidth ? viewer.width / media.sourceWidth : 1
    property real hScale: viewer.height > media.sourceHeight ? viewer.height / media.sourceHeight : 1
    property real fillScale: Resolution.portrait ? wScale : hScale

    PropertyChanges { target: media; explicit: true; visible: true; enabled: true; source: viewer.source }
    PropertyChanges { target: viewer; current: media; scale: fillScale}
}
