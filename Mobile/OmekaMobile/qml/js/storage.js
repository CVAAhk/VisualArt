var LIKES = "likes"
var USER = "user"
var ENDPOINTS = "endpoints"

function getDatabase() {
     return LocalStorage.openDatabaseSync("omekamobile", "0.1", "settings", 1000000);
}

function set(table, setting, value) {
   var db = getDatabase();
   var res = "";
   db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS '+table+'(setting TEXT UNIQUE, value TEXT)');
        var rs = tx.executeSql('INSERT OR REPLACE INTO '+table+' VALUES (?,?)', [setting,value]);
              if (rs.rowsAffected > 0) {
                res = "SET";
              } else {
                res = "FAILED";
              }
        }
  );
  return res;
}

function remove(table, setting){
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM '+table+' WHERE setting=?', [setting]);
        if(rs.rowsAffected > 0){
            res = "REMOVED";
        }
        else{
            res = "FAILED";
        }
    });
    return res;
}

function get(table, setting) {
   var db = getDatabase();
   var res="";
   try {
       db.transaction(function(tx) {
         var rs = tx.executeSql('SELECT value FROM '+table+' WHERE setting=?', [setting]);
         if (rs.rows.length > 0) {
              res = rs.rows.item(0).value;
         } else {
             res = 0;
         }
      })
   } catch (err) {
       res = 0;
   };
  return res
}

function rows(table){
    var db = getDatabase();
    var res = "";
    try{
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM '+table);
            res = rs.rows;
        })
    }
    catch (err) {
        res = []
    }
    return res
}

function clear(table) {
   var db = getDatabase();
   var res = "";
   db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM '+table);
              if (rs.rowsAffected > 0) {
                res = "CLEARED";
              } else {
                res = "FAILED";
              }
        }
  );
  return res;
}

function drop(table) {
    gc() //workaround for locked table bug
    var db = getDatabase();
    var res = ""
    db.transaction(function(tx) {
        var rs = tx.executeSql('DROP TABLE '+table);
        if(rs.rowsAffected > 0){
            res = "DROPPED";
        }
        else{
            res = "FAILED";
        }
    });
    return res;
}

/*--------LIKES table operations--------*/

/*
  Register the item with the LIKES table
  \a item The liked item
*/
function addLike(item) {
    set(LIKES, item.uid, item.endpoint);
}

/*
  Unregister the item from the LIKES table
  \a item  The item to remove
*/
function removeLike(item) {
    remove(LIKES, item.uid);
}

/*
  Returns true if item is registered with the specified table, false otherwise
  \a id   The table name
  \a item The item to search for
 */
function isLiked(item) {
    return get(LIKES, item.uid) !== 0;
}

/*
  Returns all registered likes
*/
function getLikes() {
    var likes = []
    var entries = rows(LIKES)
    for(var i=0; i<entries.length; i++) {
        likes.push(entries[i])
    }
    return likes;
}

/*
  Clears all tables
*/
function clearAllLikes() {
    return clear(LIKES);
}

/*--------USER table operations--------*/
function setLayout(layout) {
    set(USER, "layout", layout);
}

function getLayout() {
    return get(USER, "layout");
}

function setGUID(guid) {
    set(USER, "guid", guid);
}

function getGUID() {
    return get(USER, "guid");
}

function setLastSelectedEndpoint(index) {
    set(USER, "index", index);
}

function getLastSelectedEndpoint() {
    return get(USER, "index");
}

/*
  Clears all tables
*/
function clearUser() {
    return clear(USER);
}

/*--------ENDPOINTS table operations--------*/

/*
  Register the endpoint with the ENDPOINTS table
*/
function addEndpoint(endpoint) {
    set(ENDPOINTS, endpoint.omekaID, endpoint.url);
}

/*
  Unregister the endpoint from the ENDPOINTS table
*/
function removeEndpoint(endpoint) {
    remove(ENDPOINTS, endpoint.omekaID);
}
function isRegistered(endpoint) {
    return get(ENDPOINTS, endpoint.omekaID) !== 0;
}
/*
  Returns all registered endpoints
*/
function getEndpoints() {
    var endpoints = []
    var entries = rows(ENDPOINTS)
    for(var i=0; i<entries.length; i++) {
        endpoints.push(entries[i])
    }
    return endpoints;
}
/*
  Clears all tables
*/
function clearEndpoints() {
    return clear(ENDPOINTS);
}


