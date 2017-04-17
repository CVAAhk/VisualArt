import QtQuick 2.5
import "../../base"
import "../../../utils"

/*!
  \qmltype AboutSetting

  AboutSetting is a user setting containing miscellaneous information
*/
Setting {
    id: setting

    /*! \internal
      Padding around text
    */
    property real margins: Resolution.applyScale(60)

    /*! \qml property string AboutSetting::text
      Textual content
    */
    property alias text: about.text

    //content background
    content: Rectangle {
        color: "white"
        height: about.height + setting.margins * 2

        //text display
        OmekaText {
            id: about

            //anchoring
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: setting.margins

            _font: Style.metadataFont
        }
    }

}
