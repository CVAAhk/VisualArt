import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import "../../js/UI.js" as UI

ApplicationWindow {
    id:window
    visible:true
    title: "Omeka Mobile"

    width:470;
    height:800;

    toolBar: ToolBar{
        Button{
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: height
        }
    }

    TabView{
        id: tabView

        anchors.fill: parent
        anchors.margins: UI.margin
        tabPosition: UI.tabPosition

        Layout.minimumWidth: 360
        Layout.minimumHeight: 360
        Layout.preferredWidth: 470
        Layout.preferredHeight: 800

        Tab{
            title: "Home"
            HomePage{
                enabled: true
            }
        }
        Tab{
            title: "Search"
            SearchPage{
                enabled:true
            }
        }
        Tab{
            title: "Likes"
            Rectangle{
                anchors.fill: parent
                color:"blue"
            }
        }
    }

}
