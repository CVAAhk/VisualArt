#include "mainwindow.h"
#include "quickmaker.h"

#include <QGuiApplication>
#include <QScreen>


/* Anthing needs to use Qt Widgets has to define in this class*/
MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    QScreen *screen = QGuiApplication::primaryScreen();

    screen->setOrientationUpdateMask(Qt::LandscapeOrientation| Qt::PortraitOrientation | Qt::InvertedLandscapeOrientation | Qt::InvertedPortraitOrientation);

    connect(screen, SIGNAL(orientationChanged(Qt::ScreenOrientation)),
                   this, SLOT(orientationChanged(Qt::ScreenOrientation)));

}
void MainWindow::orientationChanged(Qt::ScreenOrientation orientation)
{
    if(QuickMaker *quick_maker = QuickMaker::Instance)
    {
        quick_maker->orientationChanged(orientation);
    }
}

Qt::ScreenOrientation MainWindow::getInitialOrientation()
{
    QScreen *screen = QGuiApplication::primaryScreen();
    return screen->orientation();
}
