import QtQuick 2.0
import QtQuick.Controls 1.4
import "../../../utils"

/*! Item browser component */
ScrollView {
    width: parent.width
    height: parent.height - bar.height
    verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    property GridView grid: grid

    /*! Grid layout */
    GridView {
        id: grid
        anchors.horizontalCenter: parent.horizontalCenter
        maximumFlickVelocity: 8000 * Resolution.scaleRatio
        flickDeceleration: 4500 * Resolution.scaleRatio
        cellWidth: width/Math.floor(width/(Math.floor(478 * Resolution.scaleRatio)))
        cellHeight: cellWidth
        cacheBuffer: cellHeight * 10
        model: ListModel{}
        delegate: OmekaItem{}
    }

    /*! Add item from browser */
    function append(item) {
        grid.model.append(item);
    }

    /*! Clear browser */
    function clear() {
        grid.model.clear();
    }
}
