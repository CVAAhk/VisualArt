import QtQuick 2.0
import QtQuick.Controls 1.4
import "../base"
import "../../utils"
import "../home/gallery"

/*! Display items liked by user */
Item {
    id: likes
    enabled: false

    //refresh liked items current change
    onEnabledChanged: {
        if(enabled) {
            var likes = ItemManager.getLikes();
            for(var i=0; i<likes.length; i++) {
                browser.insert(0, likes[i])
            }
        }
        else {
            browser.clear()
        }
    }

    /*! Title and navigation components */
    Column {
        anchors.top: likes.top
        anchors.topMargin: Resolution.applyScale(40)
        anchors.fill: parent
        spacing: Resolution.applyScale(30)

        OmekaToolBar {
            id: bar
            height: Resolution.applyScale(130)
            OmekaText {
                anchors.centerIn: parent
                text: "LIKES"
                _font: Style.titleFont
            }
        }

        LikesFilter{}

        Browser {
            id: browser
            height: parent.height - bar.height
        }

    }
}
