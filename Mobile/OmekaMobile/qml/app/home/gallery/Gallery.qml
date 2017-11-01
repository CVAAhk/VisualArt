import QtQuick 2.0
import QtQuick.Controls 1.4
import "../settings"
import "../../../utils"
import "../../clients"
import "../../base"

/*!Media viewer*/
Item {
    id: gallery

    property Settings settings: Settings {}
    property url endpoint: Omeka.endpoint

    /*!Load first page of omeka instance*/
    onEndpointChanged: {
        browser.clear()
        browser.nextCount = 1
        Omeka.getPage(1, gallery)
    }

    /*!Dynamically load omeka query results into browser*/
    Connections {
        target: Omeka
        onRequestComplete:{
            if(result.context === gallery){
                browser.append(result)
            }
        }
    }

    /*!Display logo and settings entry*/
    BrandBar {
        id: bar
        onActivated: if(homeStack) {
                         settings.enabled = true;
                         homeStack.push(settings);
                     }
    }

    /*!Scroll through items*/
    ItemBrowser {
        id: browser
        anchors.top: bar.bottom
        height: parent.height - bar.height
        headerHeight: height/4
        busy: Omeka.apiIsEnabled
        onCanPaginate: {
           Omeka.getNextPage(gallery)
        }
    }

    /*!API disabled notification*/
    OmekaText {
        id: api_disabled
        visible: !Omeka.apiIsEnabled
        anchors.centerIn: parent
        width: parent.width * 0.8
        text: User.restAPIDisabled
        _font: Style.apiInstructionFont
        onLinkActivated: Qt.openUrlExternally(link)
    }

    /*!Omeka Logo*/
    Logo {
        contentY: browser.contentY
        minY: 0
        maxY: browser.headerHeight *.9
        minWidth: parent.width
        maxWidth: Resolution.applyScale(450)
        minHeight: maxY
        maxHeight: bar.height
        source: Style.omekaLogo
    }

    //Connect with C++ class
//    QuickMaker
//    {
//        id: quick_maker
//        objectName: "quick_maker"
//        onOrientationChanged:
//        {
//            overlay.opacity = 0.8;
//            overlay_timer.restart()
//        }
//    }
    Rectangle
    {
        id: overlay
        anchors.fill: parent
        opacity: 0.0
        color: "white"
        Behavior on opacity {

            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }
    Timer
    {
        id: overlay_timer
        interval: 500
        onTriggered: overlay.opacity = 0.0;
    }

}
