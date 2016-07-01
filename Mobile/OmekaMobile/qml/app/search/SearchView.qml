import QtQuick 2.5
import QtQuick.Controls 1.4
import "../base"
import "../styles"
import "../../utils"

Rectangle {
    id: search
    width: parent.width
    height: parent.height
    color: Style.viewBackgroundColor

    //refresh tags
    Component.onCompleted: refresh()

    //update list on completion of tag query
    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.context === search) {
                list.model.append(result)
            }
        }
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
        Omeka.getTags(search)
    }
}
