import QtQuick 2.0
import QtQuick.Controls 1.4
import "../base"
import "../../utils"
import "../clients"
import "../home/gallery"

/*! Display items liked by user */
Item {
    id: likes
    objectName: "LikesList"
    enabled: false

    //track item indices
    property var indices: []

    //items tagged for removal
    property var removals: ({})

    //used to normalize data types
    property var normalizer: ListModel{}

    //maintains saved order
    property var ordered_likes: []

    //for initial ordering
    property var loadedLikes: ({})

    //initialize loading likes from local storage
    Component.onCompleted: {
        var entry
        var item_id
        var key

        var _likes = ItemManager.getLikes()
        for(var i=0; i<_likes.length; i++) {
            entry = _likes[i]
            key = entry.setting
            item_id = ItemManager.getItemIDFromKey(key)
            ordered_likes.push(key)
            Omeka.getItemById(item_id, likes, entry.value+"api/")
        }
    }

    //process item results
    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.context === likes) {
                loadFromStorage(result)
            }
        }
        onEmptyResult: {
            if(result.context === likes) {
                handleInvalidRecord(result)
            }
        }
    }

    //clear removals when disabled
    onEnabledChanged: {
        if(enabled) {
            ItemManager.clearRecentLiked()
        }
        else {
            for(var i in removals) {
                ItemManager.unregisterLike(removals[i], false);
            }
            removals = ({})
            //filter.close()
        }
        ItemManager.onLikesView = enabled
    }

    //update ui on item add/remove
    Connections {
        target: ItemManager

        onItemAdded: {
            if(indices.indexOf(item.id) === -1) { //add item
                addItem(ItemManager.itemToData(item));
            }
            if(removals[item.id]) { //update removals
                removals.splice(removals[item.id], 1);
            }
        }

        onItemRemoved: {
            if(indices.indexOf(item.id) !== -1) {
                if(enabled) { //postpone removals for disabled state
                    removals[item.id] = item
                } else {   //remove immediately on disabled
                    removeItem(indices.indexOf(item.id))
                    Heist.unregisterItem(item.id)
                }
            }
        }

        onClearItems: {
            browser.clear()
            indices.length = 0
            removals = ({})
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
      Load likes from local database
    */
    function loadFromStorage(item) {
        if(item) {
            var omekaID = Omeka.prettyName(item.url.substring(0, item.url.lastIndexOf("api")))
            var key = omekaID+"-"+item.item
            loadedLikes[key] = item
        }

        //load in stored order
        var loadCount = Object.keys(loadedLikes).length
        if(loadCount === ordered_likes.length) {
            for(var i in ordered_likes) {
                normalizeAndAddItem(loadedLikes[ordered_likes[i]])
            }
            loadedLikes = null
            ordered_likes.length = 0
        }
    }

    /*
      Handle invalid item requests for cases where a liked item has been removed
      from the omeka repository
     */
    function handleInvalidRecord(result) {
        var id = result.url
        id = Number(id.substring(id.lastIndexOf("/")+1))
        ordered_likes.splice(ordered_likes.indexOf(id), 1)
        ItemManager.unregisterLike({id:id})
        loadFromStorage()
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
        item.context = likes
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
