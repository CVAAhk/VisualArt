import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../utils/client"

ApplicationWindow {
    id: root
    visible: true
    width: 470; height: 800

    property bool portrait: true

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
           fillMode: Image.PreserveAspectFit
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
            anchors.centerIn: parent
            property real wScale: width < root.width ? root.width/width: 1
            property real hScale: height < root.height ? root.height/height: 1
            width: list.width
            height: list.height
            scale: portrait ? wScale : hScale
            color: "red"
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
                clip: true

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

    Item {
        focus: true
        Keys.onUpPressed: {
            root.portrait = false
            root.width = 804
            root.height = 470
        }
        Keys.onDownPressed: {
            root.portrait = true
            root.width = 470
            root.height = 804
        }
    }
}
