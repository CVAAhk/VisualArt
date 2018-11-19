TEMPLATE = app

QT += qml quick\
    xml svg

QTPLUGIN += qsqlite

CONFIG += c++11 \
    qzxing_qml \
    qzxing_multimedia

SOURCES += main.cpp \
    shareutils.cpp \
    applicationloader.cpp \
    sequentialguid.cpp \
    qutils.cpp \
    quickmaker.cpp \
    mainwindow.cpp

HEADERS += \
    shareutils.h \
    applicationloader.h \
    sequentialguid.h \
    qutils.h \
    quickmaker.h \
    mainwindow.h

RESOURCES += qml.qrc

OTHER_FILES += \
    main.qml \
    qml/test/scalability/ApplicationWindowTest.qml \
    qml/js/UI.js \
    qml/js/+android/UI.js \
    qml/js/+ios/UI.js \

# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH += \
#    qml/test/styling/Style 1.0 \
#    qml/utils/Omeka 1.0 \
#    qml/utils/Heist 1.0 \
#    qml/utils/Resolution 1.0 \
#    qml/utils/Style 1.0 \
#    qml/utils/ItemManager 1.0 \
#    qml/utils/User 1.0 \
#    qml/utils/NumberUtils 1.0 \
#    qml/utils/Foreground 1.0 \

ios {
    OBJECTIVE_SOURCES += ios/iosshareutils.mm
    HEADERS += ios/iosshareutils.h

    Q_ENABLE_BITCODE.name = ENABLE_BITCODE
    Q_ENABLE_BITCODE.value = NO
    QMAKE_MAC_XCODE_SETTINGS += Q_ENABLE_BITCODE
}

android {
    QT += androidextras
    OTHER_FILES += android_data/src/com/lasconic/QShareUtils.java
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android_data
    SOURCES += android/androidshareutils.cpp
    HEADERS += android/androidshareutils.h
}

# Default rules for deployment.
include(deployment.pri)
include(qzxing/QZXing.pri)

