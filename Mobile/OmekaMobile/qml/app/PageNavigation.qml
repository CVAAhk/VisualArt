import QtQuick 2.0
import QtQuick.Controls 1.4
import "../utils"
import "home"
import "search"
import "likes"

/*!
  \qmltype PageNavigation

  PageNavigation provides navigation controls to transition through a stack of pages
*/
StackView {
    id: navigator
    width: parent.width
    height: parent.height    
    initialItem: home

    /*!
      \internal
      Home page instance
    */
    property Home home: Home {}

    /*!
      \internal
      Search page instance
    */
    property Search search: Search {}

    /*!
      \internal
      Likes page instance
    */
    property Likes likes: Likes {}

    /*!
      \internal
      Tracks previous item on currentItem change
    */
    property var previousItem

    /*!
      \internal
      Main navigation pages
    */
    property var pages: [home, search, likes]

    /*!
      \internal
      Tracks currently selected item
    */
    property var item: ItemManager.current

    //load corresponding detail on item selection
    onItemChanged: {
        if(item.id) push(Qt.resolvedUrl("detail/Detail.qml"))
    }

    //disable previous item and enable current
    onCurrentItemChanged: {
        if(previousItem) {
            previousItem.enabled = false;
        }
        if(currentItem) {
            currentItem.enabled = true;
        }
        previousItem = currentItem
    }

    //initialization
    Component.onCompleted: {
        User.init()
    }

    //navigation controls
    PageNavigationBar {
        id: bar
        hideBar: currentItem && currentItem.objectName === "detail"
        onIndexChanged: if(bar.index >= 0) navigator.navigate(pages[bar.index])
    }

    /*! /qmlmethod
        If page is on stack, pop all items down to this page. If the page is not on
        the stack, push it to the stack.
    */
    function navigate(page) {
        if(onStack(page)){
            pop(page)
        }
        else{
           push(page)
        }
    }

    /*! /qmlmethod
        Returns true if page is on stack, returns false otherwise
    */
    function onStack(page) {
        for(var i=0; i<depth; i++) {
            if(get(i, true) === page) return true
        }
        return false
    }
}
