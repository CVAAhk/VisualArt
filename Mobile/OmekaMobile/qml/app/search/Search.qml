import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../utils"
import "../styles"
import "../base"

/*!
  \qmltype Search

  Search provides item filtering by generic keyword or item tags
*/
Item {

    //refresh tags
    Component.onCompleted: refresh()

    //update list on completion of tag query
    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.type === Omeka.tag) {
                list.model.append(result)
            }
        }
    }

    //background
    Rectangle {
        width: parent.width
        height: list.height
        color: Style.viewBackgroundColor
    }

    //foreground
    Column {
        anchors.fill: parent;
        spacing: 0

        //toolbar
        OmekaToolBar {
            id: bar

            //search field
            TextField {
                id: textField
                anchors.fill: parent
                anchors.margins: Resolution.applyScale(15)
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                font.bold: true
                font.pixelSize: Resolution.applyScale(80)
                style: SearchBarStyle {}
            }
        }

        //tag scroll view
        OmekaScrollView {
            id: scroll
            width: parent.width
            height: parent.height - bar.height * 2

            //tag list
            ListView {
                id: list
                anchors.fill: parent
                model: ListModel {}
                delegate: SearchDelegate {}
                header: SearchHeader {}
                onHeightChanged: contentY = -headerItem.height
            }
        }
    }

    /*! \internal
      Restore search text and query repository for tags
    */
    function refresh() {
        textField.placeholderText = "SEARCH"
        Omeka.getTags()
    }
}
