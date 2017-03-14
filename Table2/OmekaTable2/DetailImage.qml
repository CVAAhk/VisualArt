import QtQuick 2.0

Item
{
    property alias source: img.source
    Image
    {
        id: img

    }
    Image
    {
        id: close
        source: "content/POI/Asset 1.png"
        anchors.bottom: img.top
        anchors.right: img.right
    }
}
