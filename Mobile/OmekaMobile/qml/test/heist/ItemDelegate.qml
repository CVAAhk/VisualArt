import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../utils"

Component {

    Button {
        id: object
        width: parent.width
        height: 50
        text: String(item)
        checkable: true

        property var itemData: ({})
        property var code;

        Component.onCompleted:  {
            itemData.id = String(item)
            itemData.fileCount = parseInt(file_count)
            itemData.metadata = metadata
            itemData.media = []
            itemData.mediaTypes = []

            Omeka.getFiles(itemData.id, object)
        }

        Connections {
            target: Omeka
            onRequestComplete: {
               if(result.context === object) {
                   itemData.thumb = result.thumb || Style.thumbs[result.media_type]
                   itemData.media.push(result.media)
                   itemData.mediaTypes.push(result.media_type)
                   target = null
               }
            }
        }

        onCheckedChanged: {
            if(checked && currentCode) {
                code = currentCode
                HeistManager.addItem(code, itemData, object);
            } else if(!checked && code) {
                HeistManager.removeItem(code, itemData, object);
            }
        }

        function reset() {
            code = null
            checked = false
        }
    }

}
