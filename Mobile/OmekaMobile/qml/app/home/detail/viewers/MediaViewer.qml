import QtQuick 2.5
import "../../../base"

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
      \qmlproperty url MediaViewer::source
      The url of the media file
    */
    property url source
    /*!
      \qmlproperty OmekaViewer MediaViewer::current
      The current child viewer
    */
    property OmekaViewer current
    /*!
      \internal
      Regex of supported image formats
    */
    property var imageExt: /\.(jpe?g|png|gif|tif?f)$/i
    /*!
      \internal
      Regex of supported audio formats
    */
    property var audioExt: /\.(mp3)$/i
    /*!
      \internal
      Regex of supported video formats
    */
    property var videoExt: /\.(avi|mpe?g|mp4|qt|swf|wmv)$/i

    //supported media viewers
    ImageViewer { id: image }
    VideoViewer { id: video }
    AudioViewer { id: audio }
    DocumentViewer { id: document }

    //updates state according to file type
    Binding { target: viewer; property: "state"; value: type() }

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
        },
        MediaState {
            name: "document"
            viewer: viewer
            media: document
        }
    ]

    /*! /internal Returns media type of source file*/
    function type() {
        if(imageExt.test(source))
            return "image";
        if(audioExt.test(source))
            return "audio"
        if(videoExt.test(source))
            return "video"
    }
}
