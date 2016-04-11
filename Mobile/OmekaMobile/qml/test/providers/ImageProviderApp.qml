import QtQuick 2.0
import QtQuick.Controls 1.4

ApplicationWindow {
    visible:true
    width: 800; height:600

    Image{
        id: img
        anchors.centerIn: parent
        source: "image://testprovider/http://mallhistory.org//files//original//0ef6913467dd1ef22e66e2c0b2cb63ae.jpg"
        onStatusChanged: {
            if(status == Image.Ready)
                indicator.running = false;
        }
    }

    BusyIndicator{
        id: indicator
        anchors.centerIn: parent
        running: false
    }

    MouseArea{
        anchors.fill: parent
        onClicked:{
            indicator.running = true;
            img.source = "image://testprovider/http://mallhistory.org//files//thumbnails//0ef6913467dd1ef22e66e2c0b2cb63ae.jpg"
        }
    }
}
