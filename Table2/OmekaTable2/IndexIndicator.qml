import QtQuick 2.5
import QtQuick.Controls 1.4

import "."

Item
{
    id: root

    Row
    {
        anchors.centerIn: parent
        spacing: -30
        anchors.verticalCenterOffset: 2
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
}
