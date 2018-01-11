#include <QApplication>
#include <QQmlApplicationEngine>
#include <QZXing.h>
#include "applicationloader.h"

#pragma comment(lib, "user32.lib")

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.processEvents();
    app.setQuitOnLastWindowClosed(true);

    QZXing::registerQMLTypes();

    ApplicationLoader app_loader;
    app_loader.load();

    return app.exec();
}
