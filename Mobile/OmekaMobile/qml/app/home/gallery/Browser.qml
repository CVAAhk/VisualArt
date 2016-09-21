import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../../utils"
import "../../base"

/*! Item browser component */
Item {
    id: view
    width: parent.width
    height: parent.height
    state: User.layoutID
    z: -1

    property Flickable layout

    property var model: ListModel{}

    property var delegate: OmekaItem{}

    property real divisor: 478

    property real rowHeight: width/Math.floor(width/(Math.floor(Resolution.applyScale(divisor))))

    property real spacing: Resolution.applyScale(30)

    property real cacheBuffer: rowHeight > 0 ? rowHeight * 200 : 0

    property real headerHeight: 0

    property color headerColor: "white"

    property bool busy: false

    Component {
        id: header
        Item {
            width: view.width
            height: view.headerHeight
            Rectangle {
                color: view.headerColor
                width: parent.width
                height: parent.height - view.spacing
            }
        }
    }

    Component {
        id: footer
        Item{
            width: view.width
            height: Resolution.applyScale(150)
            OmekaIndicator {
                id: indicator
                anchors.centerIn: parent
                running: parent.y === 0 || view.busy
                scale: Resolution.applyScale(1.5)
            }
        }
    }

    /*! Grid layout */
    GridView {
        id: grid
        visible: layout === grid
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        cellWidth: cellHeight
        cellHeight: view.rowHeight
        cacheBuffer: view.cacheBuffer
        delegate: view.delegate
        maximumFlickVelocity: 8000
        flickDeceleration: 3000
        boundsBehavior: Flickable.StopAtBounds
        bottomMargin: Resolution.applyScale(195)
        header: header
        footer: footer
    }

    /*! List layout */
    ListView {
        id: list
        visible: layout === list
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: view.spacing
        cacheBuffer: view.cacheBuffer
        delegate: view.delegate
        maximumFlickVelocity: 8000
        flickDeceleration: 3000
        boundsBehavior: Flickable.StopAtBounds
        bottomMargin: Resolution.applyScale(190)
        header: header
        footer: footer
    }

    /*! Add item from browser */
    function append(item) {
        layout.model.append(item);
    }

    /*! Insert item from browser */
    function insert(index, item) {
        layout.model.insert(index, item)
    }

    /*! Clear browser */
    function clear() {
        layout.model.clear();
    }

    states: [
        State{
            name: "grid"
            PropertyChanges { target:view; explicit: true; layout: grid }
            PropertyChanges { target: grid; explicit: true; model: view.model; z: 1 }
        },
        State{
            name: "list"
            PropertyChanges { target: view; explicit: true; layout: list; divisor: 290 }
            PropertyChanges { target: list; explicit: true; model: view.model; z: 1 }
        }
    ]
}
