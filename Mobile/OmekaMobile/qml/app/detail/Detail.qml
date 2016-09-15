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

    //primary display item
    property DetailColumn column        

    /*! scroll container */
    OmekaScrollView {
        id: scroll
        anchors.fill: parent
        DetailContent { }
    }

    /*! scroll container */
    LoadScreen{
        progress: column && column.viewer ? column.viewer.progress : 0
    }

    //load item on transition complete
    onXChanged: {
        if(x === 0 && column) {
            column.loadItem()
        }
    }
}
