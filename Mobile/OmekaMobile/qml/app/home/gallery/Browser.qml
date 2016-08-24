import QtQuick 2.0
import QtQuick.Controls 1.4
import "../../../utils"
import "../../base"

/*! Item browser component */
OmekaScrollView {
    width: parent.width
    height: parent.height

    property alias layout: layout

    /*! Grid layout */
    GridView {
        id: layout
        property real spacing: Resolution.applyScale(30)

        anchors.horizontalCenter: parent.horizontalCenter
        cellWidth: width/Math.floor(width/(Math.floor(Resolution.applyScale(478))))
        cellHeight: cellWidth
        cacheBuffer: cellHeight * 200
        model: ListModel{}
        delegate: OmekaItem{}
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
