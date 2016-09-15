import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "../../utils"
import "../base"

/*! \qmltype Displays detailed view of media items and corresponding metadata */
Item {
    id: detail
    width: parent.width
    height: parent.height
    objectName: "detail"
    //opacity: 0

    Behavior on opacity { PropertyAnimation{} }

    //primary display item
    property DetailColumn column

    /*! scroll container */
    OmekaScrollView {
        id: scroll
        anchors.fill: parent
        DetailContent { }
    }

    //load item on transition complete
    onXChanged: {
        if(x === 0 && column) {
            column.loadItem()
        }
    }
}
