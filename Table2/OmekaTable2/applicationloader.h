#pragma once

#include <QObject>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>

//class Settings;
class ApplicationLoader : public QObject
{
    Q_OBJECT
public:
    explicit ApplicationLoader(QObject *parent = 0);

    static ApplicationLoader *Instance;

    void load();

signals:

public slots:
    void objectCreated(QObject * object, const QUrl & url);

private:

    //Settings *m_settings;

    QQmlApplicationEngine m_engine;

    QQuickWindow *m_main_window_object;

    QString m_install_path;
};
