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
    progress: nav.progress

    //image element
    display: Item{

       id: item
       width: nav.width
       height: nav.height

       property alias displayWidth: nav.imageWidth
       property alias displayHeight: nav.imageHeight

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
       }
    }

    //toggle fullscreen
    MouseArea {
        anchors.fill: parent
        onClicked: ItemManager.fullScreen = !ItemManager.fullScreen
    }

    onPortraitChanged: updateZoom()
    onFullScreenChanged: updateZoom()
    onStateChanged: nav.size()

    function updateZoom() {
        if(portrait) {
            zoom.imgWidth = zoom.width
            zoom.imgHeight = item.height
        } else {
            zoom.imgWidth = item.width
            zoom.imgHeight = zoom.height
        }
    }
}
