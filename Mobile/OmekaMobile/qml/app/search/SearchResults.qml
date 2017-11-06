import QtQuick 2.5
import "../../utils"
import "../clients"
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
        onEmptyResult: {
            if(result.context === results) {
                Foreground.showMessage("NO RESULTS", 3000, Resolution.applyScale(300))
            }
        }
    }

    //result browser
    Browser {
        id: browser
        headerHeight: Resolution.applyScale(192)
        headerColor: Style.transparent
    }
}
