import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../utils"

Component {

    Button {
        id: object
        width: parent.width
        height: 50
        text: String(item)

        onPressedChanged: {
            if(pressed && currentCode) {
                if(items.indexOf(object.text) === -1) {
                    items.push(object.text);
                    HeistManager.addItem(currentCode, object.text, object);
                }
            }
        }
    }

}
