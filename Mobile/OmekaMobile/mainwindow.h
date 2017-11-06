#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QObject>



class MainWindow : public QMainWindow
{
    Q_OBJECT


public:

    explicit MainWindow(QWidget *parent = 0);

    static MainWindow *Instance;

    Q_INVOKABLE Qt::ScreenOrientation getInitialOrientation();


public slots:
    void orientationChanged(Qt::ScreenOrientation orientation);




};

#endif // MAINWINDOW_H
