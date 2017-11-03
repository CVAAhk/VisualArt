import QtQuick 2.5
import QtQuick.Controls 1.4
import "../base"
import "../styles"
import "../clients"

Item {
    id: tags
    width: parent.width
    height: parent.height

    property var tagData: ({})
    property int tagCount: 0
    property url endpoint: Omeka.endpoint

    //refresh tags
    onEndpointChanged: {
        connection.target = Omeka
        list.model.clear()
        tagData = ({})
        tagCount = 0
        Omeka.getTags(tags)
    }

    //update list on completion of tag query
    Connections {
        id: connection
        ignoreUnknownSignals: true
        onRequestComplete: loadTags(result)
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
            spacing: 2
            onHeightChanged: contentY = -headerItem.height
        }
    }

    function loadTags(result) {
        if(result.context === tags) {
            tagCount++
            tagData[result.tag] = result
            Omeka.getTaggedItemCount(result.tag, result.tag)
        }
        else if(tagData.hasOwnProperty(result.context)) {
            var tagItem = tagData[result.context];
            tagItem.count = result.count;
            list.model.append(tagItem)
            delete tagData[result.context]
            tagCount--

            if(tagCount === 0) {
                connection.target = null
            }
        }
    }
}
