TEMPLATE = app

QT += qml quick
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
QML_IMPORT_PATH =

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
    qml/test/viewers/AudioViewer.qml

HEADERS += \
    imageprovidertest.h
