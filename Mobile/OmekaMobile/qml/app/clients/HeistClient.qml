pragma Singleton
import QtQuick 2.5
import "../clients"

Item {
    id: heist_manager

    //request types
    readonly property var get: "GET";
    readonly property var post: "POST";
    readonly property var put: "PUT";
    readonly property var del: "DELETE";        

    /*
      Target omeka instance
    */
    property url endpoint: "http://dev.omeka.org/mallcopy/"

    /*
      Omeka site identifier
    */
    property var omekaID: Omeka.prettyName(endpoint)

    /*
     Url to heist plugin
    */
    property var heistURL: endpoint+"api/heist/"

    /*
     Map session codes to heist record id
    */
    property var sessions: ({});

    /*
     Map session codes to item lists
    */
    property var items: ({});

    /*
     Valid pairing code entered by phone
    */
    property var pairingCode: ""

    /*
      Universally unique identifier to tag the Heist instance. Currently only
      applicable to mobile devices but can eventually be leveraged for multiple
      table instances targeting the same omeka endpoint.
    */
    property var uid: guid.getSequentialGUID();

    /*List of registered receivers of iterative polling results*/
    property var receivers: [];

    /*Returns whether the heist plugin is installed for this omeka instance*/
    property bool heistIsSupported: false

    /*Invoked when item is liked through heist plugin*/
    signal heistLike(var item)

    ///////////////////////////////////////////////////////////
    //          PLUGIN CHECK
    ///////////////////////////////////////////////////////////

    //Check for heist support
    Component.onCompleted: pingPlugin()

    /*! \internal
     Ping the hesit plugin to see if it is installed for this omeka instance and
     set the heistIsSupported flag based on the result
    */
    function pingPlugin() {        
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if(request.readyState === XMLHttpRequest.DONE) {
                if(request.responseText) {
                    try {
                        var result = JSON.parse(request.responseText)
                        heistIsSupported = result.message === undefined
                    } catch(e) {
                        heistIsSupported = false
                    }
                }
            }
        }
        request.open(get, heistURL, true);
        request.send();
    }


    ///////////////////////////////////////////////////////////
    //          PAIR TRACKING
    ///////////////////////////////////////////////////////////

    //tracks entities involved in pairings
    Pairings {
        id: pairings
    }

    /*
      Establish pairing between table user and device
    */
    function setPairing(user, device) {
        if(pairings.setPairing(user, device)) {
            setDevice(user, device);
            pairingCode = user;
        }
    }

    /*
      Release pairing between table user and device
    */
    function releasePairing(user, device) {
        if(pairings.releasePairing(user, device)) {
            setDevice(user, "");
            pairingCode = "";
        }
    }

    /*
      Returns user paired with device
      \a device - device id
    */
    function getUserByDevice(device) {
        return pairings.getUserByDevice(device);
    }

    /*
      Returns device paired with user
      \a user - pairing code
    */
    function getDeviceByUser(user) {
        return pairings.getDeviceByUser(user);
    }

    /*
      Determines if device is currently paired with table user
    */
    function deviceIsPaired(device) {
        return pairings.deviceIsPaired(device);
    }

    /*
      Determines if table user is currently paired with device
    */
    function userIsPaired(user) {
        return pairings.userIsPaired(user);
    }

    /*! \internal
     Add session if one does not exist
     \a result - query result
    */
    function addSession(result) {
        if(!result) return;
        if(!(result.pairing_id in sessions)) {
            sessions[result.pairing_id] = result.id;
        }
    }

    /*! \internal
     Remove existing session
     \a code - session pairing code
    */
    function removeSession(code) {
        if(code in sessions) {
            delete sessions[code];
        }
    }

    ///////////////////////////////////////////////////////////
    //          DATA POLLING
    ///////////////////////////////////////////////////////////

    //iteratively polls heist for data updates
    Timer {
        id: timer
        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: pollData()
    }

    /*! \internal
      Submits poll requests for heist updates
    */
    function pollData() {
        for(var i=0; i<receivers.length; i++) {
            getData(heistURL+"?pairing_id="+receivers[i].code, receivers[i]);
        }
    }

    /*
      Register receiver for iterative heist updates of a specified pairing code
    */
    function registerReceiver(receiver) {
        if(!registered(receiver)) {
            receivers.push(receiver);
        } if(!timer.running && receivers.length) {
            timer.start();
        }
    }

    /*
      Unregister receiver from iterative heist updates of a specified pairing code
    */
    function unregisterReceiver(receiver) {
        if(registered(receiver)) {
            receivers.splice(receivers.indexOf(receiver), 1);
        } if(timer.running && !receivers.length) {
            timer.stop();
        }
    }

    /*
      Returns the registered state of the receiver
    */
    function registered(receiver) {
        return receivers.indexOf(receiver) !== -1;
    }


    ///////////////////////////////////////////////////////////
    //          HEIST CORE
    ///////////////////////////////////////////////////////////

    /*! \internal
      Sends http request and links response handler
      \a url - heist request
      \a type - request type (GET, POST, PUT, or DELETE)
      \a data - request body
      \a context - calling object instance
    */
    function submitRequest(url, type, body, context) {
        console.log("REQUEST: "+url+" "+body);
        var request = new XMLHttpRequest();
        request.type = type;
        request.context = context;
        request.onreadystatechange = onResponse(request);
        request.open(type, url, true);
        request.setRequestHeader('Content-type','application/json');
        request.send(body);
    }

    /*! \internal
      Evaluate validity of heist response
      \a request - http request
    */
    function onResponse(request) {
        return function(){
            if(request.readyState === XMLHttpRequest.DONE){
                switch(request.type) {
                    case get:
                        var result = JSON.parse(request.responseText);
                        addSession(result[0]);
                        request.context.data = result;
                        break;
                    case post:
                        var result = JSON.parse(request.responseText);
                        addSession(result);
                        if(request.status === 201) {
                            console.log("record ADDED");
                        }
                        break;
                    case put:
                        console.log(request.status);
                        break;
                    case del:
                        console.log("record REMOVED");
                        break;
                }
            }
        }
    }

    /*! \internal
      Add data record to heist table
      \a data - record data
      \a context - calling object
    */
    function addData(data, context) {
        var json = JSON.stringify(data);
        submitRequest(heistURL, post, json, context);
    }

    /*! \internal
      Remove record by id
      \a id - record id
      \a context - calling object
    */
    function removeData(id, context) {
        var url = heistURL+id;
        submitRequest(url, del, null, context);
    }

    /*! \internal
      Update data field in heist record
      \a url - url to specific record
      \a data - data values
      \a context - calling object
    */
    function updateData(url, data, context) {
        var json = JSON.stringify(data);
        submitRequest(url, put, json, context);
    }

    /*! \internal
     Get heist record data
     \a url - url to specific record
     \a context - calling object
    */
    function getData(url, context) {
        submitRequest(url, get, "", context);
    }

    ///////////////////////////////////////////////////////////
    //          TABLE REQUESTS
    ///////////////////////////////////////////////////////////

    /*Clears all heist records generated by this instance*/
    function clearAllSessions() {
        for(var code in sessions) {
            removeData(sessions[code]);
        }
        sessions = ({});
    }

    /*Start session by adding a new record with provided code
      /a code - pairing code
    */
    function startPairingSession(code) {
        var data = {pairing_id: code};
        addData(data, "");
    }

    /*End session by removing record with specified code
      /a code - pairing code
    */
    function endPairingSession(code) {
        if(code in sessions) {
            removeData(sessions[code]);
            removeSession(code);
        }
    }

    /*Add item to item list
      /a code - pairing code
      /a item - item url to add
      /a context - calling object
    */
    function addItem(code, item, context) {
        if(!(code in sessions)) return;
        if(!(code in items)) {
            items[code] = [];
        }
        items[code].push(item);
        updateData(heistURL+sessions[code], {item_ids: items[code]}, context);
    }

    /*Clear item list
      /a code - pairing code
      /a item - item url to add
      /a context - calling object
    */
    function removeAllItems(code, context) {        
        if(code in sessions && code in items) {
            items[code].length = 0;
            updateData(heistURL+sessions[code], {item_ids: items[code]}, context);
        }
    }

    /*
      Removes all records in heist regardless of generating instance. This is just a temporary solution
      to ensure records are cleaned up until a more reliable deconstruction cleansing is implemented. This
      approach does not account for multiple table instances and therefore is not a long-term solution.
     */
    function clearHeist() {
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if(request.readyState === XMLHttpRequest.DONE) {
                if(request.responseText) {
                    var result = JSON.parse(request.responseText)
                    for(var i in result) {
                        removeData(result[i].id)
                    }
                }
            }
        }
        request.open(get, heistURL, true);
        request.send();
    }

    ///////////////////////////////////////////////////////////
    //          DEVICE REQUESTS
    ///////////////////////////////////////////////////////////

    //used to implicitly normalize data types
    property var normalizer: ListModel {}

    //process heist item registration
    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.context === heist_manager) {

                var itemData = {
                    id: result.item,
                    fileCount: result.file_count,
                    metadata: result.metadata,
                    uid: result.uid,
                    omekaID: result.omekaID,
                    endpoint: result.endpoint
                }

                normalizer.append(itemData);
                var item = normalizer.get(normalizer.count -1);
                heistLike(item);
            }
        }
    }

    /*Set device id corresponding to pairing code. A non empty value signals a connection to the table
      and an empty value signals a disconnection.
      /a code - pairing code
      /a item - item url to add
      /a context - calling object
    */
    function setDevice(code, device) {
        if(code in sessions) {
            updateData(heistURL+sessions[code], {device_id: device}, "");
        }
    }

    /*
      Trigger registration process of heist item
      /a item_id - heist item id
      /a code - pairing code
    */
    function registerItem(item_id, code) {
        if(!(code in sessions)) return;
        if(!(code in items)) {
            items[code] = [];
        }
        items[code].push(item_id);
        Omeka.getItemById(item_id, heist_manager, endpoint+"api/");
    }

    /*
      Unregister item submitted through heist
      /a item - heist item to unregister
    */
    function unregisterItem(item) {
        if(item.omekaID === omekaID) {
            removeItem(pairingCode, item.id, null);
        }
    }

    /*Remove item from list
      /a code - pairing code
      /a item - item url to add
      /a context - calling object
    */
    function removeItem(code, item, context) {
        if(!(code in sessions)) return;
        if(code in items && items[code].indexOf(item) > -1) {
            var index = items[code].indexOf(item);
            items[code].splice(index, 1);
            updateData(heistURL+sessions[code], {item_ids: items[code]}, context);
        }
    }

    /*
      Unregister item submitted through heist
    */
    function unregisterAllItems() {
        removeAllItems(pairingCode, null);
    }

}
