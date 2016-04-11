#include "imageprovidertest.h"
#include <QImage>
#include <QPixmap>
#include <QUrl>
#include <QNetworkReply>
#include <QEventLoop>

ImageProviderTest::ImageProviderTest(ImageType type, Flags flags):QQuickImageProvider(type, flags)
{
    manager = new QNetworkAccessManager;
}

ImageProviderTest::~ImageProviderTest()
{
    delete manager;
}

QImage ImageProviderTest::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    qDebug(id.toLatin1());
    QUrl url("http://mallhistory.org//files//original//0ef6913467dd1ef22e66e2c0b2cb63ae.jpg");
    QNetworkReply* reply = manager->get(QNetworkRequest(url));
    QEventLoop eventLoop;
    QObject::connect(reply, SIGNAL(finished()), &eventLoop, SLOT(quit()));
    eventLoop.exec();
    if(reply->error() != QNetworkReply::NoError)
        return QImage();
    QImage image = QImage::fromData(reply->readAll());
    size->setWidth(image.width());
    size->setHeight(image.height());
    return image;
}
