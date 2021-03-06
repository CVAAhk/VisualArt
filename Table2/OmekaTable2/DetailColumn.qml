import QtQuick 2.5
import "."

/*!
    \qmltype DetailColumn

    DetailColumn is the vertical layout container for detail items.
*/
ScaleColumn
{
    property double rootScale: 1.0

    id: column
    x: 15
    y: 0//parent.margins
    width: parent.width - 10//2 * parent.margins
    height: childrenRect.height
    //anchors.horizontalCenter: parent.horizontalCenter

    //assign column to detail for delayed loading
    Component.onCompleted: {
        content_screen.column = column
    }

    /*! \qmlproperty
        Currently selected item
    */
    property var item: root.item? root.item: null//getSelectedItem();//: ItemManager.current

    function getSelectedItem()
    {
        return ItemManager.selectedItems[ItemManager.selectedItems.length - 1];

    }

    /*! \qmlproperty
        Full screen state of selected item
    */
    //property bool fullScreen: ItemManager.fullScreen

    //TODO
    //primary controls
//    toolbar: DetailToolbar {
//        id: bar
//        visible: opacity > 0
//        liked: item ? ItemManager.isLiked(item) : false
//        itemId: item ? item.id : -1
//        onLikedChanged: {
//            if(liked) {
//                ItemManager.registerLike(item)
//            }
//            else {
//                ItemManager.unregisterLike(item)
//            }
//        }
//    }

    //media view
//    viewer: MediaViewer {
//        id: media
//        sources: item ? item.media : null
//        type: item ? item.mediaTypes[0] : ""
//    }

    //TODO
    //media specific controls
    //controls: MediaControls { media: media }

    //info panel
    info: OmekaText {
        //id: info
        //anchors.horizontalCenter: parent.horizontalCenter
        visible: opacity > 0
        width: parent.width - 20//Resolution.applyScale(60)
        height: contentHeight
        _font: Style.metadataFont
        rootScale: column.rootScale
        text: item ? metadata(): ""
        onLinkActivated: Qt.openUrlExternally(link)
    }

    //format metadata
    function metadata() {
        if(!item)
        {
            return ""
        }
        var metadata = ""
        if(item.metadata){
            var element
            if(item.metadata.count)
            {
                for(var i=0; i<item.metadata.count; i++) {
                    element = item.metadata.get(i);
                    //console.log("element = ", element, " element.text = ", element.text)
                    if(element)
                    {
                        element.text = element.text.replace(/<[\/]{0,1}(a|A)[^><]*>/g,"")
                        metadata += "<p><b>"+element.element.name+"</b><br/>"+element.text+"</p><br/>"
                    }
                }
            }
            else
            {
                for(var i=0; i<item.metadata.length; i++) {
                    element = item.metadata[i];
                    //console.log("element = ", element, " element.text = ", element.text)
                    if(element)
                    {
                        element.text = element.text.replace(/<[\/]{0,1}(a|A)[^><]*>/g,"")
                        metadata += "<p><b>"+element.element.name+"</b><br/>"+element.text+"</p><br/>"
                    }
                }
            }
        }

        return metadata
    }

    //update screen state
    //onFullScreenChanged: state = fullScreen ? "maximize" : "minimize"

    //media size states
//    states: [
//        State {
//            name: "maximize"
//            PropertyChanges { target: bar; explicit: true; opacity: 0 }
//            PropertyChanges { target: info; explicit: true; opacity: 0 }
//            PropertyChanges { target: background; explicit: true; opacity: 0 }
//            PropertyChanges { target: scroll.flickableItem; explicit: true; contentY: 0; interactive: false }
//        },
//        State {
//            name: "minimize"
//        }
//    ]

    //state transitions
//    transitions: Transition {
//        PropertyAnimation { duration: 250; properties: "opacity, contentY"; easing.type: Easing.OutQuad }
//    }
}
