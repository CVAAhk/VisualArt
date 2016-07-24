import QtQuick 2.0
import "../../../utils"

State {
    property variant viewer
    property variant media

    PropertyChanges { target: media; explicit: true; visible: true; enabled: true; source: viewer.source }
    PropertyChanges { target: viewer; current: media; scale: media.fillScale; rotation: media.angle}
}
