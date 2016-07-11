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


    /*-------------SEARCH-------------*/

    property string searchTerm

    /*-------------LIKES-------------*/

    /*!
      \qmlmethod
      Add like to local database
    */
    function registerLike(item) {
        Settings.addLike(item.id, itemToEntry(item))
    }

    /*!
      \qmlmethod
      Remove like from local database
    */
    function unregisterLike(item) {
        Settings.removeLike(item.id)
    }

    /*!
      \qmlmethod
      Format data object to semi-colon delimited entry
    */
    function itemToEntry(item) {
        return item.metadata+";"+item.fileCount
    }

    /*!
      \qmlmethod
      Convert data entry to object
    */
    function entryToItem(setting, value) {
        var item = {item: setting}
        var values = value.split(";")
        item.metadata = values[0]
        item.file_count = values[1]
        return item
    }

    /*!
      \qmlmethod
      Returns true if the item has an entry in the database
    */
    function isLiked(item) {
        return Settings.isLiked(item.id)
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
}
