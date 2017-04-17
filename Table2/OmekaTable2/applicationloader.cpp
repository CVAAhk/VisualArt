#include "applicationloader.h"

#include "asyncimageprovider.h"
#include "collections.h"

#include <QMessageBox>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickItem>
#include <QFileInfo>
#include <QDir>
#include <QLoggingCategory>
#include <QDebug>

static const bool FULLSCREEN = true;

ApplicationLoader *ApplicationLoader::Instance = nullptr;

ApplicationLoader::ApplicationLoader(QObject *parent) : QObject(parent),
    m_main_window_object(nullptr)
{
    Instance = this;
}

void ApplicationLoader::load()
{
    //  AsyncImageProvider *image_provider = new AsyncImageProvider;

    //  m_engine.addImageProvider("async", image_provider);

    QLoggingCategory::setFilterRules("qt.network.ssl.warning=false");

    m_install_path = QFileInfo(QDir::currentPath() + "\\..\\OmekaTable2\\").absolutePath() + "/";

    Collections *collections = new Collections;
    m_engine.rootContext()->setContextProperty("collections", collections);

    connect(&m_engine, &QQuickView::statusChanged, this, &ApplicationLoader::viewStatusChanged);

    QSurfaceFormat format = m_engine.format();
    format.setSamples(16);
    m_engine.setFormat(format);

    // connect(&m_engine, &QQmlApplicationEngine::objectCreated,
    //        this, &ApplicationLoader::objectCreated);

    QString main_qml = m_install_path + "main.qml";

    if(!QFileInfo(main_qml).exists())
    {
        QMessageBox::warning(nullptr, "Could not find main.qml", "Could not find main.qml");
    }

    m_engine.setSource(QUrl::fromLocalFile(main_qml));

    if(FULLSCREEN)
    {
        m_engine.showFullScreen();
    }
    else
    {
        m_engine.show();
    }

    QObject::connect(m_engine.rootContext()->engine(), SIGNAL(quit()), QCoreApplication::instance(), SLOT(quit()));
}

void ApplicationLoader::objectCreated(QObject *object, const QUrl &url)
{
    Q_UNUSED(url);

    m_main_window_object = object;
}

void ApplicationLoader::viewStatusChanged(QQuickView::Status status)
{
    if(status == QQuickView::Status::Ready)
    {
        QObject *main_window = m_engine.rootObject();

        objectCreated(main_window, QUrl());
    }
}
