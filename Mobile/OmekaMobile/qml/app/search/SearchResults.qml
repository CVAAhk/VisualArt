import QtQuick 2.5
import "../../utils"
import "../home/gallery"

Item {
    id: results

    property string tag: ItemManager.tagSearch
    property string keyword: ItemManager.searchTerm

    //submit keyword search
    onKeywordChanged: {
        if(keyword) {
            browser.clear()
            Omeka.getItemsByTerm(keyword, results)
        }
    }

    //submit tag search
    onTagChanged: if(tag) { Omeka.getItemsByTag(tag, results) }

    //populate browser with results
    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.context === results) {
                browser.append(result)
            }
        }
    }

    //result browser
    Browser { id: browser }
}
