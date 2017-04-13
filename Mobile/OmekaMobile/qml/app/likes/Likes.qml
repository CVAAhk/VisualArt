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

    //used to normalize data types
    property var normalizer: ListModel{}

    //load likes from local storage on init
    Component.onCompleted: {
        var likes = ItemManager.getLikes()
        for(var i=0; i<likes.length; i++) {
            normalizeAndAddItem(likes[i])
        }
    }

    //clear removals when disabled
    onEnabledChanged: {
        if(!enabled) {
            for(var i in removals) {
                removeItem(indices.indexOf(removals[i]))
            }
            removals.length = 0
            //filter.close()
        }
    }

    //update ui on item add/remove
    Connections {
        target: ItemManager

        onItemAdded: {
            if(indices.indexOf(item.id) === -1) { //add item
                addItem(ItemManager.itemToData(item));

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

        onClearItems: {
            browser.clear()
            indices.length = 0
            removals.length = 0
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

        /*LikesFilter{
            id: filter
        }*/

        Browser {
            id: browser
            height: parent.height - bar.height
            clip: true
            list.bottomMargin: Resolution.applyScale(150) //+ filter.height
            grid.bottomMargin: Resolution.applyScale(120) //+ filter.height

            list.addDisplaced: Transition {
                NumberAnimation { property: "y"; duration: 200 }
            }
            grid.addDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 200 }
            }
        }
    }

    /*
      Implicitly normalize item data types in order to avoid the requirement
      of dynamic roles on the browser's model
    */
    function normalizeAndAddItem(item) {
        normalizer.append(item)
        addItem(normalizer.get(normalizer.count-1))
    }

    /*
      Add new liked item
    */
    function addItem(item) {
        browser.insert(0, item)
        indices.unshift(item.item)
    }

    /*
      Remove liked item by index
    */
    function removeItem(index) {
        browser.remove(index)
        indices.splice(index, 1)
    }
}
