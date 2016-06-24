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

    /*! scroll container */
    OmekaScrollView {
        anchors.fill: parent
        //content
        DetailContent { }
    }
}
