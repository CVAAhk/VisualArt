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

    //items tagged for removal
    property var removals: ({})

    //used to normalize data types
    property var normalizer: ListModel{}

    //maintains saved order
    property var orderedLikes: []

    //for initial ordering
    property var loadedLikes: ({})

    //uid to item mapping of all registered likes
    property var registry: ({})

    //links items to their host omeka instance
    property var filters: {"all": []}

    //currently selected filter
    property var currentFilter: filter.filterID

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
        if(likes.enabled) {
            ItemManager.clearRecentLiked()
        }
        else {
            for(var i in removals) {
                ItemManager.unregisterLike(removals[i], false);
            }
            removals = ({})
            filter.close()
        }
        ItemManager.onLikesView = likes.enabled
    }

    //update ui on item add/remove
    Connections {
        target: ItemManager

        onItemAdded: {
            if(filters["all"].indexOf(item.uid) === -1) { //add item
                addItem(ItemManager.itemToData(item));
            }
            if(removals[item.uid]) { //update removals
                delete removals[item.uid];
            }
        }

        onItemRemoved: {
            if(filters["all"].indexOf(item.uid) !== -1) {
                if(likes.enabled) { //postpone removals for disabled state
                    removals[item.uid] = item
                } else {   //remove immediately on disabled
                    removeItem(item)
                }
            }
        }

        onClearItems: {
            browser.clear()
            removals = ({})
            registry = ({})
            filters = {"all": []}
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
        }
    }

    //update filter
    onCurrentFilterChanged: applyFilter()

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

        //register with master
        registry[item.uid] = item

        //add to global filter
        filters["all"].unshift(item.uid)

        //assign to filter based on omeka id
        if(!filters[item.omekaID]) {
            filters[item.omekaID] = []
            filter.addFilter(item.omekaID, item.endpoint)
        }
        filters[item.omekaID].unshift(item.uid)

        //add to browser if it belongs to current filter
        if(currentFilter === "all" || currentFilter === item.omekaID) {
            browser.insert(0, item)
        }
    }

    /*
      Remove liked item
    */
    function removeItem(item) {
        //unregister from master
        delete registry[item.uid]

        //update global filter
        var a_index = filters["all"].indexOf(item.uid)
        filters["all"].splice(a_index, 1)

        //remove item from filter
        var f_index = filters[item.omekaID].indexOf(item.uid)
        filters[item.omekaID].splice(f_index, 1)

        //remove filter if it has no items
        if(filters[item.omekaID].length === 0) {
            delete filters[item.omekaID]
            filter.removeFilter(item.omekaID)
        }

        //remove item from browser if it belongs to current filter
        if(currentFilter === "all"){
            browser.remove(a_index)
        } else if(currentFilter === item.omekaID) {
            browser.remove(f_index)
        }
    }

    function applyFilter() {
        if(filters[currentFilter]) {
            browser.clear()
            for(var filter in filters[currentFilter]) {
                var uid = filters[currentFilter][filter]
                browser.append(registry[uid])
            }
        }
    }
}
