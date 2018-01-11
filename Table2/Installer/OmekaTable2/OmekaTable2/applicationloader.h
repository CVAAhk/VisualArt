#pragma once

#include <QObject>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQuickView>
#include "sequentialguid.h"
#include "qutils.h"

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

    void viewStatusChanged(QQuickView::Status status);

private:

    QQuickView m_engine;

    // QQmlApplicationEngine m_engine;

    QObject *m_main_window_object;

    QString m_install_path;
    SequentialGUID m_guid;
    QUtils m_utils;

};
