TEMPLATE = app

QT += qml quick\
    xml svg

QTPLUGIN += qsqlite

CONFIG += c++11

SOURCES += main.cpp \
    shareutils.cpp \
    applicationloader.cpp \
    sequentialguid.cpp

HEADERS += \
    shareutils.h \
    applicationloader.h \
    sequentialguid.h

RESOURCES += qml.qrc

OTHER_FILES += \
    main.qml \
    qml/test/scalability/ApplicationWindowTest.qml \
    qml/js/UI.js \
    qml/js/+android/UI.js \
    qml/js/+ios/UI.js \

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += \
    qml/test/styling/Style 1.0 \
    qml/utils/Resolution 1.0 \
    qml/utils/Style 1.0 \
    qml/utils/Omeka 1.0 \
    qml/utils/ItemManager 1.0 \
    qml/utils/User 1.0 \
    qml/utils/NumberUtils 1.0 \
    qml/utils/HeistManager 1.0 \

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
    qml/utils/OmekaClient.qml \
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
    qml/app/home/settings/pairing/Keypad.qml \
    qml/app/home/settings/pairing/CodeEntry.qml \
    qml/app/home/settings/pairing/Unpair.qml \
    qml/utils/HeistManager.qml \
    qml/test/heist/TestHeist.qml \
    qml/test/heist/RequestUI.qml \
    qml/app/home/settings/pairing/HeistReceiver.qml
