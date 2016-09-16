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

    //assign column to detail for delayed loading
    Component.onCompleted: {
        detail.column = column
    }

    /*! \qmlproperty
        Currently selected item
    */
    property var item

    /*! \qmlproperty
        Full screen state of selected item
    */
    property bool fullScreen: ItemManager.fullScreen

    //primary controls
    toolbar: DetailToolbar {
        id: bar
        visible: opacity > 0
        liked: item ? ItemManager.isLiked(item) : false
        itemId: item ? item.id : -1
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
        sources: item ? item.media : null
        type: item ? item.mediaTypes[0] : ""
    }

    //media specific controls
    controls: MediaControls { media: media }

    //info panel
    info: OmekaText {
        id: info
        anchors.horizontalCenter: parent.horizontalCenter
        visible: opacity > 0
        width: parent.width - Resolution.applyScale(60)
        height: contentHeight
        _font: Style.metadataFont
        text: metadata()
        onLinkActivated: Qt.openUrlExternally(link)
    }

    //format metadata
    function metadata() {
        if(!item) return ""
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

    //load item details
    function loadItem() {
        item = ItemManager.current
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
