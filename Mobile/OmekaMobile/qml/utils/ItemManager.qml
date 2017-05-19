pragma Singleton
import QtQuick 2.5
import QtQuick.LocalStorage 2.0
import "../js/storage.js" as Settings

Item {

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

    /*!
      \qmlmethod
      Add like to local database
    */
    function registerLike(item) {
        if(!isLiked(item)) {
            Settings.addLike(String(item.id), itemToEntry(item))
            itemAdded(item)
            addRecentLike(item.id)
        }
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
        Settings.removeLike(String(item.id))
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
      Format data object to semi-colon delimited entry
    */
    function itemToEntry(item) {
        var entry = item.fileCount;
        var element;
        for(var i=0; i<item.metadata.count; i++) {
            element = item.metadata.get(i);
            entry += "^"+element.element.name+"|"+element.text;
        }
        return entry;
    }

    /*!
      \qmlmethod
      Convert data entry to object
    */
    function entryToItem(setting, value) {
        var item = {item: setting}
        var values = value.split("^")
        item.file_count = values[0]

        item.metadata = []
        var mdmap

        for(var i=1; i<values.length; i++) {
            mdmap = values[i].split("|")
            item.metadata.push({ element: {name: mdmap[0]} ,text:mdmap[1]})
        }

        return item
    }

    /*!
      \qmlmethod
      Converts item to omeka result data format
    */
    function itemToData(item) {
        return {item: String(item.id), metadata: item.metadata, file_count: String(item.fileCount)};
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
        return Settings.isLiked(String(item.id))
    }

    /*!
      \qmlmethod
      Returns all registered likes
    */
    function getLikes() {
        var entries = Settings.getLikes()
        var likes = []
        for(var i=0; i<entries.length; i++) {
             likes.push(entryToItem(entries[i].setting, entries[i].value))
        }
        return likes
    }

    /*!
      \qmlmethod
      Add item to list of recently liked items
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
}
