#include "applicationloader.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QLoggingCategory>

ApplicationLoader::ApplicationLoader()
{

}

void ApplicationLoader::load()
{    
    QLoggingCategory::setFilterRules("qt.network.ssl.warning=false");

    m_engine.rootContext()->setContextProperty("guid", &m_guid);
    m_engine.rootContext()->setContextProperty("qutils", &m_utils);
    m_engine.load(QUrl("qrc:/qml/test/navigation/PageNavTest.qml"));
    //m_engine.load(QUrl("qrc:/main.qml"));
}
