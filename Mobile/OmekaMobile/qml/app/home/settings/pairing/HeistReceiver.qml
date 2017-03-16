import QtQuick 2.5
import "../../../../utils"

/*!
  \qmltype HeistReceiver
  Subscribes to iterative heist polling of a specified pairing code
*/
Item {
    id: receiver

    //heist data fields
    property var session: null;
    property var device: null;
    property var items: null;
    property var error: null;

    //pairing code
    property var code;

    //heist data
    property var data;

    //activation state of receiver
    property var register;


    /*
      Update registered state depending length of code entered by user
    */
    onCodeChanged: {
        register = code && code.length === 4;
    }

    /*
      Manages registration for heist data requests
    */
    onRegisterChanged: {
        if(register) {
            HeistManager.registerReceiver(receiver);
        } else if(HeistManager.registered(receiver)) {
            HeistManager.unregisterReceiver(receiver);
            clearFields()
        }
    }

    /*
      Update data fields and report connection/request errors
    */
    onDataChanged: {
        if(data.errors) {
            error = data.errors[0].message;
            clearFields();
        } else {
            var entry = data[0];
            if(entry) {
                device = entry.device_id;
                session = entry.id;
                items = entry.item_ids;
            } else {
                error = "Invalid Pairing Code";
            }
        }
    }

    /*
      Clear data fields
    */
    function clearFields() {
        device = null;
        session = null;
        items = null;
        error = null;
    }

}
