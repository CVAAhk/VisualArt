import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."
import "settings.js" as Settings

/*!
  \qmltype SearchHeader

  SearchHeader is the scroll view header text of the tag search items
*/
Item
{
    id: root
    property string color: "blue"
    property string whichScreen: "lower left"//default\
    property var screenTag: whichTag()

    x: 6

    function whichTag()
    {
        if(root.whichScreen === "lower left") return ItemManager.tagSearchLowerLeft;
        if(root.whichScreen === "lower right") return ItemManager.tagSearchLowerRight;
        if(root.whichScreen === "top left") return ItemManager.tagSearchTopLeft;
        if(root.whichScreen === "top right") return ItemManager.tagSearchTopRight;
    }
    function setTagEmpty()
    {
        if(root.whichScreen === "lower left") ItemManager.tagSearchLowerLeft = "";
        if(root.whichScreen === "lower right") ItemManager.tagSearchLowerRight = "";
        if(root.whichScreen === "top left") ItemManager.tagSearchTopLeft = "";
        if(root.whichScreen === "top right") ItemManager.tagSearchTopRight = "";
    }

    Item
    {
        id: has_filter
        visible: screenTag !== ""
        Rectangle
        {
            id: filter_bkg_mask
            anchors.fill: filter_bkg
            color: root.color
            visible: false


        }
        OmekaText {
            anchors.centerIn: filter_bkg_mask
            text: screenTag//ItemManager.tagSearch
            _font: Style.tagFont
        }
        Image
        {
            id: filter_bkg
            source: "content/POI/filter-selected.png"
            visible: false
        }
        OpacityMask
        {
            anchors.fill: filter_bkg_mask
            source: filter_bkg_mask
            maskSource: filter_bkg
            MultiPointTouchArea
            {
                anchors.fill: parent
                onPressed:
                {
                    setTagEmpty()
                }
                Rectangle
                {
                    anchors.fill: parent
                    color: "blue"
                    opacity: 0.5
                    visible: parent.enabled && Settings.DEBUG_VIEW
                }
            }
        }
    }
    Image
    {
        id: no_filter
        source: "content/POI/no-filter.png"
        visible: screenTag === ""
    }





}
