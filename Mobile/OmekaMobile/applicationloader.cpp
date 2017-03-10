#include "applicationloader.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>

ApplicationLoader::ApplicationLoader()
{

}

void ApplicationLoader::load()
{
    m_engine.rootContext() ->setContextProperty("heist", &m_heist);
    m_engine.load(QUrl("qrc:/main.qml"));
}
