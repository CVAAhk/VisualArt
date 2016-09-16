import QtQuick 2.0
import QtQuick.Controls 1.4
import "../../../utils"

ListView{
    id: list

    property real sourceWidth: 0
    property real sourceHeight: 0
    property var imageWidth
    property var imageHeight
    property var images: []
    property var urls
    property real progress: 0
    property real tally
    property var total: ({})     

    anchors.centerIn: parent
    orientation: ListView.Horizontal
    snapMode: moving ? ListView.SnapOneItem : ListView.NoSnap
    cacheBuffer: viewer.width*model.count
    interactive: model.count > 1
    clip: true
    spacing: Resolution.applyScale(90)
    highlightRangeMode: ListView.StrictlyEnforceRange

    model: ListModel {}
    delegate: Image {
        anchors.verticalCenter: parent.verticalCenter
        width: list.imageWidth
        height: list.imageHeight
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        source: src

        onWidthChanged: size()
        onHeightChanged: size()
        onStatusChanged: {
            if(status === Image.Ready){
                images.push(this)
                size()
            }
        }

        onProgressChanged: updateProgress(src, progress)
    }

    onUrlsChanged: {
        images = []
        list.model.clear();
        if(!urls) return;
        for(var i=0; i<urls.length; i++) {
            list.model.append({src:urls[i]})
        }
    }

    function size() {
        if(urls.length === images.length) {
            width = height = sourceWidth = sourceHeight = 0
            for(var i=0; i<images.length; i++) {
                sourceWidth = ItemManager.fullScreen ? currentItem.sourceSize.width : Math.max(list.sourceWidth, images[i].sourceSize.width)
                sourceHeight = ItemManager.fullScreen ? currentItem.sourceSize.height : Math.max(list.sourceHeight, images[i].sourceSize.height)
                width = ItemManager.fullScreen ? currentItem.width : Math.max(list.width, images[i].width)
                height = ItemManager.fullScreen ? currentItem.height : Math.max(list.height, images[i].height)
            }
        }
    }

    function updateProgress(src, progress) {
        total[src] = progress
        tally = 0
        for(var p in total) {
            tally += total[p]
        }
        list.progress = tally/list.model.count
    }

    Rectangle{
        id: bkg
        z:-1
        anchors.centerIn: parent
        width: portrait ? parent.width/fillScale : parent.width
        height: portrait ? parent.height : parent.height/fillScale
        color: "black"
    }

    IndexIndicator {
        visible: list.interactive
        anchors.bottom: bkg.bottom
        width: parent.width
        height: bkg.height*.1
    }
}
