import QtQuick 2.0
import QtQuick.Controls 1.4
import "../base"
import "../../utils"
import "../home/gallery"

/*! Display items liked by user */
Item {

    //register updates
    Component.onCompleted: update()
    onVisibleChanged: update()

    /*! Title and navigation components */
    Column {
        anchors.fill: parent
        spacing: 0

        OmekaToolBar {
            id: bar
            OmekaText {
                anchors.centerIn: parent
                text: "LIKES"
                _font: Style.titleFont
            }
        }

        Browser {
            id: browser
            height: parent.height - bar.height
        }

    }

    /*! Update registered likes on visible state change*/
    function update(){
        if(visible){
            var likes = ItemManager.getLikes();
            for(var i=0; i<likes.length; i++) {
                browser.append(likes[i])
            }
        }
        else{
            browser.clear();
        }
    }

}
