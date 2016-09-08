import QtQuick 2.5
import "../../base"
import "../../../utils"

/*
  \qmltype ImageViewer

  ImageViewer provides image view and manipulation controls.
*/
OmekaViewer {
    id: root
    sourceWidth: img.sourceSize.width
    sourceHeight: img.sourceSize.height        

    //image element
    display: Item{

       id: item
       width: img.width
       height: img.height

       property alias displayWidth: img.width
       property alias displayHeight: img.height
       property real contentWidth: portrait ? zoom.width : width
       property real contentHeight: portrait ? height: zoom.height

       Image{
            id: img
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            visible: !fullScreen                        
            Binding on source { when: root.visible; value: viewer.sources[0] }
        }

       ImageZoom {
           id: zoom
           anchors.centerIn: parent
           visible: root.visible && fullScreen
           width: Resolution.appWidth/parent.scale
           height: Resolution.appHeight/parent.scale
           source: img
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
