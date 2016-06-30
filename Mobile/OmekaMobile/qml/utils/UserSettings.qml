pragma Singleton
import QtQuick 2.5
import QtQuick.LocalStorage 2.0
import "../js/storage.js" as Settings

Item {

    property string aboutCollection: "asldkjfsalkdjflksjdfa"
    property string aboutOOE: "aowieurjowieroiwuerieroeiuoieur"
    property string clearLikesConfirm: "<p><b>Warning:</b><br/>This action will delete all registered likes.</p>"

    function setLayout(layout) {
        Settings.setLayout(layout)
    }

    function getLayout() {
        return Settings.getLayout()
    }

    function clearAllLikes() {
        Settings.clearAllLikes()
    }

    function likesExist() {
        return Settings.getLikes().length > 0;
    }
}
