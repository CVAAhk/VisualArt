import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."
Item
{
    id: root
    property string color: "#2b89d9"//blue
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

}
