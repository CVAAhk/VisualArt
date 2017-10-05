import QtQuick 2.5
import "../../base"
import "../../../utils"
import "../../clients"
import "../settings"

/*!
  \qmltype EndpointsSetting


  EndpointsSetting navigates to edit the endpoints and switch between the endpoints.
  If heist is not supported, an instructional drop down will be displayed describing the plugin
  and how add support to the omeka instance.
*/
Setting {
    id: setting
    enableArrow: !hasHeist

    /*! \internal
      Determines if there is heist support for this omeka instance
    */
    property bool hasHeist: Heist.heistIsSupported

    /*! \internal
      Padding around text
    */
    property real margins: Resolution.applyScale(60)

    /*! \qml property string PairSettings::text
      Textual content instructing user how to install heist
    */
    property alias text: instructions.text

    /*! \qml property string Setting::activate
      Invoked on device pairing activation if heist is supported
    */
    signal activate();

    //only show content when heist is not supported
    content: Rectangle {
        color: "white"
        height: hasHeist ? -2 : instructions.height + setting.margins * 2

        //text display
        OmekaText {
            id: instructions

            //anchoring
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: setting.margins

            _font: Style.metadataFont
        }
    }

    //only activate when heist is supported
    onStateChanged: {
        if(hasHeist && state === "expand") {
            activate()
        }
    }

}
