var LIKES = "likes"

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

function addLike(id) {
    set(LIKES, id, 1);
}

function removeLike(id) {
    remove(LIKES, id);
}

function isLiked(id) {
    return get(LIKES, id) !== 0;
}
