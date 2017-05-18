import QtQuick 2.5
import "../../base"
import "../../../utils"

OmekaToggle{
    id: like
    visible: img.progress === 1
    defaultSource: Style.likeIndicator
    checkedSource: Style.likeFill
    iconScale: Resolution.applyScale(.55)

    property bool bypassRemoval: false

    //add or remove data entry based on checked state
    onClicked: {
        if(checked){            
            ItemManager.registerLike(itemData)
            Foreground.showMessage("Item added to likes", 2000, Resolution.applyScale(300))
        }
        else {
            ItemManager.unregisterLike(itemData, bypassRemoval)
            Foreground.showMessage("Item removed from likes", 2000, Resolution.applyScale(300))
        }
    }

    /*! \qmlmethod
      update like state
    */
    function refresh(item) {
        like.checked = ItemManager.isLiked(item)
    }
}
