pragma Singleton
import QtQuick 2.5
import QtQuick.LocalStorage 2.0
import "settings.js" as Settings

Item {

    /*-------------DETAIL-------------*/
    /*!
      \qmlproperty
      Data object of the currently selected item
    */
    property var current: ({})

    property var selectedItems: []

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

    property string tagSearchLowerLeft
    property string tagSearchLowerRight
    property string tagSearchTopLeft
    property string tagSearchTopRight

    /*!
      \qmlproperty
      Triggers items by keyword query
    */
    property string searchTerm

    /*-------------LIKES-------------*/

    /*!
      \qmlmethod
      Add like to local database
    */
    function registerLike(item) {
        if(!isLiked(item)) {
            Settings.addLike(item.id, itemToEntry(item))
        }
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
