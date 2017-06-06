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
    property var orderedLikes: []

    //for initial ordering
    property var loadedLikes: ({})

    //reference to all registered likes for filtering
    property var all: ({})

    //links items to their host omeka instance
    property var filters: ({})

    //initialize loading likes from local storage
    Component.onCompleted: {
        var entry
        var item_id
        var uid

        var _likes = ItemManager.getLikes()
        for(var i=0; i<_likes.length; i++) {
            entry = _likes[i]
            uid = entry.setting
            item_id = uid.substring(uid.lastIndexOf("-")+1)
            orderedLikes.push(uid)
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
            filter.close()
        }
        ItemManager.onLikesView = enabled
    }

    //update ui on item add/remove
    Connections {
        target: ItemManager

        onItemAdded: {
            if(indices.indexOf(item.uid) === -1) { //add item
                addItem(ItemManager.itemToData(item));
            }
            if(removals[item.uid]) { //update removals
                delete removals[item.uid];
            }
        }

        onItemRemoved: {
            if(indices.indexOf(item.uid) !== -1) {
                if(enabled) { //postpone removals for disabled state
                    removals[item.uid] = item
                } else {   //remove immediately on disabled
                    removeItem(item)
                    //Heist.unregisterItem(item.id) //update to new id system
                }
            }
        }

        onClearItems: {
            browser.clear()
            indices.length = 0
            removals = ({})
            all = ({})
            filters = ({})
            filter.clear()
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
            onFilterIDChanged: {
                print(filterID)
            }
        }

        Browser {
            id: browser
            height: parent.height - bar.height
            clip: true
            list.bottomMargin: Resolution.applyScale(150) + filter.height
            grid.bottomMargin: Resolution.applyScale(120) + filter.height

            list.addDisplaced: Transition {
                NumberAnimation { property: "y"; duration: 200 }
            }
            grid.addDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 200 }
            }

            list.removeDisplaced: Transition {
                NumberAnimation { property: "y"; duration: 200 }
            }
            grid.removeDisplaced: Transition {
                NumberAnimation { property: "y"; duration: 200 }
            }
        }
    }

    /*
      Load likes from local database
    */
    function loadFromStorage(item) {
        if(item) {
            loadedLikes[item.uid] = item
        }

        //load in stored order
        var loadCount = Object.keys(loadedLikes).length
        if(loadCount === orderedLikes.length) {
            for(var i in orderedLikes) {
                normalizeAndAddItem(loadedLikes[orderedLikes[i]])
            }
            loadedLikes = null
            orderedLikes.length = 0
        }
    }

    /*
      Handle invalid item requests for cases where a liked item has been removed
      from the omeka repository
     */
    function handleInvalidRecord(result) {
        var _endpoint = result.url.substring(0, result.url.lastIndexOf("api"))
        var _omekaID = Omeka.prettyName(_endpoint)
        var _itemID = result.url.substring(result.url.lastIndexOf("/")+1)
        var _uid = _omekaID+"-"+_itemID
        orderedLikes.splice(orderedLikes.indexOf(_uid), 1)
        ItemManager.unregisterLike({uid: _uid})
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
        indices.unshift(item.uid)
        addItemToFilter(item)
    }

    /*
      Remove liked item by index
    */
    function removeItem(item) {
        var index = indices.indexOf(item.uid)
        browser.remove(index)
        indices.splice(index, 1)
        removeItemFromFilter(item)
    }

    /*
      Assign item to filter
     */
    function addItemToFilter(item) {

        //register with master
        all[item.uid] = item

        //assign to filter based on omeka id
        if(!filters[item.omekaID]) {
            filters[item.omekaID] = []
            filter.addFilter(item.omekaID, item.endpoint)
        }
        filters[item.omekaID].unshift(item.uid)
    }

    /*
      Remove item from filter
     */
    function removeItemFromFilter(item) {

        //unregister from master
        delete all[item.uid]

        //remove filter
        var index = filters[item.omekaID].indexOf(item.uid)
        filters[item.omekaID].splice(index, 1)
        if(filters[item.omekaID].length === 0) {
            delete filters[item.omekaID]
            filter.removeFilter(item.omekaID)
        }
    }
}
