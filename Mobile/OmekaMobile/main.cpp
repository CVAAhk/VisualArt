#include <QQmlApplicationEngine>
#include <QSurfaceFormat>
#include <QGuiApplication>
#include "imageprovidertest.h"
#include "shareutils.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Ideum");
    app.setOrganizationDomain("ideum.com");
    app.setApplicationName("OmekaMobile");

    qmlRegisterType<ShareUtils> ("com.lasconic", 1, 0, "ShareUtils");

    if (QCoreApplication::arguments().contains(QLatin1String("--coreprofile"))) {
        QSurfaceFormat fmt;
        fmt.setVersion(4, 4);
        fmt.setProfile(QSurfaceFormat::CoreProfile);
        QSurfaceFormat::setDefaultFormat(fmt);
    }

    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/qml/test/client/TestHeist.qml"));
    return app.exec();
}
