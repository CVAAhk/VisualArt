import QtQuick 2.5

/*!
   \qmltype OmekaViewer

   OmekaViewer is the base class for the various omeka media types.
  */
Item {
    visible: false

    /*!
        \qmlproperty url OmekaViewer::source
        File url of media item
    */
    property url source
    /*!
        \qmlproperty real OmekaViewer::sourceWidth
        Actual width of source file
    */
    property real sourceWidth
}
