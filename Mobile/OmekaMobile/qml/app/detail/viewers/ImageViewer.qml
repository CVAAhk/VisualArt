import QtQuick 2.5
import "../../base"
import "../../../utils"

/*
  \qmltype ImageViewer

  ImageViewer provides image view and manipulation controls.
*/
OmekaViewer {
    id: root    
    sourceWidth: nav.sourceWidth
    sourceHeight: nav.sourceHeight

    //image element
    display: Item{

       id: item
       width: nav.width
       height: nav.height

       property alias displayWidth: nav.imageWidth
       property alias displayHeight: nav.imageHeight
       property real contentWidth: portrait ? zoom.width : width
       property real contentHeight: portrait ? height: zoom.height

       ImageNav{
            id: nav
            visible: !fullScreen
            urls: root.visible ? viewer.images : null
        }

       ImageZoom {
           id: zoom
           anchors.centerIn: parent
           visible: root.visible && fullScreen
           width: Resolution.appWidth/parent.scale
           height: Resolution.appHeight/parent.scale
           source: nav.currentItem ? nav.currentItem.source : ""
           contentWidth: item.contentWidth
           contentHeight: item.contentHeight
           onVisibleChanged: root.updateContent()
       }
    }

    onPortraitChanged: updateContent()

    function updateContent() {
        if(portrait) {
            zoom.contentWidth = zoom.width
            zoom.contentHeight = item.height
        } else {
            zoom.contentWidth = item.width
            zoom.contentHeight = zoom.height
        }
    }
}
