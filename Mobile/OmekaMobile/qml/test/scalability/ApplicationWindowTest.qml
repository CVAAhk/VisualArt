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

    Binding{ target: window.contentItem.parent.anchors; property: "top"; value: toolBar.parent.bottom }

    toolBar: ToolBar{

        state: "show"
        states: [
            State{ name: "show"; AnchorChanges { target:toolBar.parent; anchors.top: parent.top; anchors.bottom: undefined } },
            State{ name: "hide"; AnchorChanges { target:toolBar.parent; anchors.top: undefined; anchors.bottom: parent.top } }
        ]

        transitions: Transition{
            AnchorAnimation { duration: 250; easing.type: Easing.InOutQuad }
        }

        Button{
            id: button
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

        onCurrentIndexChanged: {
            toolBar.state = "show"
        }

        Tab{
            title: "Home"
            HomePage{
                enabled: true
                onStateChanged: {
                    if(state !== "none"){
                        toolBar.state = state === "down" ? "show" : "hide"
                    }
                }
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
