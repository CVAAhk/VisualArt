#include <QQmlApplicationEngine>
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

    ApplicationLoader app_loader;
    app_loader.load();

    return app.exec();
}
