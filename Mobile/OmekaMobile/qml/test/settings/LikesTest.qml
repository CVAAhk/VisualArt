import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.LocalStorage 2.0
import "../../js/storage.js" as Settings

ApplicationWindow {
    id: window
    visible: true
    width: 470; height: 800
    property string table : "likes"

    Component.onCompleted: {
       var rows = Settings.rows(table)
       for(var i=0; i<rows.length; i++){
          model.setProperty(rows[i].setting, "liked", true)
       }
    }

    ListModel{
        id: model

        ListElement{
            index: 0
            liked: false
            thumb: "http://mallhistory.org//files//thumbnails//0ef6913467dd1ef22e66e2c0b2cb63ae.jpg"
        }

        ListElement{
            index: 1
            liked: false
            thumb: "http://mallhistory.org//files//thumbnails//2f634c2373adbaf7f36dfb3ddd8dc5f2.jpg"
        }

        ListElement{
            index: 2
            liked: false
            thumb: "http://mallhistory.org//files//thumbnails//49a87bcaedcec9f0ed6557d0c0041280.jpg"
        }

        ListElement{
            index: 3
            liked: false
            thumb: "http://mallhistory.org//files//thumbnails//36716395ae3bad99e18b11fe3b8ffe5e.jpg"
        }
    }

    Component{
        id: delegate
        Item{
            width: 175; height: 175
            Image{
                id:image
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "image://testprovider/"+thumb
            }
            RadioButton{
                id: heart
                checked: liked
                property int setting: index
                onClicked: {
                    if(checked){
                        Settings.set(table, setting, image.source)
                    }
                    else{
                        Settings.remove(table, setting)
                    }
                }
            }
        }
    }

    ListView{
        id:view
        anchors.fill: parent
        anchors.centerIn: parent
        model: model
        delegate: delegate
    }

    Button{
        width: parent.width
        anchors.bottom: parent.bottom
        text: "Clear"
        onClicked: {
            for(var i=0; i<model.count; i++){
                model.get(i).liked = false
            }
            Settings.clear(table)
        }
    }

}
