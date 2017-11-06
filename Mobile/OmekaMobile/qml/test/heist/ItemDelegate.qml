import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../app/clients"

Component {

    Button {
        id: object
        width: parent.width
        height: 50
        text: item

        onPressedChanged: {
            if(pressed && currentCode) {
                if(items.indexOf(item) === -1) {
                    items.push(item);
                    Heist.addItem(currentCode, item, object);
                }
            }
        }
    }

}
