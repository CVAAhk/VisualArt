pragma Singleton
import QtQuick 2.5
import QtQuick.LocalStorage 2.0
import "../js/storage.js" as Settings
import "../app/clients"

Item {
    id: item_manager

    /*-------------DETAIL-------------*/
    /*!
      \qmlproperty
      Data object of the currently selected item
    */
    property var current: ({})

    /*!
      \qmlproperty
      Flag indicating current item is in full screen mode
    */
    property bool fullScreen: false


    /*-------------SEARCH-------------*/

    /*!
      \qmlproperty
      Triggers items by tag query
    */
    property string tagSearch

    /*!
      \qmlproperty
      Triggers items by keyword query
    */
    property string searchTerm

    /*-------------LIKES-------------*/

    //ui notifications
    signal itemAdded(var item)
    signal itemRemoved(var item)
    signal clearItems()

    //items liked since the last view
    property var recentlyLiked: []

    //tracks number of likes since last view
    property int newLikes: 0

    //likes view is current
    property bool onLikesView: false

    //upgrade schema for previous installations
    Component.onCompleted: upgradeLikes()

    //listen to likes registered through heist
    Connections {
        target: Heist
        onHeistLike: {
            registerLike(item)
        }
    }

    /*!
      \qmlmethod
      Add like to local database
    */
    function registerLike(item) {
        if(!isLiked(item)) {
            Settings.addLike(Omeka.omekaID, Omeka.endpoint, item.id)
        }
        itemAdded(item)
        addRecentLike(item.id)
    }

    /*!
      \qmlmethod
      Remove like from local database
      \a item The item to register
      \a bypass Skip data removal and invokes signal with the assumption removal will
                be finalized at a later time
    */
    function unregisterLike(item, bypass) {
        itemRemoved(item)
        removeRecentLiked(item.id)
        if(bypass) return;
        Settings.removeLike(Omeka.omekaID, item.id)
    }

    /*!
      \qmlmethod
      Remove all likes from local database
    */
    function unregisterAllLikes() {
        Settings.clearAllLikes()
        clearItems()
        clearRecentLiked()
    }

    /*!
      \qmlmethod
      Converts item to omeka result data format
    */
    function itemToData(item) {
        return {item: item.id, metadata: item.metadata, file_count: item.fileCount};
    }

    /*!
      \qmlmethod
      Converts omeka result to item data format
    */
    function dataToItem(data) {
        return {id: data.item, metadata: data.metadata, fileCount: data.file_count};
    }

    /*!
      \qmlmethod
      Returns true if the item has an entry in the database
    */
    function isLiked(item) {
        return Settings.isLiked(Omeka.omekaID, String(item.id))
    }

    /*!
      \qmlmethod
      Returns all registered likes
    */
    function getLikes() {
        return Settings.getLikes()
    }

    /*!
      \qmlmethod
      Add item to list of recently liked items. This is used to assign a count
      to the likes number tag notification.
    */
    function addRecentLike(id) {
        if(onLikesView) return
        if(recentlyLiked.indexOf(id) === -1) {
            recentlyLiked.push(id)
            newLikes = recentlyLiked.length
        }
    }

    /*!
      \qmlmethod
      Remove item from list of recently liked items
    */
    function removeRecentLiked(id) {
        if(recentlyLiked.indexOf(id) !== -1) {
            recentlyLiked.splice(recentlyLiked.indexOf(id), 1)
            newLikes = recentlyLiked.length
        }
    }

    /*!
      \qmlmethod
      Clear all recently liked items
    */
    function clearRecentLiked() {
        recentlyLiked.length = 0
        newLikes = 0
    }

    /*!
      \qmlmethod
      The LIKES table is being repurposed for storage of items from multiple omeka instances.
      This call removes all records of the previous schema. Since the previous schema is pre-deployment,
      this will be irrelevant in most cases but test cases need to be handled to not conflict with previous
      installations.
    */
    function upgradeLikes() {

        var entries = Settings.getLikes()

        //if old schema, drop likes table
        for(var i=0; i<entries.length; i++) {
            var data = entries[i].value
            if(data && data.indexOf("^Title|") !== -1) {
                Settings.drop(Settings.LIKES);
                return;
            }
        }
    }
}
