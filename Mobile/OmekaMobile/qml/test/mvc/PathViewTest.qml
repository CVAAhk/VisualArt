import QtQuick 2.5
import QtQuick.Controls 1.4

ApplicationWindow{
    visible: true
    width: 470; height: 800

    property real yMiddle: height/2
    property real xLeft: -width
    property real xMiddle: width/2
    property real xRight: width*2    

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

            Text{ text:index }

            Connections{
                target: view
                onCurrentIndexChanged:{
                    print("Previous: "+view.previousIndex+" Next: "+view.nextIndex)
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

        path:Path{
            startX: xLeft; startY: yMiddle
            PathAttribute { name: "rectOpacity"; value : 0}
            PathAttribute { name: "rectScale"; value : .85}
            PathLine { x: xMiddle; y: yMiddle }
            PathAttribute { name: "rectOpacity"; value : 1}
            PathAttribute { name: "rectScale"; value : 1}
            PathLine { x: xRight; y: yMiddle }
        }
    }

}
