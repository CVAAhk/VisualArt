import QtQuick 2.0
import QtQuick.Controls 1.4
import "../base"
import "../../utils"
import "../home/gallery"

/*! Display items liked by user */
Item {
    id: likes
    enabled: false

    //track item indices
    property var indices: []

    //items tagged for removal
    property var removals: []

    //load likes from local storage on init
    Component.onCompleted: {
        var likes = ItemManager.getLikes();
        var like;
        for(var i=0; i<likes.length; i++) {
            like = likes[i];
            browser.insert(0, like)
            indices.unshift(like.item)
        }
    }

    //clear removals when disabled
    onEnabledChanged: {
        if(!enabled) {
            var index;
            for(var i in removals) {
                index = indices.indexOf(removals[i])
                browser.remove(index)
                indices.splice(index, 1)
            }
            removals.length = 0
            filter.close()
        }
    }

    //update ui on item add/remove
    Connections {
        target: ItemManager

        //immediately update additions
        onItemAdded: {
            if(indices.indexOf(item.id) === -1) {
                //indices.unshift(item.id)
            }
            if(removals.indexOf(item.id) !== -1) {
                removals.splice(removals.indexOf(item.id), 1);
            }
        }
        //postpone removals for disabled state
        onItemRemoved: {
            if(indices.indexOf(item.id) !== -1) {
                removals.push(item.id);
            }
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

        LikesFilter{
            id: filter
        }

        Browser {
            id: browser
            height: parent.height - bar.height
            clip: true
            list.bottomMargin: Resolution.applyScale(150) + filter.height
            grid.bottomMargin: Resolution.applyScale(120) + filter.height
        }

    }
}
