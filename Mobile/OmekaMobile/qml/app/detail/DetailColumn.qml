import QtQuick 2.5
import "viewers"
import "viewers/controls"
import "../base"
import "../../utils"

/*!
    \qmltype DetailColumn

    DetailColumn is the vertical layout container for detail items.
*/
ScaleColumn {
    id: column
    y: parent.margins
    width: parent.width - 2 * parent.margins
    height: childrenRect.height
    anchors.horizontalCenter: parent.horizontalCenter

    /*! \qmlproperty
        Currently selected item
    */
    property var item: ItemManager.current

    /*! \qmlproperty
        Full screen state of selected item
    */
    property bool fullScreen: ItemManager.fullScreen

    //primary controls
    toolbar: DetailToolbar {
        id: bar
        visible: opacity > 0
        Binding on liked { when: item; value: ItemManager.isLiked(item) }
        Binding on itemId { when: item; value: item.id }
        onLikedChanged: {
            if(liked) {
                ItemManager.registerLike(item)
            }
            else {
                ItemManager.unregisterLike(item)
            }
        }
    }

    //media view
    viewer: MediaViewer {
        id: media
        Binding on source { when: item; value: item.media[0] }
        Binding on type { when: item; value: item.mediaTypes[0] }
    }

    //media specific controls
    controls: MediaControls {}

    //info panel
    info: OmekaText {
        id: info
        visible: opacity > 0
        width: parent.width
        height: contentHeight
        _font: Style.metadataFont
        Binding on text { when: item; value: metadata() }
    }

    //format metadata
    function metadata() {
        var metadata = ""
        if(item.metadata){
            var element
            for(var i=0; i<item.metadata.count; i++) {
                element = item.metadata.get(i);
                metadata += "<p><b>"+element.element.name+"</b><br/>"+element.text+"</p>"
            }
        }
        return metadata
    }

    //update screen state
    onFullScreenChanged: state = fullScreen ? "maximize" : "minimize"

    //media size states
    states: [
        State {
            name: "maximize"
            PropertyChanges { target: bar; explicit: true; opacity: 0 }
            PropertyChanges { target: info; explicit: true; opacity: 0 }
            PropertyChanges { target: background; explicit: true; opacity: 0 }
            PropertyChanges { target: media.current.background; explicit: true; opacity: 0 }
            PropertyChanges { target: scroll.flickableItem; explicit: true; contentY: 0; interactive: false }

        },
        State {
            name: "minimize"
        }
    ]

    //state transitions
    transitions: Transition {
        PropertyAnimation { duration: 250; properties: "opacity, contentY"; easing.type: Easing.OutQuad }
    }
}
