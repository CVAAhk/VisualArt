import QtQuick 2.0
import "../base"
import "../../utils"

/*!
  \qmltype SearchHeader

  SearchHeader is the scroll view header text of the tag search items
*/
OmekaText {
    width: parent.width
    height: Resolution.applyScale(150)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: "tags"
    _font: Style.headerFont
}
