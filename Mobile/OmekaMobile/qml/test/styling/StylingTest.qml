import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import "../styling"

ApplicationWindow {
    id:window
    visible: true
    width: 470; height: 804

    property real refWidth: 1440
    property real refHeight: 2464
    property real h: Math.max(width, height)
    property real w: Math.min(width, height)
    property real scaleRatio: Math.min(h/refHeight, w/refWidth)

    toolBar: ToolBar{
        implicitHeight: 192 * scaleRatio
        style: ToolBarStyle {
            background: Rectangle {
                gradient: Gradient {
                    GradientStop { position: 0 ; color: Style.toolBarColor }
                }
            }
        }

        TitleText{
            id: title
            anchors.centerIn: parent
            text: "Styles Test"
            font.pixelSize: Style.titleFontSize * scaleRatio
            color: Style.titleColor
        }
    }

    TabView{
        id: tabView
        anchors.fill: parent
        tabPosition: Qt.BottomEdge

        Tab{
            Rectangle{
                color: Style.backgroundColor
                Button{
                    id:like
                    scale: scaleRatio
                    checkable: true
                    style: ButtonStyle{
                        background: Image{
                            source: "../../../ui/like-indicator.png"
                            Image{
                                source: "../../../ui/like-fill.png"
                                visible: like.checked
                            }
                        }
                    }
                }
            }
        }

        Tab{ Rectangle{ color:Style.backgroundColor} }
        Tab{ Rectangle{ color:Style.backgroundColor} }

        style: TabViewStyle{
            frameOverlap: 0
            tabsAlignment: Qt.AlignHCenter
            property var icons: ["home", "search", "likes"]

            tab: Rectangle{
                color: styleData.selected ? Style.tabSelected : Style.tabDefault
                implicitWidth: window.width/3
                implicitHeight: toolBar.implicitHeight

                Item{
                    anchors.centerIn: parent
                    width: childrenRect.width
                    height: childrenRect.height
                    scale: (parent.height*.56)/height
                    Image{
                        source: "../../../ui/"+icons[styleData.index]+"-off.png"
                        visible: !styleData.selected
                    }
                    Image{
                        source: "../../../ui/"+icons[styleData.index]+"-on.png"
                        visible: styleData.selected
                    }
                }
            }
        }
    }
}
