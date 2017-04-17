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
        }
        else {
            ItemManager.unregisterLike(itemData, bypassRemoval)
        }
    }

    /*! \qmlmethod
      update like state
    */
    function refresh(item) {
        like.checked = ItemManager.isLiked(item)
    }
}
