pragma Singleton
import QtQuick 2.5
import QtQuick.LocalStorage 2.0
import "../js/storage.js" as Settings

Item {

    id: root
    property string aboutCollection: ""
    property string aboutOOE: "<p><b>Description</b><br/><br/>[Omeka Everywhere Mobile] is a collaboration between the Roy Rosenzweig Center for History and New Media, Ideum, and the University of Connecticut’s Digital Media and Design Department, made possible by a grant from the Institute of Museum and Library Services.</p>"
    property string heistUnsupported: "<p><b>Description</b><br/><br/>The current endpoint does not have the Heist plugin required to use this feature.</p>"
    property string clearLikesConfirm: "<p><b>Warning:</b><br/>This action will delete all registered likes and cannot be undone.</p>"    
    property string restAPIDisabled: "<p><b>API ERROR:</b>"+
                                     "<br/>The REST API is either not supported or not enabled for the Omeka instance. "+
                                     "Please see the <a href=\"https://omeka.org/codex/Managing_API_Settings\">documentation</a> for instructions.</p>"

    property var layouts: ["list", "grid", "grid"];
    property int layout;
    property string layoutID: layouts[layout];

    function init() {
        root.layout = getLayout()
        var uid = Settings.getGUID() || guid.getSequentialGUID()
        Settings.setGUID(uid)
    }

    function getGUID() {
        return Settings.getGUID()
    }

    function setLayout(layout) {
        root.layout = layout
        Settings.setLayout(layout)
    }

    function getLayout() {
        return Settings.getLayout()
    }

    function likesExist() {
        return Settings.getLikes().length > 0
    }
}
