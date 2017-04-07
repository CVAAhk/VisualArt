import QtQuick 2.5
import QtQuick.Controls 1.4

import "."

Item
{
    id: root

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
}
