import QtQuick 2.5

Item {
    //=====================================================================
    // ROOT ITEM PROPERTIES
    //=====================================================================
    property Flickable flickable               : null
    property int       handleSize              : 30
    property string barSrc: ""
    property string handleSrc: ""

    signal scrollbarMoved()

    //=====================================================================
    // ROOT ITEM SETTINGS
    //=====================================================================
    id: scrollbar
    width: handleSize
    visible: (flickable.visibleArea.heightRatio < 1.0)

    anchors
    {
        top: flickable.top
        bottom: flickable.bottom
    }


    //=========================================================================
    // UI ELEMENTS
    //=========================================================================


    function scrollDown ()
    {
        flickable.contentY = Math.min (flickable.contentY + (flickable.height / 4), flickable.contentHeight - flickable.height)
    }
    function scrollUp ()
    {
        flickable.contentY = Math.max (flickable.contentY - (flickable.height / 4), 0)
    }


   Binding
   {
        target: handle
        property: "y"
        value: (flickable.contentY * clicker.drag.maximumY / (flickable.contentHeight - flickable.height))
        when: (!clicker.drag.active)
    }
    Binding
    {
        target: flickable
        property: "contentY"
        value: (handle.y * (flickable.contentHeight - flickable.height) / clicker.drag.maximumY)
        when: (clicker.drag.active || clicker.pressed)
    }

    Image
    {
       id: backScrollbar;

       antialiasing: true;

       source: barSrc
       anchors { fill: parent; }

       MouseArea {
           anchors.fill: parent;
           onClicked: { }
       }
     }
    //=========================================================================
    // SCROLL UP BUTTON
    //=========================================================================
//    MouseArea {
//        id: btnUp
//        height: width
//        anchors {
//            bottom: parent.top
//            left: parent.left
//            right: parent.right
//            //margins: (backScrollbar.border.width +1)
//        }
//        onClicked: { scrollUp () }

//        Text {
//            text: "V"
//            color: (btnUp.pressed ? "blue" : "black")
//            rotation: -180
//            anchors.centerIn: parent
//        }
//    }
    //=========================================================================
    // SCROLL DOWN BUTTON
    //=========================================================================
//    MouseArea {
//        id: btnDown
//        height: width
//        anchors {
//            left: parent.left
//            right: parent.right
//            bottom: parent.bottom
//            //margins: (backScrollbar.border.width +1)
//        }
//        onClicked: { scrollDown () }

//        Text {
//            text: "V"
//            color: (btnDown.pressed ? "blue" : "black")
//            anchors.centerIn: parent
//        }
//    }
    Item
    {
        id: groove
        clip: true

//        anchors
//        {
//            fill: parent
//        }
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        //anchors.left: parent.left

        x: root.x - 50
        width: 132

        MouseArea
        {
            id: clicker
            drag
            {
                target: handle
                minimumY: 0
                maximumY: (groove.height - backHandle.height)
                axis: Drag.YAxis


            }
            anchors.fill: parent

            onClicked:
            {
                flickable.contentY = (mouse.y / groove.height * (flickable.contentHeight - flickable.height));
            }
        }
        Item
        {
            id: handle
            //height: Math.max (20, (flickable.visibleArea.heightRatio * groove.height))
            x: backScrollbar.x - (backHandle.width - backScrollbar.width) * 0.5 + 50
            width: 132
            Image
            {
                id: backHandle

                source: handleSrc
            }
            onYChanged:
            {
                scrollbar.scrollbarMoved();
            }
            Drag.active: clicker.drag.active

//            Drag.onActiveChanged :
//            {
//                console.log("SCROLL BAR MOVED");
//                scrollbar.scrollbarMoved();
//            }
        }
    }
}
