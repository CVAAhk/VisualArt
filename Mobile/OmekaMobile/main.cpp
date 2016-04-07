#include <QQmlApplicationEngine>
#include <QSurfaceFormat>
#include <QGuiApplication>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    if (QCoreApplication::arguments().contains(QLatin1String("--coreprofile"))) {
        QSurfaceFormat fmt;
        fmt.setVersion(4, 4);
        fmt.setProfile(QSurfaceFormat::CoreProfile);
        QSurfaceFormat::setDefaultFormat(fmt);
    }
    QQmlApplicationEngine engine(QUrl("qrc:/qml/test/mvc/GridViewTest.qml"));
    return app.exec();
}
