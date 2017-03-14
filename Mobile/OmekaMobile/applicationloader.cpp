#include "applicationloader.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>

ApplicationLoader::ApplicationLoader()
{

}

void ApplicationLoader::load()
{
    m_engine.load(QUrl("qrc:/qml/test/heist/TestHeist.qml"));
    //m_engine.load(QUrl("qrc:/main.qml"));
}
