import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../utils"

ApplicationWindow {
    id: root
    visible: true
    width: 470; height: 800

    Component.onCompleted: {
        Omeka.getFiles(472, root);
    }

    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.context === root) {
                if(Omeka.mediaType(result.media) === "image"){
                    list.model.append({src:result.media})
                }
            }
        }
    }

    Component {
        id: img
        Image {
           anchors.verticalCenter: parent.verticalCenter
           asynchronous: true
           source: src
           onStatusChanged: {
               if(status === Image.Ready) {
                  list.width = Math.max(width, list.width)
                  list.height = Math.max(height, list.height)
               }
           }
        }
    }

    Item {
        id: main
        anchors.fill: parent
        Rectangle {
            width: list.width
            height: list.height
            color: "red"
            scale: width < root.width ? root.width/width: 1
            x: (width*scale - width)/2
            y: (height*scale - height)/2

            ListView{
                id: list
                model: ListModel {}
                delegate: img
                orientation: ListView.Horizontal
                spacing: 30
                snapMode: ListView.SnapOneItem
                cacheBuffer: width*model.count
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: currentItem ? width/2 - currentItem.width/2 : 0
                preferredHighlightEnd: currentItem ? width/2 + currentItem.width/2: 0
            }
        }
    }
}
