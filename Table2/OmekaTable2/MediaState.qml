import QtQuick 2.0
import "."

State {
    property var viewer
    property var media

    PropertyChanges { target: media; explicit: true; /*visible: true;*/ enabled: true; source: viewer.sources[0] }
    PropertyChanges { target: viewer; current: media; scale: media.fillScale}
}
