import QtQuick 2.0

State {
    property variant viewer
    property variant media

    PropertyChanges { target: media; explicit: true; visible: true; source: viewer.source }
    PropertyChanges { target: viewer; current: media; scale: viewer.width > media.sourceWidth ? viewer.width / media.sourceWidth : 1 }
}
