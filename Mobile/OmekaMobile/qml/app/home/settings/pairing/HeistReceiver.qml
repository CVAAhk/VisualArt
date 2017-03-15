import QtQuick 2.5
import "../../../../utils"

/*!
  \qmltype HeistReceiver
  Subscribes to iterative heist polling of a specified pairing code
*/
Item {
    id: receiver

    //heist data fields
    property var record: null;
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
        } else {
            var entry = data[0];
            if(entry) {
                setRecord(entry.id);
                setDevice(entry.device_id);
                setItems(entry.item_ids);
            } else {
                error = "Invalid Pairing Code";
            }
        }
    }

    /*
      Clear data fields
    */
    function clearFields() {
        setRecord(null);
        setDevice(null);
        setItems(null);
        setError(null);
    }

    /*
      Set record id
    */
    function setRecord(value) {
        if(record === value) return;
        record = value;
    }

    /*
      Set device id
    */
    function setDevice(value) {
        if(device === value) return;
        device = value;
    }

    /*
      Set list of item ids
    */
    function setItems(value) {
        if(items === value) return;
        items = value;
    }

    function setError(value) {
        if(error === value) return;
        error = value;
    }

}
