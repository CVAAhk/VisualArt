import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../home"
import "../../base"
import "../../../utils"

/*!User settings*/
Item {

    Column {
        anchors.fill: parent
        spacing: 0

        /*!Settings header and back button*/
        OmekaToolBar {
            id: bar

            backgroundColor: Style.viewBackgroundColor

            OmekaText {
                anchors.centerIn: parent
                text: "settings"
                _font: Style.titleFont
            }

            OmekaButton {
                id: back
                icon: Style.back
                iconScale: .7
                onClicked: if(homeStack) homeStack.pop()
            }
        }

        /*!List of settings*/
            OmekaScrollView {
                width: parent.width
                height: parent.height - bar.height * 2
                Column {
                    Binding on width {when: parent; value: parent.width }
                    height: childrenRect.height
                    spacing: Resolution.applyScale(150)

                    //settings
                    LayoutSetting { title: "Layout" }
                    ClearLikesSetting { title: "Clear All Likes" }
                    AboutSetting {
                        title: "About The Collections"
                        text: User.aboutCollection
                    }
                    AboutSetting {
                        title: "About Omeka and Open Exhibits"
                        text: User.aboutOOE
                    }
                }
            }

    }
}
