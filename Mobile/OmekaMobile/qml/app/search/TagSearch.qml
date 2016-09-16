import QtQuick 2.5
import QtQuick.Controls 1.4
import "../base"
import "../styles"
import "../../utils"

Item {
    id: tags
    width: parent.width
    height: parent.height
    property var tagData: ({})

    //refresh tags
    Component.onCompleted: Omeka.getTags(tags)

    //update list on completion of tag query
    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.context === tags) {
                tagData[result.tag] = result
                Omeka.getTaggedItemCount(result.tag, result.tag)
            }
            else if(tagData.hasOwnProperty(result.context)) {
                var tagItem = tagData[result.context];
                tagItem.count = result.count;
                list.model.append(tagItem)
                delete tagData[result.context]
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
