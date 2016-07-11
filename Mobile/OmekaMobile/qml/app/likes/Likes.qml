import QtQuick 2.0
import QtQuick.Controls 1.4
import "../base"
import "../../utils"
import "../home/gallery"

/*! Display items liked by user */
Item {
    id: likes

    /*! \internal */
    property bool current: navigator.currentItem === likes

    //refresh liked items current change
    onCurrentChanged: {
        if(current) {
            var likes = ItemManager.getLikes();
            for(var i=0; i<likes.length; i++) {
                browser.append(likes[i])
            }
        }
        else {
            browser.clear()
        }
    }

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
}
