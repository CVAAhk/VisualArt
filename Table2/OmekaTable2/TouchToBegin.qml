import QtQuick 2.0

Item
{
    id: root
    property string color: "blue"

    signal bluePressed(var active)
    signal redPressed(var active)
    signal greenPressed(var active)
    signal yellowPressed(var active)

    Image
    {
        visible: color === "blue"
        source: "content/POI/touch-to-begin.png"
        MultiPointTouchArea
        {
            anchors.fill: parent
            property bool active: false
            onPressed: {active = !active; root.opacity = active ? 0.0 : 1.0;root.bluePressed(active)}
        }
    }

    Image
    {
        visible: color === "red"
        source: "content/POI/touch-to-begin-red.png"
        MultiPointTouchArea
        {
            anchors.fill: parent
            property bool active: false
            onPressed: {active = !active; root.opacity = active ? 0.0 : 1.0;root.redPressed(active)}
        }
    }
    Image
    {
        visible: color === "green"
        source: "content/POI/touch-to-begin-green.png"
        MultiPointTouchArea
        {
            anchors.fill: parent
            property bool active: false
            onPressed: {active = !active; root.opacity = active ? 0.0 : 1.0;root.greenPressed(active)}
        }
    }
    Image
    {
        visible: color === "yellow"
        source: "content/POI/touch-to-begin-yellow.png"
        MultiPointTouchArea
        {
            anchors.fill: parent
            property bool active: false
            onPressed: {active = !active; root.opacity = active ? 0.0 : 1.0;root.yellowPressed(active)}
        }
    }
}
