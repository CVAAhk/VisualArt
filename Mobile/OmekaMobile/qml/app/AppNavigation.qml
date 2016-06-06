import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../utils"

TabView {
    property real targetHeight: 192
    anchors.fill: parent
    tabPosition: Qt.BottomEdge

    Tab{}
    Tab{}
    Tab{}

    style: TabViewStyle {
        frameOverlap: 0
        tabsAlignment: Qt.AlignHCenter
        property var icons: ["home", "search", "likes"]

        //content background
        frame: Rectangle { color: Style.backgroundColor }

        //tab background
        tab:Rectangle{
            color: styleData.selected ? Style.tabSelected : Style.tabDefault
            implicitWidth: Resolution.appWidth/3
            implicitHeight: targetHeight * Resolution.scaleRatio

            //icons
            Item{
                anchors.centerIn: parent
                width: childrenRect.width
                height: childrenRect.height
                scale: (parent.height*.56)/height
                Image{
                    source: "../../ui/"+icons[styleData.index]+"-off.png"
                    visible: !styleData.selected
                }
                Image{
                    source: "../../ui/"+icons[styleData.index]+"-on.png"
                    visible: styleData.selected
                }
            }
        }
    }
}
