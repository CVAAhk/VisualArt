#ifndef SEQUENTIALGUID_H
#define SEQUENTIALGUID_H

#include <QObject>
#include <QUuid>
#include <QByteArray>
#include <QDateTime>
#include <QDataStream>
#include <QTime>

class SequentialGUID: public QObject
{
    Q_OBJECT

    public:
        SequentialGUID();
        ~SequentialGUID();

    Q_INVOKABLE QString getSequentialGUID();

    private:
        static void InitRand();
        static int randInt(int low, int high);
        static bool rand_init;
};

#endif // SEQUENTIALGUID_H
