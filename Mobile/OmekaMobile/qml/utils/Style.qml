pragma Singleton
import QtQuick 2.5

Item {
    /*-------------Color Scheme-------------*/
    /*! \qmlproperty color with alpha values set to 0 */
    property color transparent: "#00FFFFFF"
    /*! \qmlproperty default background color of each page */
    property color viewBackgroundColor: "#E6E6E6"
    /*! \qmlproperty default background color of toolbars */
    property color toolBarColor: transparent
    /*! \qmlproperty default background color of released buttons */
    property color releasedButtonColor: transparent
    /*! \qmlproperty default background color of pressed buttons */
    property color pressedButtonColor: "#F0F0F0"
    /*! \qmlproperty default background color of unchecked tabs */
    property color uncheckedTabColor: "#F0F0F0"
    /*! \qmlproperty default background color of checked tabs */
    property color checkedTabColor: "#2B89D9"


    /*-------------UI Assets-------------*/
    /*! \qmlproperty root directory of ui assets */
    property url rootPath: "qrc:///ui/"
    /*! \qmlproperty logo displayed in center of home toolbar */
    property url omekaLogo: rootPath+"logo.png"
    /*! \qmlproperty icon of settings button of home toolbar */
    property url settingsIcon: rootPath+"settings.png"
    /*! \qmlproperty surrounding indicator of like button on image thumbnail */
    property url likeIndicator: rootPath+"like-indicator.png"
    /*! \qmlproperty center fill enabled when like button is checked */
    property url likeFill: rootPath+"like-fill.png"
    /*! \qmlproperty graphic indicating return to previous page */
    property url back: rootPath+"back.png"
    /*! \qmlproperty graphic for menu options */
    property url more: rootPath+"more.png"
    /*! \qmlproperty surrounding indicator of like button on detail view */
    property url likeIndicator2: rootPath+"like-indicator-2.png"


    /*-------------Font-------------*/

    property variant titleFont: ({ color:"#2B89D9", size:24, weight:Font.Bold, capitalization:Font.AllUppercase })
    property variant headerFont: ({ color:"#2B89D9", size:18, weight:Font.Normal, capitalization:Font.AllUppercase })
    property variant settingFont: ({ color:"#2B89D9", size:24, weight:Font.Light, capitalization:Font.Capitalize })
    property variant tagFont: ({ color:"#2B89D9", size:24, weight:Font.ExtraBold, capitalization:Font.Capitalize })
}
