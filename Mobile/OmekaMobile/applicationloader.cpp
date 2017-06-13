#include "applicationloader.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>

ApplicationLoader::ApplicationLoader()
{

}

void ApplicationLoader::load()
{
    m_engine.rootContext()->setContextProperty("guid", &m_guid);
    m_engine.rootContext()->setContextProperty("qutils", &m_utils);
    //m_engine.load(QUrl("qrc:/qml/test/heist/TestHeist.qml"));
    m_engine.load(QUrl("qrc:/main.qml"));
}
