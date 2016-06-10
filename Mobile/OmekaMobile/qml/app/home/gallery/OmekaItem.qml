import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

/*! Omeka media item preview */
Component {
    Item{
        width: grid.cellWidth; height: grid.cellHeight

        Image{
            id: img
            anchors.fill: parent
            anchors.centerIn: parent           
            asynchronous: true
            source: image
            fillMode: Image.PreserveAspectCrop
        }
    }
}
