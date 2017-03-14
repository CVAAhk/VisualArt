import QtQuick 2.0

Item
{
    property alias source: img.source

    property bool pressed: false

    id: root

    signal clicked()

    width: img.width
    height: img.height

    Image
    {
        id: img

        MultiPointTouchArea {


            id: touch

            mouseEnabled: true

            anchors.fill: parent

            onPressed:
            {
                if (!root.pressed)
                {
                    root.pressed = true;
                    press_timer.start();
                }
            }

            onTouchUpdated:
            {
               // if (!root.pressed)
              //  {
              //      root.pressed = true;
              //      press_timer.start();
              //  }
            }

            onReleased:
            {
                root.pressed = false;
            }

            Timer
            {
                id: press_timer
                interval: 10000
                onTriggered: root.pressed = false
            }
        }
    }
}

