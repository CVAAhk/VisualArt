import QtQuick 2.5
import "."

/*!
  \qmltype HeistReceiver
  Subscribes to iterative heist polling of a specified pairing code
*/
Item {
    id: receiver

    //heist data fields
    property var session: null;
    property var device: null;
    property var items: [];
    property var error: null;

    //pairing code
    property var code;

    //heist data
    property var data;

    //activation state of receiver
    property var register;

    //comparison item list to identify mods
    property var currentItems: []

    //signal invoked on item list change
    signal addItem(var item);


    /*
      Update registered state depending length of code entered by user
    */
    onCodeChanged: {
        register = code && String(code).length === 4;
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
                updateItems();
            } else {
                error = "Invalid Pairing Code";
            }
        }
    }

    /*
      Evaluates the item list difference to identify additions
    */
    function updateItems() {
        if(!items) return;

        var additions = diff(items, currentItems);
        for(var a in additions) {
            addItem(additions[a]);
        }

        currentItems = items;
    }

    /*
      Returns an array containing elements present in a1 that are not present in a2
    */
    function diff(a1, a2) {
        if(!a2) {
            return a1;
        }
        var d = [];
        for(var i in a1) {
            if(a2.indexOf(a1[i]) === -1) {
                d.push(a1[i]);
            }
        }
        return d;
    }

    /*
      Clear data fields
    */
    function clearFields() {
        device = null;
        session = null;
        items = [];
        error = null;
    }

}
