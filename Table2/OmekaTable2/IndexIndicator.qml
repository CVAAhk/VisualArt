import QtQuick 2.5
import QtQuick.Controls 1.4

import "."

Item
{
    id: root

    signal leftPressed();
    signal rightPressed();

    Row
    {
        anchors.centerIn: parent
        ExclusiveGroup { id: indices }
        Repeater
        {
            model: list.model.count
            RadioButton
            {
                enabled: false
                exclusiveGroup: indices
                checked: index === list.currentIndex
                style: IndexStyle{}
            }
        }
    }

    Image
    {
        id: leftButton
        source: 'content/POI/Asset 10.png'
        y: 5
        width: 32; height: 32

        MultiPointTouchArea
        {
            anchors.fill: parent

            onReleased: { root.leftPressed(); }
        }
    }

    Image
    {
        id: rightButton
        source: 'content/POI/Asset 9.png'
        y: 5
        width: 32; height: 32
        anchors.right: parent.right

        MultiPointTouchArea
        {
            anchors.fill: parent

            onReleased: { root.rightPressed(); }
        }
    }
}
