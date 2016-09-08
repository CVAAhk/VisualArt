import QtQuick 2.0
import "../../../utils"

State {
    property variant viewer
    property variant media

    PropertyChanges { target: media; explicit: true; visible: true; enabled: true; source: viewer.sources[0] }
    PropertyChanges { target: viewer; current: media; scale: media.fillScale}
}
