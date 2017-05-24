#ifndef QUTILS_H
#define QUTILS_H

#include <QObject>

class QUtils: public QObject
{
    Q_OBJECT

    public:
        QUtils();
        ~QUtils();

    Q_INVOKABLE QString getHost(const QString &url);
};

#endif // QUTILS_H
