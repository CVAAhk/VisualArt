import QtQuick 2.0
import QtQuick.Controls 1.4
import "."

/*!
  \qmltype SearchDelegate

  SearchDelegate is search item representing a collection tag. When selected the repository
  is queried for all items with this tag and the browser is populated with the results.
*/
Image {
    id: context

    source: "content/POI/tag-bkg.png"

    anchors.horizontalCenter: parent.horizontalCenter
    opacity: list.screenTag === tag ? 0.5 : 1.0

    //anchors.margins: 12 //TODO: A-Z area

    function whichTag()
    {
        if(list.whichScreen === "lower left") return ItemManager.tagSearchLowerLeft;
        if(list.whichScreen === "lower right") return ItemManager.tagSearchLowerRight;
        if(list.whichScreen === "top left") return ItemManager.tagSearchTopLeft;
        if(list.whichScreen === "top right") return ItemManager.tagSearchTopRight;
    }
    //text display
    OmekaText {
        text: tag
        anchors.centerIn: parent
        _font: Style.tagFont
    }

    //tag search
    MouseArea{
        anchors.fill: parent
        onClicked:
        {
            //console.log("tag = ", tag)
            if(list.whichScreen === "lower left") ItemManager.tagSearchLowerLeft = tag;
            if(list.whichScreen === "lower right") ItemManager.tagSearchLowerRight = tag;
            if(list.whichScreen === "top left") ItemManager.tagSearchTopLeft = tag;
            if(list.whichScreen === "top right") ItemManager.tagSearchTopRight = tag;
        }
    }
}

