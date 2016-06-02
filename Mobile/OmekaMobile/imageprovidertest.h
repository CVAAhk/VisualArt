#ifndef RESOURCEIMAGEPROVIDER_H
#define RESOURCEIMAGEPROVIDER_H

#include <QQuickImageProvider>
#include <QNetworkAccessManager>

class ImageProviderTest : public QQuickImageProvider
{
    public:
        ImageProviderTest(ImageType type, Flags flags = 0);
        ~ImageProviderTest();
        QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);
    protected:
        QNetworkAccessManager *manager;
};

#endif // RESOURCEIMAGEPROVIDER_H

