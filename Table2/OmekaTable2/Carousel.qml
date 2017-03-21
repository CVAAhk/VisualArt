import QtQuick 2.0

Item
{
    id: root

    property bool topScreen: false
    signal createImage(string source, int imageX, int imageY, int imageRotation, int imageWidth, int imageHeight, string title);
    Image {
        id: bkg
        source: "content/POI/Asset 11.png"
    }
    Browser {
        id: browser
        //anchors.top: bar.bottom
        x: -root.x;y: 0
        height: 540 /2
        width: 960
        headerHeight: height/3
        topScreen: root.topScreen
        onCreateImage:
        {
            root.createImage(source, imageX, imageY, imageRotation, imageWidth, imageHeight, title)
        }
    }

    function appendItems(result)
    {
        browser.append(result);
    }
    function imageRemovedFromScene(filepath)
    {
        browser.imageRemovedFromScene(filepath);
    }
}
