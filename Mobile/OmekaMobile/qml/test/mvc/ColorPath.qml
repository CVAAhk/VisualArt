import QtQuick 2.5
import QtQuick.Controls 1.4

ApplicationWindow{
    visible: true
    width: 470; height: 800

    property real yMiddle: height/2
    property real xLeft: -width
    property real xMiddle: width/2
    property real xRight: width*2
    property real yTop: -height
    property real yBotom: height*2

    property real loadIndex : 0

    Component{
        id: delegate
        Rectangle{
            id: item
            width: parent.width
            height: parent.height
            color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
        }
    }

    PathView{
        id: view
        anchors.fill: parent
        model: 3
        delegate: delegate
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        flickDeceleration: 25
        maximumFlickVelocity: 5000

        property Rectangle next;

        path:Path{
            startX: xLeft; startY: yMiddle
            PathLine { x: xMiddle; y: yMiddle }
            PathLine { x: xRight; y: yMiddle }
        }

        onCurrentIndexChanged: {
            next = view.childAt(width+width/2,height/2)
            if(next) {
                next.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
            }
        }
    }

}
