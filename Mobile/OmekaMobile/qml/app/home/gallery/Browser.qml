import QtQuick 2.0
import QtQuick.Controls 1.4
import "../../../utils"
import "../../base"

/*! Item browser component */
OmekaScrollView {
    id: view
    width: parent.width
    height: parent.height

    property alias layout: grid

    property var model: ListModel{}

    property var delegate: OmekaItem{}

    property real thumbWidth: width/Math.floor(width/(Math.floor(Resolution.applyScale(478))))

    property real spacing: Resolution.applyScale(30)

    /*! Grid layout */
    GridView {
        id: grid
        property real spacing: view.spacing

        anchors.horizontalCenter: parent.horizontalCenter
        cellWidth: view.thumbWidth
        cellHeight: cellWidth
        cacheBuffer: cellHeight * 200
        model: view.model
        delegate: view.delegate
    }

    /*! Add item from browser */
    function append(item) {
        layout.model.append(item);
    }

    /*! Clear browser */
    function clear() {
        layout.model.clear();
    }
}
