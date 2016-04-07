TEMPLATE = app

QT += qml quick
CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

OTHER_FILES += \
    main.qml \
    qml/test/ApplicationWindowTest.qml \
    qml/js/UI.js \
    qml/js/+android/UI.js \
    qml/js/+ios/UI.js \

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    qml/test/HomePage.qml \
    qml/test/SearchPage.qml \
    qml/test/LikesPage.qml
