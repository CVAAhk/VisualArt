pragma Singleton
import QtQuick 2.5
import QtQuick.LocalStorage 2.0
import "../js/storage.js" as Settings

Item {

    /*!
      \qmlproperty
      Data object of the currently selected item
    */
    property variant current: ({})

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
        return item.full+";"+item.image+";"+item.media
    }

    /*!
      \qmlmethod
      Convert data entry to object
    */
    function entryToItem(setting, value) {
        var item = {item: setting}
        var values = value.split(";")
        item.full = values[0]
        item.image = values[1]
        item.media = values[2]
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
