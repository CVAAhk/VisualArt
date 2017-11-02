import QtQuick 2.4
import QtQuick.Controls 1.4
import "qml/utils"
import "qml/app"

ApplicationWindow {
    id: root
    visible: true
    width: 470; height: 804
    title: "Omeka Mobile"
    color: Style.color3

    Component.onCompleted: {
        Resolution.appWindow = root
        Foreground.floatMessage = message
    }

    PageNavigation { id: page_navigation }

    //unobtrusive floating message to display errors and other notifications
    FloatMessage {
        id: message
    }

    onClosing:
    {
        if(!page_navigation.onHome())
        {
            close.accepted = false;
            page_navigation.navigateToHome();
        }
        else
        {
            close.accepted = true;
        }


    }
}
