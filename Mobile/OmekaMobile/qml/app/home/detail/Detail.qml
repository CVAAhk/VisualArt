import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "../../../utils"

/*! \qmltype Displays detailed view of media items and corresponding metadata */
Item {
    id: detail
    width: parent.width
    height: parent.height

    /*! scroll container */
    ScrollView {
        anchors.fill: parent
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

        //content
        DetailContent { }
    }
}
