import QtQuick 2.5
import QtQuick.Controls 1.4
import "../base"
import "../styles"
import "../../utils"

Item {
    id: tags
    width: parent.width
    height: parent.height

    //refresh tags
    Component.onCompleted: Omeka.getTags(tags)

    //update list on completion of tag query
    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.context === tags) {
                list.model.append(result)
            }
        }
    }

    //tag scroll view
    OmekaScrollView {
        id: scroll
        y: field.height
        width: parent.width
        height: parent.height - field.height * 2

        //tag list
        ListView {
            id: list
            anchors.fill: parent
            model: ListModel {}
            delegate: TagDelegate {}
            header: TagHeader {}
            onHeightChanged: contentY = -headerItem.height
        }
    }
}
