import QtQuick 2.5
import "viewers"
import "../../base"

/*!
  \qmltype ScaleColumn

  ScaleColumn is a custom layout which accounts for possible scale transformations
  on the media viewer. This is a necessity for \c QtQuick 2.5 since anchors to not
  consider sibling transformations nor does the \c childrenRect property provide a
  transformed bounding box.
*/
Item {

    id: column

    /*!
      \qmlproperty DetailToolbar ScaleColumn::toolbar
      Displays page operations
    */
    property DetailToolbar toolbar

    /*!
      \qmlproperty MediaViewer ScaleColumn::viewer
       Media content display
    */
    property MediaViewer viewer

    /*!
      \qmlproperty OmekaText ScaleColumn::info
       Info panel for content metadata
    */
    property OmekaText info

    /*! \internal
        Scaled viewer height
    */
    property real viewerHeight: viewer.height * viewer.scale

    /*! \internal
        Vertical offset caused by scale transforms
    */
    property real viewerYOffset: viewerHeight/2 - viewer.height/2

    //parenting
    Binding { target: toolbar; property: "parent"; value: column }
    Binding { target: viewer; property: "parent"; value: column }
    Binding { target: info; property: "parent"; value: column }

    //vertical positioning
    Binding { target: viewer; property: "y"; value: toolbar.height + viewerYOffset }
    Binding { target: info.anchors; property: "top"; value: toolbar.bottom }
    Binding { target: info.anchors; property: "topMargin"; value: viewerHeight }

}
