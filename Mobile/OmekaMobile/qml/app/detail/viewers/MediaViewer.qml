import QtQuick 2.5
import "../../base"
import "../../../utils"

/*!
  \qmltype MediaViewer

  MediaViewer is a component for displaying detailed views of the supported
  Omeka media file types (image, video, audio, and document). The view switches
  to appropriate display based on evalutation of the source value.
*/
Item {
    id: viewer
    width: parent.width
    height: current.height
    state: "image"

    /*!
      \qmlproperty var MediaViewer::sources
      The urls of the media files
    */
    property var sources

    property var images: []

    /*!
      \qmlproperty OmekaViewer MediaViewer::type
      The file type
    */
    property string type

    /*!
      \qmlproperty OmekaViewer MediaViewer::current
      The current child viewer
    */
    property OmekaViewer current    

    onSourcesChanged: {
        images.length = 0
        for(var i=0; i<sources.length; i++){
            if(Omeka.mediaType(sources[i]) === "image"){
                images.push(sources[i])
            }
        }
    }

    //supported media viewers
    ImageViewer { id: image }
    VideoViewer { id: video }
    AudioViewer { id: audio }

    //updates state according to file type
    Binding { target: viewer; property: "state"; value: type }

    //set current viewer
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
        }
    ]
}
