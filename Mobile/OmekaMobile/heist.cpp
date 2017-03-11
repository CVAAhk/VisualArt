#include <QtNetwork>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

#include "heist.h"
#include "QDebug"

Heist::Heist()
{

}

Heist::~Heist()
{

}

void Heist::startRequest(QUrl url)
{
    reply = qnam.get(QNetworkRequest(url));
    connect(reply, SIGNAL(finished()), this, SLOT(httpFinished()));
}

void Heist::initialize(QString rest)
{
    url = rest;
    startRequest(QUrl(rest));
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

void Heist::httpFinished()
{
    if(reply->error() == QNetworkReply::NoError) {
        QString strReply = (QString)reply->readAll();
        qDebug() << "Response: " << strReply << endl;

        QJsonDocument jsonResponse = QJsonDocument::fromJson(strReply.toUtf8());
        QJsonArray jsonArray = jsonResponse.array();
        QJsonValue jsonValue = jsonArray[0];
        QJsonObject jsonObj = jsonValue.toObject();
        QVariantMap map = jsonObj.toVariantMap();

        qDebug() << jsonObj["\"id\""].toString();

        for(QVariantMap::const_iterator iter = map.begin(); iter != map.end(); ++iter) {
            qDebug() << iter.key() << iter.value();
        }


        delete reply;
    } else {
        qDebug() << reply->errorString() << endl;
        delete reply;
    }
}
