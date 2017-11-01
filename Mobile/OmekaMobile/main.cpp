#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QZXing.h>
#include <QApplication>

#include "shareutils.h"
#include "applicationloader.h"
#include "quickmaker.h"

int main(int argc, char *argv[])
{
    //QGuiApplication app(argc, argv);

    QApplication app(argc, argv);
    app.processEvents();
    app.setQuitOnLastWindowClosed(true);

    qmlRegisterType<QuickMaker>("Maker", 1, 0, "QuickMaker");

    qmlRegisterType<ShareUtils> ("com.lasconic", 1, 0, "ShareUtils");
    QZXing::registerQMLTypes();

    ApplicationLoader app_loader;
    app_loader.load();

    return app.exec();
}
