import QtQuick 2.0
import "."
import "settings.js" as Settings
Item
{
    id: root
    property int randomCount: 2

    property int file_id : -1

//    property var imageItem1
//    property var imageItem2

//    Component.onCompleted:
//    {

//        var component = Qt.createComponent("AttractImageItem.qml");

//        if (component.status === Component.Ready)
//        {
//            console.log("Component ready")
//            imageItem1 = component.createObject(root);
//            imageItem2 = component.createObject(root);
//            //imageItem1.result = result
//            imageItem1.x = 750;
//            imageItem2.x = 970;

//            //random_timer.start();
//        }
//    }
    AttractImageItem{
        id : imageItem1
        x: 750
    }
    AttractImageItem {
        id: imageItem2
        x: 970
    }



//    Timer
//    {
//        id: random_timer
//        interval: Settings.ATTRACT_RANDOM_TIMER
//        repeat: true
//        onTriggered:
//        {
//            imageItem1.setInfo();
//            imageItem2.setInfo();
//        }
//    }


}
