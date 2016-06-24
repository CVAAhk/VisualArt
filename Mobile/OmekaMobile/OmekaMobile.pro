TEMPLATE = app

QT += qml quick\
    xml svg

QTPLUGIN += qsvg

CONFIG += c++11

SOURCES += main.cpp \
    cpp\test\imageprovidertest.cpp

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
    qml/app/home/settings/SettingsModel.qml \
    qml/app/home/settings/SettingsDelegate.qml \
    qml/utils/OmekaClient.qml \
    qml/app/home/gallery/OmekaItem.qml \
    qml/app/home/settings/Settings.qml \
    qml/app/likes/Likes.qml \
    qml/app/home/gallery/Browser.qml \
    qml/app/home/gallery/ItemBrowser.qml \
    qml/app/search/Search.qml \
    qml/app/search/SearchDelegate.qml \
    qml/utils/ItemManager.qml \
    qml/app/base/OmekaToolBar.qml \
    qml/app/base/OmekaButton.qml \
    qml/app/base/OmekaText.qml \
    qml/app/search/SearchHeader.qml \
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
    qml/app/detail/viewers/DocumentViewer.qml \
    qml/app/detail/viewers/MediaState.qml \
    qml/app/detail/viewers/PlaybackViewer.qml \
    qml/app/detail/viewers/ProgressTimer.qml \
    qml/app/detail/viewers/Scrubber.qml \
    qml/app/styles/ScrubberStyle.qml \
    qml/app/PageButton.qml \
    qml/app/styles/PageButtonStyle.qml \
    qml/app/PageNavigationBar.qml \
    qml/app/PageNavigation.qml \
    qml/app/PageState.qml

HEADERS += \
    imageprovidertest.h
