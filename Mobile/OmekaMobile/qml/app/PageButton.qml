import QtQuick 2.5
import QtQuick.Controls 1.4
import "styles"

/*!
  \qmltype PageButton

  PageButton is a button within the \l main PageNavigation control intended to prompt
  the corresponding page
*/
Button {
    width: parent.width / 3
    height: parent.height

    /*!
      \qmlproperty url PageButton::checkedIcon
      The source path of the icon displayed when the button is checked
    */
    property url checkedIcon

    /*!
      \qmlproperty url PageButton::uncheckedIcon
      The source path of the icon displayed when the button is unchecked
    */
    property url uncheckedIcon

    /*!
      \qmlproperty int PageButton::index
      Chid index of the page
    */
    property int index

    //update state
    onClicked: {
        bar.index = index
        bar.state = state
    }

    style: PageButtonStyle {}
}
