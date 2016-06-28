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

            OmekaText {
                anchors.centerIn: parent
                text: "settings"
                _font: Style.titleFont
            }

            OmekaButton {
                id: back
                icon: Style.back
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

                    Setting {
                        text: "Layout"
                        content: Rectangle {
                            color: "red"
                            height: 200
                        }
                    }
                    Setting {
                        text: "Clear All Likes"
                        content: Rectangle {
                            color: "blue"
                            height: 200
                        }
                    }
                    Setting {
                        text: "About The Collections"
                        content: Rectangle {
                            color: "green"
                            height: 200
                        }
                    }
                    Setting {
                        text: "About Omeka and Open Exhibits"
                        content: Rectangle {
                            color: "black"
                            height: 200
                        }
                    }
                }
            }

    }
}
