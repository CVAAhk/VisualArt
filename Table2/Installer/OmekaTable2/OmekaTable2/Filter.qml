import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."
import "settings.js" as Settings
Item
{
    id: root
    property string color: "#2b89d9"//blue
    property string whichScreen: "lower left"//default
    property alias tagHeaderSearchByTag: tag_header.searchByTag

    signal interactive();
    Rectangle
    {
        id: filter_header_bkg
        anchors.fill: filter_header
        color: root.color
        visible: false
        OmekaText
        {
            id: filter_text

            _font: Style.filterFont
            text: "FILTER"
            anchors.centerIn: parent
        }

    }
    Image
    {
        id: filter_header
        source: "content/POI/filter-header.png"
        visible: false

    }
    OpacityMask
    {
        anchors.fill: filter_header_bkg
        source: filter_header_bkg
        maskSource: filter_header
    }
    Image
    {
        id: filter_bkg
        source: "content/POI/filter-bkg.png"
        anchors.top: filter_header.bottom
    }
    TagHeader
    {
        id: tag_header
        y:30
        color: root.color
        whichScreen: root.whichScreen
        onScreenTagChanged:  interactive();
    }

    TagSearch
    {
        id: tags_view
        y: 60
        width: filter_bkg.width
        height: 190
        listScreenTag: tag_header.screenTag
        whichScreen: root.whichScreen

//        onLetterSelected:
//        {
//            //alpha.selectLetterChar(letter);
//            interactive();
//        }
        onFilterScrolled:
        {
            interactive();
        }
    }

    Rectangle
    {
        id: filter_footer_bkg
        anchors.fill: filter_footer
        color: root.color
        visible: false
    }
    Image
    {
        id: filter_footer
        source: "content/POI/filter-footer.png"
        anchors.top: filter_bkg.bottom
        visible: false
    }
    OpacityMask
    {
        anchors.fill: filter_footer_bkg
        source: filter_footer_bkg
        maskSource: filter_footer
    }

//    FilterAlpha
//    {
//        id: alpha

//        onLetterSelected:
//        {
//            tags_view.selectNewLetter(letter);
//            interactive();
//        }
//    }


    function resetFilters()
    {
        tag_header.setTagEmpty();
        tags_view.resetFilters();
        //alpha.selectLetter(-1, false);
    }

}
