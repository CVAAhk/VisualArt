pragma Singleton
import QtQuick 2.5
import QtQuick.LocalStorage 2.0
import "../js/storage.js" as Settings

Item {

    property string aboutCollection: "<p><b>Description</b><br/><br/>Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit sit amet non magna. Nulla vitae elit libero, a phareta augue. Etiam port sem malesuada magna molisis eusimod. Nulla vitae elit libero, a phareta augue. Maecenas sed diam eget risus varius blandit sit amet non magna.</p>"
    property string aboutOOE: "<p><b>Description</b><br/><br/>Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit sit amet non magna. Nulla vitae elit libero, a phareta augue. Etiam port sem malesuada magna molisis eusimod. Nulla vitae elit libero, a phareta augue. Maecenas sed diam eget risus varius blandit sit amet non magna.</p>"
    property string clearLikesConfirm: "<p><b>Warning:</b><br/>This action will delete all registered likes and cannot be undone.</p>"

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
