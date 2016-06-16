import QtQuick 2.5
import "../../../base"

Item {
    id: viewer
    width: parent.width
    height: current.height
    state: "image"

    property url source
    property OmekaViewer current

    ImageViewer { id: image }
    VideoViewer { id: video }
    AudioViewer { id: audio }
    DocumentViewer { id: document }

    states: [
        MediaState {
            name: "image"
            viewer: viewer
            media: image
        },
        MediaState {
            name: "video"
            viewer: viewer
            media: video
        },
        MediaState {
            name: "audio"
            viewer: viewer
            media: audio
        },
        MediaState {
            name: "document"
            viewer: viewer
            media: document
        }
    ]
}
