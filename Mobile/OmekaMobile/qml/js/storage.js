var LIKES = "likes"
var USER = "user"

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
  Register omeka instance id with main LIKES table and register the
  liked item with the omeka table
  \a id   The omeka_id corresponding to the omeka instance
  \a url  The omeka endpoint
  \a item The liked item
*/
function addLike(id, url, item) {
    set(LIKES, id, url);
    set(id, item, "");
}

/*
  Remove liked item from the specified table
  \a id    The table name
  \a item  The item to remove
*/
function removeLike(id, item) {
    remove(id, item);

    //if table is empty after removal, unregister the table
    if(rows(id).length === 0) {
        drop(id)
        remove(LIKES, id)
    }
}

/*
  Returns true if item is registered with the specified table, false otherwise
  \a id   The table name
  \a item The item to search for
 */
function isLiked(id, item) {
    return get(id, item) !== 0;
}

/*
  Returns endpoint registered to omeka_id
  \a  The omeka_id
 */
function getUrl(id) {
    var entry = get(LIKES, id)
    return entry
}

/*
  Returns all likes of specified table
  \a  The name of the table
*/
function getLikes(id) {
    return rows(id);
}

/*
  Returns likes of all tables
*/
function getAllLikes() {
    var likes = []
    var tables = rows(LIKES)
    for(var i=0; i<tables.length; i++) {
        likes = likes.concat(rows(tables[i].setting))
    }
    return likes;
}

/*
  Returns tables with registered likes
 */
function getLikedTables() {
    return rows(LIKES)
}

/*
  Clears all tables
*/
function clearAllLikes() {
    var tables = rows(LIKES)
    for(var i=0; i<tables.length; i++) {
        drop(tables[i].setting)
    }
    return clear(LIKES);
}


/*--------USER table operations--------*/
function setLayout(layout) {
    set(USER, "layout", layout);
}

function getLayout() {
    return get(USER, "layout");
}
