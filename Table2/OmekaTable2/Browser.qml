import QtQuick 2.5
import QtQuick.Controls 1.4


/*! Item browser component */
Item {
    id: view
    width: parent.width
    height: parent.height
    //state: User.layoutID
    z: -1

    //property Flickable layout: path

    property var model: ListModel{}

    property var delegate: ImageViewer{}

    property real divisor: 478

    property real rowHeight: 300//width/Math.floor(width/(Math.floor(Resolution.applyScale(divisor))))

    property real spacing: -200//Resolution.applyScale(30)

    property real cacheBuffer: rowHeight > 0 ? rowHeight * 200 : 0

    property real headerHeight: 0

    property color headerColor: "white"

    property bool busy: false

//    Component {
//        id: header
//        Item {
//            width: view.width
//            height: view.headerHeight
//            Rectangle {
//                color: view.headerColor
//                width: parent.width
//                height: parent.height - view.spacing
//            }
//        }
//    }

//    Component {
//        id: footer
//        Item{
//            width: view.width
//            height: Resolution.applyScale(150)
//            OmekaIndicator {
//                id: indicator
//                anchors.centerIn: parent
//                running: view.busy
//                scale: Resolution.applyScale(1.5)
//            }
//        }
//    }

    /*! Grid layout */
//    GridView {
//        id: grid
//        model: view.model
//        visible: layout === grid
//        anchors.fill: parent
//        anchors.horizontalCenter: parent.horizontalCenter
//        cellWidth: cellHeight
//        cellHeight: view.rowHeight
//        cacheBuffer: view.cacheBuffer
//        delegate: view.delegate
//        maximumFlickVelocity: 8000
//        flickDeceleration: 3000
//        boundsBehavior: Flickable.StopAtBounds
//        bottomMargin: 195
//        //header: header
//        //footer: footer
//    }

//    /*! List layout */
//    ListView {
//        id: list
//        model: view.model
//        visible: layout === list
//        anchors.fill: parent
//        anchors.horizontalCenter: parent.horizontalCenter
//        orientation: ListView.Horizontal
//        spacing: view.spacing
//        cacheBuffer: view.cacheBuffer
//        delegate: view.delegate
//        maximumFlickVelocity: 8000
//        flickDeceleration: 3000
//        boundsBehavior: Flickable.StopAtBounds
//        bottomMargin: 190//Resolution.applyScale(190)
//        highlight: highlightBar
//        highlightFollowsCurrentItem: false
//        focus: true
//        highlightRangeMode: ListView.StrictlyEnforceRange
////        preferredHighlightBegin: 500
////        preferredHighlightEnd: 1000

////        header: header
////        footer: footer
//        onCurrentItemChanged:
//        {
//            console.log("current index = ", currentIndex)
//        }
//    }

//    Component {
//            id: highlightBar
//            Rectangle {
//                width: 200; height: 50
//                color: "#FFFF88"
//                x: list.currentItem.x;
//                Behavior on x { SpringAnimation { spring: 2; damping: 0.1 } }
//            }
//        }

    PathView
    {
        id: path
        model: view.model
        //visible: layout === path
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        delegate: view.delegate
        maximumFlickVelocity: 800
        path: Path {
                    startX: view.width /2 ; startY: view.height /2
                    PathQuad { x: view.width /2; y: view.height /2; controlX: view.width; controlY: view.height /2 }
                    PathQuad { x: view.width /2; y: view.height /2; controlX: 0; controlY: view.height /2 }
                }
        onCurrentItemChanged:
        {
            console.log("current index = ", currentIndex)
        }
    }

    /*! Add item from browser */
    function append(item) {
        path.model.append(item);
    }

    /*! Insert item from browser */
    function insert(index, item) {
        layout.model.insert(index, item)
    }

    /*! Clear browser */
    function clear() {
        layout.model.clear();
    }


}
