import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
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
                interactive: model.count > 1

                Item{
                    visible: list.interactive
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.height*parent.scale*.1

                    Row{
                        spacing: 0
                        anchors.centerIn: parent
                        ExclusiveGroup { id: indices }
                        Repeater {
                            model: list.model.count
                            RadioButton {
                                enabled: false
                                exclusiveGroup: indices
                                checked: index === list.currentIndex

                                style: RadioButtonStyle {
                                    indicator: Image {
                                        fillMode: Image.PreserveAspectFit
                                        source: Style.index
                                        width: 10

                                        Image{
                                            anchors.fill: parent
                                            source: Style.indexFill
                                            visible: control.checked
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
