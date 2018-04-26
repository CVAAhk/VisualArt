pragma Singleton
import QtQuick 2.5

Item {
    /*-------------Color Scheme-------------*/
    property color color1: "#666666"
    property color color2: "white"
    property color color3: "#E6E6E6"
    property color color4: "#F0F0F0"
    property color color5: "#66676A"
    property color color6: "#CDCDCE"
    property color color7: "#2b89d9"

    property color transparent: "#00FFFFFF"

    /*-------------UI Assets-------------*/
    /*! \qmlproperty root directory of ui assets */
    property url rootPath: "content/ui/"
    /*! \qmlproperty logo displayed in center of home toolbar */
    property url omekaLogo: rootPath+"logo.png"
    /*! \qmlproperty icon of settings button of home toolbar */
    property url settingsIcon: rootPath+"settings.png"
    /*! \qmlproperty surrounding indicator of like button on image thumbnail */
    property url likeIndicator: rootPath+"like-indicator.png"
    /*! \qmlproperty center fill enabled when like button is checked */
    property url likeFill: rootPath+"like-fill.png"
    /*! \qmlproperty like indicator on detailed views */
    property url detailLikeIndicator: rootPath+"detail-like-indicator.png"
    /*! \qmlproperty center fill enabled when detail like is checked */
    property url detailLikeFill: rootPath+"detail-like-fill.png"
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
    /*! \qmlproperty index graphic for image viewer */
    property url index: rootPath+"index.png"
    /*! \qmlproperty index fill for image viewer */
    property url indexFill: rootPath+"index-fill.png"
    /*! \qmlproperty media playback play indicator */
    property url play: rootPath+"play.png"
    /*! \qmlproperty media playback pause indicator */
    property url pause: rootPath+"pause.png"

    /*! \qmlproperty default thumbnail icons to display when an item does not provide one */
    property var thumbs: ({"image": imageIcon, "audio": audioIcon, "video": videoIcon, "document": documentIcon})


    /*-------------Font-------------*/

    property var titleFont: ({ color:color1, size:74, weight:Font.Bold, capitalization:Font.AllUppercase, wrapMode: Text.NoWrap, textFormat: Text.AutoText, family: roboto.name })
    property var headerFont: ({ color:color1, size:11, weight:Font.Normal, capitalization:Font.AllUppercase, wrapMode: Text.NoWrap, textFormat: Text.AutoText, family: roboto.name })
    property var settingFont: ({ color:color1, size:11, weight:Font.Normal, capitalization:Font.MixedCase, wrapMode: Text.Wrap, textFormat: Text.AutoText, family: roboto.name })
    property var tagFont: ({ color:color1, size:11, weight:Font.Normal, capitalization:Font.AllUppercase, wrapMode: Text.NoWrap, textFormat: Text.AutoText, family: roboto.name })
    property var metadataFont: ({ color:"black", size:15, weight:Font.Normal, capitalization:Font.MixedCase, wrapMode: Text.Wrap, textFormat: Text.AutoText, family: roboto.name})
    property var filterFont: ({ color:"white", size:11, weight:Font.Normal, capitalization:Font.AllUppercase, wrapMode: Text.Wrap, textFormat: Text.RichText, family: roboto.name})
    property var infoTitleFont: ({ color:"black", size:16, weight:Font.Bold, capitalization:Font.AllUppercase, wrapMode: Text.NoWrap, textFormat: Text.AutoText, family: roboto.name })
    property var infoSourceFont: ({ color:"black", size:10, weight:Font.Normal, capitalization:Font.MixedCase, wrapMode: Text.NoWrap, textFormat: Text.AutoText, family: roboto.name })
    property var playbackTimeFont: ({ color:"white", size:11, weight:Font.Normal, capitalization:Font.MixedCase, wrapMode: Text.NoWrap, textFormat: Text.AutoText, family: roboto.name })
    property var instructionsFont: ({ color:color1, size:10, weight:Font.Normal, capitalization:Font.MixedCase, wrapMode: Text.Wrap, textFormat: Text.AutoText, family: roboto.name })

    FontLoader
    {
        id: roboto
        source: "content/font/Roboto/Roboto-Regular.ttf"
    }
}
