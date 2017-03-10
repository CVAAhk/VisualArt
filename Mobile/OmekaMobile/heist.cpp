#include "heist.h"
#include "QDebug"

Heist::Heist()
{

}

Heist::~Heist()
{

}

void Heist::initialize(QString rest)
{
    url = rest;
}

void Heist::clearAllSessions()
{

}

void Heist::startPairingSession(QString code)
{

}

void Heist::endPairingSession(QString code)
{

}

bool Heist::sessionExists(QString code)
{
    return true;
}

bool Heist::deviceExists(QString code)
{
    return true;
}

void Heist::setDevice(QString code)
{

}

void Heist::addItem(QString code)
{

}

QString Heist::getItems(QString code)
{
    return code;
}
