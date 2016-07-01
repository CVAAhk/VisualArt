import QtQuick 2.5
import QtQuick.Controls.Styles 1.4
import "../../utils"

/*!
  \qmltype SearchBarStyle

  SearchBarStyle is a custom appearance for the search text field
*/
TextFieldStyle {
    textColor: Style.titleFont.color
    placeholderTextColor: textColor

    background: Rectangle{
        width: control.width
        height: control.height
        radius: Resolution.applyScale(30)
    }
}
