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
        var likes = ItemManager.getLikes()
        var like
        for(var i=0; i<likes.length; i++) {
            addItem(likes[i])
        }
    }

    //clear removals when disabled
    onEnabledChanged: {
        if(!enabled) {
            for(var i in removals) {
                removeItem(indices.indexOf(removals[i]))
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
            if(indices.indexOf(item.id) === -1) { //add item
                var data = {item: item.id, metadata: item.metadata, file_count: String(item.fileCount) }
                addItem(data)
            }
            if(removals.indexOf(item.id) !== -1) { //update removals
                removals.splice(removals.indexOf(item.id), 1);
            }
        }

        onItemRemoved: {
            if(indices.indexOf(item.id) !== -1) {
                if(enabled) { //postpone removals for disabled state
                    removals.push(item.id);
                } else {   //remove immediately on disabled
                    removeItem(indices.indexOf(item.id))
                }
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

    function addItem(item) {
        console.log(item.metadata+" "+item.metadata.count)
        browser.insert(0, item)
        indices.unshift(item.item)
    }

    function removeItem(index) {
        browser.remove(index)
        indices.splice(index, 1)
    }
}
