import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../home"
import "../../base"
import "../../clients"
import "../../../utils"
import "pairing"

/*!User settings*/
Item {
    id: root
    enabled: false
    property TablePairing tablePairing: TablePairing {}
    property EndpointsEditing endpointsEditing: EndpointsEditing {}

    Column {
        anchors.fill: parent
        spacing: 0

        /*!Settings header and back button*/
        OmekaToolBar {
            id: bar

            backgroundColor: Style.color3

            OmekaText {
                anchors.centerIn: parent
                text: "settings"
                _font: Style.titleFont
            }

            OmekaButton {
                id: back
                icon: Style.back
                iconScale: .7
                onClicked: if(homeStack) {
                    root.enabled = false
                    homeStack.pop()
                }
            }
        }

        /*!List of settings*/
        OmekaScrollView {
            id: scroll
            width: parent.width
            height: parent.height - bar.height * 2
            Column {
                ExclusiveGroup { id: settingsGroup }
                width: scroll.width
                height: childrenRect.height
                spacing: Resolution.applyScale(150)

                //restore initial state when invisible
                onVisibleChanged: {
                    if(!visible) {
                        settingsGroup.current = null;
                    }
                }

                //settings
                LayoutSetting { title: "Layout" }
                EndpointsSetting
                {
                    title: "Endpoints"
                    onActivate: {
                        if(homeStack) {
                            homeStack.push(endpointsEditing);
                        }
                    }
                    text: User.heistUnsupported
                }

                PairSetting {
                    title: "Pair with Collection Viewer Table"
                    onActivate: {
                        if(homeStack) {
                            homeStack.push(tablePairing);
                        }
                    }
                    text: User.heistUnsupported
                }
                ClearLikesSetting { title: "Clear All Likes" }
                AboutSetting {
                    title: "About The Collections"
                    text: User.aboutCollection || Omeka.description
                }
                AboutSetting {
                    title: "About Omeka Everywhere Mobile"
                    text: User.aboutOOE
                }
            }
        }
    }
}
