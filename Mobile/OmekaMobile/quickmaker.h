#ifndef QUICKMAKER_H
#define QUICKMAKER_H

#include <QObject>
#include <QVariant>

class QuickMaker : public QObject
{
    Q_OBJECT

public:
    explicit QuickMaker(QObject *parent = 0);

    static QuickMaker *Instance;

signals:

    void orientationChanged(Qt::ScreenOrientation orientation);

};

#endif // QUICKMAKER_H
