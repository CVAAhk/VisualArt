import QtQuick 2.5
import QtQuick.Controls 1.4

ApplicationWindow{
    visible: true
    width: 470; height: 800

    property real yMiddle: height/2
    property real xLeft: -width
    property real xMiddle: width/2
    property real xRight: width*2

    property real loadIndex : 0
    property var urls: ["http://mallhistory.org//files//original//0ef6913467dd1ef22e66e2c0b2cb63ae.jpg",
        "http://mallhistory.org//files//original//2f634c2373adbaf7f36dfb3ddd8dc5f2.jpg",
        "http://mallhistory.org//files//original//49a87bcaedcec9f0ed6557d0c0041280.jpg",
        "http://mallhistory.org//files//original//11863962f4ab9296fb936743d5ce871d.jpg",
        "http://mallhistory.org//files//original//ef24a8d02c172ef727ed3834870bdd73.jpg"]

    ListModel{
        id: model
        ListElement { bkg: "red" }
        ListElement { bkg: "green" }
        ListElement { bkg: "blue" }
    }

    Component{
        id: delegate
        Rectangle{
            id: item
            width: parent.width
            height: parent.height
            color: bkg
            opacity: PathView.rectOpacity
            scale: PathView.rectScale

            Image{
                id: img
                anchors.centerIn: parent
                width: parent.width
                fillMode: Image.PreserveAspectFit
                asynchronous: true
            }

            Connections{
                target: view
                onCurrentIndexChanged:{
                    if(view.loadNext && view.nextIndex === index){
                       img.source = "image://testprovider/"+urls[loadIndex]
                    }
                    else if(!view.loadNext && view.previousIndex === index){
                        img.source = "image://testprovider/"+urls[view.loadIndex]
                    }
                }
            }
        }
    }

    PathView{
        id: view
        anchors.fill: parent

        model: model
        delegate: delegate

        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        highlightRangeMode: PathView.StrictlyEnforceRange
        snapMode: PathView.SnapOneItem;
        flickDeceleration: 2000
        dragMargin: view.height

        property real nextIndex: currentIndex === count -1 ? 0 : currentIndex + 1
        property real previousIndex: currentIndex === 0 ? count-1 : currentIndex - 1
        property bool loadNext

        path:Path{
            startX: xLeft; startY: yMiddle
            PathAttribute { name: "rectOpacity"; value : 0}
            PathAttribute { name: "rectScale"; value : .85}
            PathLine { x: xMiddle; y: yMiddle }
            PathAttribute { name: "rectOpacity"; value : 1}
            PathAttribute { name: "rectScale"; value : 1}
            PathLine { x: xRight; y: yMiddle }
        }

        Component.onCompleted: {
            print(view.model.get(0).img)
        }

        onCurrentIndexChanged: {
            loadNext = currentIndex === nextIndex
            if(loadNext){
                loadIndex = loadIndex === urls.length-1 ? 0 : loadIndex + 1;
            }
            else{
                loadIndex = loadIndex === 0 ? urls.length-1 : loadIndex - 1;
            }
        }
    }

}
