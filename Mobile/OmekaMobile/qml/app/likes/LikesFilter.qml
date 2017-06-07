import QtQuick 2.5
import "../clients"
import "../../utils"

Item {
    id: root

    visible: false
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: Resolution.applyScale(30)
    height: border.height
    clip: true

    property var omekaIDS: []
    property var omekaTitles: []
    property var filterID

    Connections {
        target: Omeka
        onSiteInfo: {
            //add site title as filter
            if(result.context === root) {
                var index = omekaIDS.indexOf(result.omekaID)
                if(index !== -1) {
                    omekaTitles.splice(index, 0, result.title)
                    filters.addFilter(result.title)
                }
                updateVisibility()
            }
        }
    }

    //border rectangle
    Rectangle {
        id: border
        width: parent.width
        height: button.height + filters.verticalOffset
        color: Style.transparent
        border.width: Resolution.applyScale(6)
        border.color: Style.color1
        z: 1
    }   

    //main container
    Column {
        width: parent.width
        height: childrenRect.height

        //button control
        FilterButton {
            id: button
            text: "filter by collection"
            width: parent.width
            height: Resolution.applyScale(150)
        }

        //filter list
        Filters {
            id: filters
            width: parent.width
            state: button.state
            onCurrentChanged: {
                filterID = current.text === "all" ? "all" : omekaIDS[omekaTitles.indexOf(current.text)]
            }
        }
    }

    //close filters
    function close() {
        button.checked = false
        filters.reset()
    }

    /*
      Register new omeka id and retreive site title and assign as filter value
     */
    function addFilter(omekaID, endpoint) {
        if(omekaIDS.indexOf(omekaID) === -1) {
            omekaIDS.push(omekaID)
            Omeka.getSiteInfo(root, endpoint+"api/")
        }
    }

    /*
      Remove filter by id
     */
    function removeFilter(omekaID) {
        var index = omekaIDS.indexOf(omekaID)
        if(index !== -1) {
            filters.removeFilter(index)
            omekaIDS.splice(index, 1)
            omekaTitles.splice(index, 1)            
        }
        updateVisibility()
    }

    /*
      Clar all filters
    */
    function clear() {
        omekaIDS.length = 0
        omekaTitles.length = 0
        filters.clear()
        updateVisibility()
    }

    /*
      Only display filters when there is more than one to switch between
    */
    function updateVisibility() {
        root.visible = omekaTitles.length > 1
    }
}
