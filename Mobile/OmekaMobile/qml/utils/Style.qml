pragma Singleton
import QtQuick 2.5

Item {
    /*-------------Color Scheme-------------*/
    /*! \qmlproperty primary color scheme */
    property color schemeColor1: "#2B89D9"
    /*! \qmlproperty secondary color scheme */
    property color schemeColor2: "white"
    /*! \qmlproperty tertiary color scheme */
    property color schemeColor3: "#E6E6E6"
    /*! \qmlproperty color with alpha values set to 0 */
    property color transparent: "#00FFFFFF"
    /*! \qmlproperty default background color of each page */
    property color viewBackgroundColor: schemeColor3
    /*! \qmlproperty default background color of toolbars */
    property color toolBarColor: transparent
    /*! \qmlproperty default background color of released buttons */
    property color releasedButtonColor: transparent
    /*! \qmlproperty default background color of pressed buttons */
    property color pressedButtonColor: "#F0F0F0"
    /*! \qmlproperty default background color of unchecked tabs */
    property color uncheckedTabColor: "#F0F0F0"
    /*! \qmlproperty default background color of checked tabs */
    property color checkedTabColor: schemeColor1
    /*! \qmlproperty default background color of detail content rectangle */
    property color detailContentBackground: schemeColor2
    /*! \qmlproperty color of playback scrubber handle*/
    property color scrubberHandleColor: schemeColor1
    /*! \qmlproperty color of playback scrubber background*/
    property color scrubberGrooveColor: "#66676A"
    /*! \qmlproperty secondary color of playback scrubber background*/
    property color scrubberGroovePositionColor: "#CDCDCE"


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
    /*! \qmlproperty thumbnail placeholder for image media */
    property url imageIcon: rootPath+"image.png"
    /*! \qmlproperty thumbnail placeholder for audio media */
    property url audioIcon: rootPath+"audio.png"
    /*! \qmlproperty thumbnail placeholder for video media */
    property url videoIcon: rootPath+"video.png"
    /*! \qmlproperty thumbnail placeholder for document media */
    property url documentIcon: rootPath+"document.png"    
    /*! \qmlproperty arrow graphic indicating the checked state of a settings option */
    property url expand: rootPath+"expand.png"
    /*! \qmlproperty indicates setting media object to full screen display */
    property url maximize: rootPath+"maximize.png"
    /*! \qmlproperty indicates restoring media object back to standard display */
    property url minimize: rootPath+"minimize.png"
    /*! \qmlproperty display of control that clears search field */
    property url clear: rootPath+"clear.png"
    /*! \qmlproperty display of busy indicators */
    property url indicator: rootPath+"indicator.png"


    property var thumbs: ({"image": imageIcon, "audio": audioIcon, "video": videoIcon, "document": documentIcon})
    /*-------------Font-------------*/

    property var titleFont: ({ color:schemeColor1, size:74, weight:Font.Bold, capitalization:Font.AllUppercase, wrapMode: Text.NoWrap, textFormat: Text.AutoText })
    property var headerFont: ({ color:schemeColor1, size:55, weight:Font.Normal, capitalization:Font.AllUppercase, wrapMode: Text.NoWrap, textFormat: Text.AutoText })
    property var settingFont: ({ color:schemeColor1, size:74, weight:Font.Normal, capitalization:Font.Capitalize, wrapMode: Text.NoWrap, textFormat: Text.AutoText })
    property var tagFont: ({ color:schemeColor1, size:74, weight:Font.ExtraBold, capitalization:Font.Capitalize, wrapMode: Text.NoWrap, textFormat: Text.AutoText })
    property var metadataFont: ({ color:"black", size:50, weight:Font.Normal, capitalization:Font.MixedCase, wrapMode: Text.Wrap, textFormat: Text.RichText })
    property var infoTitleFont: ({ color:"black", size:46, weight:Font.Bold, capitalization:Font.AllUppercase, wrapMode: Text.NoWrap, textFormat: Text.AutoText })
    property var infoSourceFont: ({ color:"black", size:40, weight:Font.Normal, capitalization:Font.MixedCase, wrapMode: Text.NoWrap, textFormat: Text.AutoText })

}
