import QtQuick 2.0
import QtQuick.Controls 1.4
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
    property variant pages: [home, search, likes]

    //navigation controls
    PageNavigationBar {
        id: bar
        onStateChanged: navigator.navigate(pages[bar.index])
    }

    /*! /qmlmethod
        If page is on stack, pop all items down to this page. If the page is not on
        the stack, push it to the stack.
    */
    function navigate(page) {
        if(navigator.onStack(page)){
            navigator.pop(page)
        }
        else{
            navigator.push(page)
        }
    }

    /*! /qmlmethod
        Returns true if page is on stack, returns false otherwise
    */
    function onStack(page) {
        for(var i=0; i<3; i++) {
            if(navigator.get(i, true) === page) return true
        }
        return false
    }
}
