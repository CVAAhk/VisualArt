import QtQuick 2.5
import "../../utils"
import "../home/gallery"

Item {
    id: results

    property string tag: ItemManager.tagSearch
    property string keyword: ItemManager.searchTerm

   // onKeywordChanged: { }     unsupported by rest api

    onTagChanged: if(tag) { Omeka.getItemsByTag(tag, results) }

    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.context === results) {
                browser.append(result)
            }
        }
    }

    Browser { id: browser }
}
