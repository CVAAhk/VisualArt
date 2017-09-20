#include "qutils.h"
#include <QUrl>

QUtils::QUtils()
{

}
QUtils::~QUtils()
{

}

QString QUtils::getHost(const QString &url)
{
    QUrl m_url(url);
    return m_url.host();
}

QString QUtils::getPath(const QString &url)
{
    QUrl m_url(url);
    return m_url.path();
}
