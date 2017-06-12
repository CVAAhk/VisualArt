#include <QQmlApplicationEngine>
#include <QSurfaceFormat>
#include <QGuiApplication>
#include <QZXing.h>
#include "shareutils.h"
#include "applicationloader.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Ideum");
    app.setOrganizationDomain("ideum.com");
    app.setApplicationName("OmekaMobile");

    qmlRegisterType<ShareUtils> ("com.lasconic", 1, 0, "ShareUtils");
    QZXing::registerQMLTypes();

    if (QCoreApplication::arguments().contains(QLatin1String("--coreprofile"))) {
        QSurfaceFormat fmt;
        fmt.setVersion(4, 4);
        fmt.setProfile(QSurfaceFormat::CoreProfile);
        QSurfaceFormat::setDefaultFormat(fmt);
    }

    ApplicationLoader app_loader;
    app_loader.load();

    return app.exec();
}
