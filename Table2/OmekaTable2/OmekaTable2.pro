QT += qml quick widgets network

CONFIG += c++11

SOURCES += main.cpp \
    applicationloader.cpp \
    asyncimageprovider.cpp \
    artcollection.cpp \
    collectionentryinfo.cpp \
    collections.cpp \
    collectionset.cpp

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += \
    Omeka 1.0 \

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    applicationloader.h \
    asyncimageprovider.h \
    artcollection.h \
    collectionentryinfo.h \
    collections.h \
    collectionset.h

DISTFILES += \
    main.qml \
    OmekaClient.qml \
    settings.js \
    qmldir \
    ItemManager.qml \
    Browser.qml \
    Gallery.qml \
    ImageDisplayRow.qml \
    CollectionImageHolder.qml \
    TouchHelpers/ClickableButton.qml \
    TouchHelpers/MultiPointPinchArea.qml \
    ScrollBar.qml \
    OmekaText.qml \
    ScaleColumn.qml \
    DetailColumn.qml \
    Detail.qml \
    OmekaScrollView.qml \
    Carousel.qml \
    OmekaIndicator.qml \
    TouchToBegin.qml \
    AttractImageItem.qml \
    AttractPoolItem.qml \
    TagDelegate.qml \
    TagHeader.qml \
    TagSearch.qml \
    Filter.qml \
    DetailContent.qml \
    LoadScreen.qml \
    MediaViewer.qml \
    ThumbnailViewer.qml \
    OmekaViewer.qml \
    MediaControls.qml \
    PlaybackIndicator.qml \
    ImageViewer.qml \
    AudioViewer.qml \
    PlaybackViewer.qml \
    ImageNav.qml \
    IndexIndicator.qml \
    IndexStyle.qml \
    ImageZoom.qml \
    MediaState.qml \
    VideoViewer.qml \
    Scrubber.qml \
    PlaybackText.qml \
    ProgressTimer.qml \
    ScrubberStyle.qml \
    NumberUtils.qml \
    FilterAlpha.qml

RESOURCES += \
    qml.qrc



