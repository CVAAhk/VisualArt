#pragma once

#include <QObject>
#include <QQmlApplicationEngine>

class ApplicationLoader: public QObject
{
    public:
        ApplicationLoader();
        void load();

    private:
        QQmlApplicationEngine m_engine;
};

