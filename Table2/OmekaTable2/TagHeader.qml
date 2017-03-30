import QtQuick 2.0
import "."

/*!
  \qmltype SearchHeader

  SearchHeader is the scroll view header text of the tag search items
*/
OmekaText {
    width: parent.width
    height: 150
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: "tags"
    _font: Style.headerFont
}
