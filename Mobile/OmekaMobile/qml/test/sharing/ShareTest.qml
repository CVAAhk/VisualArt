import QtQuick 2.5
import QtQuick.Controls 1.4
import com.lasconic 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 470; height: 800

    ShareUtils { id: shareUtils }

    Button {
        text: "Native Share"
        anchors.centerIn: parent
        onClicked: shareUtils.share("Ignore Test", "http://dev.omeka.org/mallcopy/items/show/1")
    }

}
