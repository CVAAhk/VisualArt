import QtQuick 2.5
import QtQuick.Controls 1.4
import "."


Item {
    id: tags


    property var tagData: ({})
    property int tagCount: 0
    property alias listScreenTag: list.screenTag
    property string whichScreen: "lower left"//default

    //refresh tags
    Component.onCompleted: Omeka.getTags(tags)

    //update list on completion of tag query
    Connections {
        target: Omeka
        onRequestComplete: {
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
                    target = null
                }
            }

        }
    }

    //tag scroll view
    OmekaScrollView {
        id: scroll
        //y: field.height
        width: parent.width
        height: parent.height
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

        //tag list
        ListView {
            id: list
            property var screenTag
            property string whichScreen: root.whichScreen
            anchors.fill: parent
            model: ListModel {}
            delegate: TagDelegate {}
            spacing: 6
        }
    }
    function resetFilters()
    {
        list.contentY = 0;
    }
}
