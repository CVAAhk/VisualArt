#include "asyncimageprovider.h"

#include <QDebug>
#include <QImage>
#include <QThreadPool>

class AsyncImageResponse : public QQuickImageResponse, public QRunnable
{
    public:
        AsyncImageResponse(const QString &id, const QSize &requestedSize)
         : m_id(id), m_requestedSize(requestedSize), m_texture(0)
        {
            setAutoDelete(false);
        }

        QQuickTextureFactory *textureFactory() const
        {
            return m_texture;
        }

        void run()
        {
            QImage image(m_id);
            m_texture = QQuickTextureFactory::textureFactoryForImage(image);
            emit finished();
        }

        QString m_id;
        QSize m_requestedSize;
        QQuickTextureFactory *m_texture;
};


AsyncImageProvider::AsyncImageProvider()
{

}

QQuickImageResponse* AsyncImageProvider::requestImageResponse(const QString &id, const QSize &requested_size)
{
    AsyncImageResponse *response = new AsyncImageResponse(id, requested_size);
    m_pool.start(response);
    return response;
}
