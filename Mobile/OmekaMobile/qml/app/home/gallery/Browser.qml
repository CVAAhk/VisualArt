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
        maximumFlickVelocity: Resolution.applyScale(8000)
        flickDeceleration: Resolution.applyScale(4500)
        cellWidth: width/Math.floor(width/(Math.floor(Resolution.applyScale(478))))
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
