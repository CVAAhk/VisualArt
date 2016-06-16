import QtQuick 2.5
import "viewers"
import "../../base"
import "../../../utils"

Item {
    id: display
    width: parent.width - 2 * parent.margins
    height: childrenRect.height
    y: parent.margins
    anchors.horizontalCenter: parent.horizontalCenter

    //update item
    Component.onCompleted: {
        image.source = item.image
        setMetadata(item.metadata)
    }

    //actions
    DetailToolbar { id: bar }

    //media view
    ImageViewer {
        id: image
        y: bar.height + yOffset
        scale: width > sourceSize.width ? width / sourceSize.width : 1
        property real scaleHeight: height * scale
        property real yOffset: scaleHeight/2 - height/2
    }

    //metadata view
    OmekaText {
        id: info
        width: parent.width
        height: contentHeight
        anchors.top: bar.bottom
        anchors.topMargin: image.scaleHeight
        _font: Style.metadataFont
    }

    /*! \qmlmethod Add formatted metadata to info panel*/
    function setMetadata(metadata){
       info.text = "";
        if(metadata){
            var element
            for(var i=0; i<metadata.length; i++) {
                element = metadata[i];
                info.text += "<p><b>"+element.element.name+"</b><br/>"+element.text+"</p>"
            }
        }
    }
}
