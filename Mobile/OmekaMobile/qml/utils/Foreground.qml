pragma Singleton
import QtQuick 2.5

Item {

    /*!
      Global reference to main page navigation bar
     */
    property var mainNavigationBar

    /*!
      Navigate to likes page
      \a pulse  Pulse when true, stop when false
    */
    function pulseLikesButton(pulse) {
        if(!mainNavigationBar) return;
        mainNavigationBar.pulseLikesButton = pulse;
    }

    /*!
      Global instance of a float message for displaying notifications and errors
     */
    property var floatMessage

    /*!
      Set error message to display
      \a message  The message value
      \a duration  The time to display the message. Negative values imply display indefinitely until hide is explicitly called.
      \a margin  The margin between the bottom of the message and the bottom of the viewport.
    */
    function showError(message, duration, margin) {
        if(!floatMessage) return;
        floatMessage.show(message, duration, margin, "red");
    }

    /*!
      Set standard message to display
      \a message  The message value
      \a duration  The time to display the message. Negative values imply display indefinitely until hide is explicitly called.
      \a margin  The margin between the bottom of the message and the bottom of the viewport.
    */
    function showMessage(message, duration, margin) {
        if(!floatMessage) return;
        floatMessage.show(message, duration, margin, "#656565");
    }

    /*!
      Stop message display
    */
    function hideMessage() {
        if(!floatMessage) return;
        floatMessage.hide();
    }

}
