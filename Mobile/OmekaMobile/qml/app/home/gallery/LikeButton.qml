import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../../utils"

Button{
    id: like
    visible: img.progress === 1
    scale: Resolution.scaleRatio
    anchors.right: parent.right
    checkable: true

    //custom style
    style: ButtonStyle {
        background: Image{
            source: Style.likeIndicator
            Image {
                source: Style.likeFill
                visible: like.checked
            }
        }
    }

    //add or remove data entry based on checked state
    onClicked: {
        if(checked){
            ItemManager.registerLike(itemData)
        }
        else{
            ItemManager.unregisterLike(itemData)
        }
    }

    /*! \qmlmethod
      update like state
    */
    function refresh(item) {
        like.checked = ItemManager.isLiked(item)
    }
}