DISTFILES += \
    qml/test/scalability/HomePage.qml \
    qml/test/scalability/SearchPage.qml \
    qml/test/scalability/LikesPage.qml \
    qml/test/scalability/PathViewTest.qml \
    qml/test/mvc/PathViewTest.qml \
    qml/test/mvc/ContactModel.qml \
    qml/test/mvc/GridViewTest.qml \
    qml/test/providers/ImageProviderApp.qml \
    qml/test/client/TestClient.qml \
    qml/test/settings/LikesTest.qml \
    qml/js/storage.js \
    qml/js/qqr.js \
    qml/test/navigation/Carousel.qml \
    qml/test/navigation/Ellipse.qml \
    qml/test/mvc/ListViewTest.qml \
    qml/test/viewers/ImageViewer.qml \
    qml/test/viewers/VideoViewer.qml \
    qml/test/viewers/AudioViewer.qml \
    qml/test/styling/StylingTest.qml \
    qml/test/styling/Style.qml \
    qml/test/styling/qmldir \
    qml/test/styling/TitleText.qml \
    qml/utils/ResolutionManager.qml \
    qml/utils/Style.qml \
    qml/app/home/Home.qml \
    qml/app/detail/Detail.qml \
    qml/app/home/gallery/Gallery.qml \
    qml/app/home/settings/BrandBar.qml \
    qml/app/clients/OmekaClient.qml \
    qml/app/home/gallery/OmekaItem.qml \
    qml/app/home/settings/Settings.qml \
    qml/app/likes/Likes.qml \
    qml/app/home/gallery/Browser.qml \
    qml/app/home/gallery/ItemBrowser.qml \
    qml/app/search/Search.qml \
    qml/utils/ItemManager.qml \
    qml/app/base/OmekaToolBar.qml \
    qml/app/base/OmekaButton.qml \
    qml/app/base/OmekaText.qml \
    qml/app/detail/DetailContent.qml \
    qml/app/detail/DetailToolbar.qml \
    qml/app/base/OmekaScrollView.qml \
    qml/app/detail/viewers/MediaViewer.qml \
    qml/app/detail/ScaleColumn.qml \
    qml/app/detail/DetailColumn.qml \
    qml/app/detail/viewers/ImageViewer.qml \
    qml/app/base/OmekaViewer.qml \
    qml/app/detail/viewers/VideoViewer.qml \
    qml/app/detail/viewers/AudioViewer.qml \
    qml/app/detail/viewers/MediaState.qml \
    qml/app/detail/viewers/PlaybackViewer.qml \
    qml/app/detail/viewers/controls/ProgressTimer.qml \
    qml/app/detail/viewers/controls/Scrubber.qml \
    qml/app/styles/ScrubberStyle.qml \
    qml/app/PageButton.qml \
    qml/app/styles/PageButtonStyle.qml \
    qml/app/PageNavigationBar.qml \
    qml/app/PageNavigation.qml \
    qml/app/PageState.qml \
    qml/app/home/settings/Setting.qml \
    qml/utils/UserSettings.qml \
    qml/app/home/settings/LayoutSetting.qml \
    qml/app/home/settings/ClearLikesSetting.qml \
    qml/app/home/settings/AboutSetting.qml \
    qml/app/styles/SearchBarStyle.qml \
    qml/app/search/SearchResults.qml \
    qml/app/home/gallery/LikeButton.qml \
    qml/app/base/OmekaSearchField.qml \
    qml/app/search/TagSearch.qml \
    qml/app/search/TagDelegate.qml \
    qml/app/search/TagHeader.qml \
    qml/test/sharing/ShareTest.qml \
    qml/app/base/OmekaToggle.qml \
    qml/app/detail/viewers/controls/MediaControls.qml \
    qml/test/styling/OpacityMaskTest.qml \
    qml/app/home/gallery/InfoPanel.qml \
    qml/app/base/OmekaIndicator.qml \
    qml/app/detail/viewers/ImageZoom.qml \
    qml/app/home/gallery/Logo.qml \
    qml/utils/NumberUtils.qml \
    qml/app/detail/viewers/controls/PlaybackText.qml \
    qml/test/navigation/ImageNavigator.qml \
    qml/app/detail/viewers/ImageNav.qml \
    qml/app/styles/IndexStyle.qml \
    qml/app/detail/viewers/IndexIndicator.qml \
    qml/app/detail/LoadScreen.qml \
    qml/app/detail/viewers/controls/PlaybackIndicator.qml \
    qml/test/mvc/ColorPath.qml \
    qml/app/likes/LikesFilter.qml \
    qml/app/likes/FilterButton.qml \
    qml/app/likes/Filters.qml \
    qml/app/home/settings/pairing/PairSetting.qml \
    qml/app/home/settings/pairing/TablePairing.qml \
    qml/app/home/settings/pairing/Unpair.qml \
    qml/app/clients/HeistClient.qml \
    qml/test/heist/TestHeist.qml \
    qml/test/heist/RequestUI.qml \
    qml/app/home/settings/pairing/HeistReceiver.qml \
    qml/app/clients/Pairings.qml \
    qml/test/heist/StateLabel.qml \
    qml/test/heist/ItemDelegate.qml \
    qml/app/FloatMessage.qml \
    qml/utils/Foreground.qml \
    qml/test/providers/ImageSizeTest.qml \
    qml/app/likes/NumberTag.qml \
    qml/test/qr/QRTest.qml \
    qml/test/navigation/PageNavTest.qml \
    qml/test/navigation/FirstPage.qml \
    qml/test/navigation/SecondPage.qml \
    qml/app/home/settings/pairing/QRScanner.qml \
    qml/app/home/settings/EndpointsSetting.qml \
    qml/app/home/settings/EndpointsEditing.qml \
    qml/app/home/settings/Endpoints.qml \
    android_data/AndroidManifest.xml \
    android_data/gradle/wrapper/gradle-wrapper.jar \
    android_data/gradlew \
    android_data/res/values/libs.xml \
    android_data/build.gradle \
    android_data/gradle/wrapper/gradle-wrapper.properties \
    android_data/gradlew.bat


contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/../openssl/armeabi-v7a/lib/libcrypto.so \
        $$PWD/../openssl/armeabi-v7a/lib/libssl.so
}






