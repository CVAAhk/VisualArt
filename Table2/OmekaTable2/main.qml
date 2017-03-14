import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import "settings.js" as Settings

ApplicationWindow {
    visible: true
    width: Settings.SCREEN_WIDTH
    height: Settings.SCREEN_HEIGHT
    visibility: Settings.fullscreen ? "FullScreen" : "Windowed";
    title: qsTr("OmekaTable2")

    Gallery
    {
        width: Settings.SCREEN_WIDTH
        height: Settings.SCREEN_HEIGHT
    }

//    SwipeView {
//        id: swipeView
//        anchors.fill: parent
//        currentIndex: tabBar.currentIndex

//        Page1 {
//        }

//        Page {
//            Label {
//                text: qsTr("Second page")
//                anchors.centerIn: parent
//            }
//        }
//    }

//    footer: TabBar {
//        id: tabBar
//        currentIndex: swipeView.currentIndex
//        TabButton {
//            text: qsTr("First")
//        }
//        TabButton {
//            text: qsTr("Second")
//        }
//    }
}
