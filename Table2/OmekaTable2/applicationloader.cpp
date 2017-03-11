#include "applicationloader.h"


#include "asyncimageprovider.h"

//#include "screencapture.h"
#include "collections.h"
//#include "imagemanager.h"

#include <QMessageBox>
#include <QQmlContext>
#include <QQmlEngine>
#include <QFileInfo>
#include <QDir>
#include <QDebug>

ApplicationLoader *ApplicationLoader::Instance = nullptr;

ApplicationLoader::ApplicationLoader(QObject *parent) : QObject(parent),
    m_main_window_object(nullptr)
{
    Instance = this;
}

void ApplicationLoader::load()
{
    AsyncImageProvider *image_provider = new AsyncImageProvider;

    m_engine.addImageProvider("async", image_provider);

    //qmlRegisterType<ImageManager>("IdeumImage", 1, 0, "ImageManager");

    m_install_path = QFileInfo(QDir::currentPath() + "\\..\\OmekaTable2\\").absolutePath() + "/";

    //m_settings = new Settings(m_install_path);
    //m_engine.rootContext()->setContextProperty("Settings", m_settings);

//    m_screen_capture = new ScreenCapture;
//    m_engine.rootContext()->setContextProperty("screenCapture", m_screen_capture);

//    m_content_settings = new Content(m_install_path);
//    m_engine.rootContext()->setContextProperty("ContentSettings", m_settings);

//    QList<Content::CollectionEntrySettings> collection_settings =
//            m_content_settings->getCollectionEntrySettings();

    Collections *collections = new Collections;
//    for(int i = 0; i != collection_settings.size(); ++i)
//    {
//        collections->parseContentFolder(i, collection_settings[i].collectionName,
//                                        m_install_path + collection_settings[i].collectionFolderPath);
//    }

    m_engine.rootContext()->setContextProperty("collections", collections);

    connect(&m_engine, &QQmlApplicationEngine::objectCreated,
            this, &ApplicationLoader::objectCreated);

    QString main_qml = m_install_path + "main.qml";

    if(!QFileInfo(main_qml).exists())
    {
        QMessageBox::warning(nullptr, "Could not find main.qml", "Could not find main.qml");
    }

    m_engine.load(main_qml);

    QObject::connect(&m_engine, SIGNAL(quit()), QCoreApplication::instance(), SLOT(quit()));

}

void ApplicationLoader::objectCreated(QObject *object, const QUrl &url)
{
    Q_UNUSED(url);

    m_main_window_object = object->findChild<QQuickWindow*>("mainWindow");

    //m_screen_capture->setQuickWindow(m_main_window_object);

//    m_image_manager = m_main_window_object->findChild<ImageManager*>("imageManager");
//    if(m_image_manager)
//    {
//        m_image_manager->loadPreviousImages();
//    }
}
