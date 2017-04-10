import QtQuick 2.5
import QtQuick.Controls 1.4
import "../../utils"

Component {

    Button {
        id: object
        width: parent.width
        height: 50
        text: String(item)
        checkable: true

        property var code;

        onCheckedChanged: {
            if(checked && currentCode) {
                code = currentCode
                HeistManager.addItem(code, object.text, object);
            } else if(!checked && code) {
                HeistManager.removeItem(code, object.text, object);
            }
        }

        function reset() {
            code = null
            checked = false
        }
    }

}
