#pragma once

#include <QObject>
#include <QQmlApplicationEngine>
#include "heist.h"

class ApplicationLoader: public QObject
{
    public:
        ApplicationLoader();
        void load();

    private:
        Heist m_heist;
        QQmlApplicationEngine m_engine;
};

