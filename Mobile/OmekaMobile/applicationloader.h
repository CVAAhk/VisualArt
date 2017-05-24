#pragma once

#include <QObject>
#include <QQmlApplicationEngine>
#include "sequentialguid.h"
#include "qutils.h"

class ApplicationLoader: public QObject
{
    public:
        ApplicationLoader();
        void load();

    private:
        QQmlApplicationEngine m_engine;
        SequentialGUID m_guid;
        QUtils m_utils;
};

