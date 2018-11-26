import QtQuick 2.0

Item
{
    id: root
    property string color: "blue"

    signal bluePressed(var active)
    signal redPressed(var active)
    signal greenPressed(var active)
    signal yellowPressed(var active)

    signal touchToBeginPressed(var active)

    Image
    {
        visible: color === "blue"
        source: "content/POI/touch-to-begin.png"
        width: 280; height: 100
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: {root.visible = false;root.touchToBeginPressed(true)}
        }
    }

    Image
    {
        visible: color === "red"
        source: "content/POI/touch-to-begin.png"
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: {root.visible = false;root.touchToBeginPressed(true)}
        }
    }
    Image
    {
        visible: color === "green"
        source: "content/POI/touch-to-begin.png"
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: {root.visible = false;root.touchToBeginPressed(true)}
        }
    }
    Image
    {
        visible: color === "yellow"
        source: "content/POI/touch-to-begin.png"
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: {root.visible = false;root.touchToBeginPressed(true)}
        }
    }

    function resetTouchButton()
    {
        root.visible = true
    }
}
