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
    ImageProviderTest *imageProvider = new ImageProviderTest(QQmlImageProviderBase::Image);
    engine.addImageProvider(QLatin1String("testprovider"), imageProvider);
    engine.load(QUrl("qrc:/qml/test/sharing/ShareTest.qml"));
    return app.exec();
}
