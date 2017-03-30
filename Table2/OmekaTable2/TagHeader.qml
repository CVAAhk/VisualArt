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

    x: 6


    Item
    {
        id: has_filter
        visible: ItemManager.tagSearch != ""
        Rectangle
        {
            id: filter_bkg_mask
            anchors.fill: filter_bkg
            color: root.color
            visible: false


        }
        OmekaText {
            anchors.centerIn: filter_bkg_mask
            text: ItemManager.tagSearch
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
                    ItemManager.tagSearch = "";
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
        visible: ItemManager.tagSearch == ""
    }





}
