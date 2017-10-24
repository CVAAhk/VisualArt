#include "quickmaker.h"

/* send signals to QML*/
QuickMaker *QuickMaker::Instance = nullptr;

QuickMaker::QuickMaker(QObject *parent) : QObject(parent)
{
    Instance = this;
}
