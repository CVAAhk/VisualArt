#pragma once

#include <QQuickAsyncImageProvider>
#include <QThreadPool>

class AsyncImageProvider : public QQuickAsyncImageProvider
{
public:
    AsyncImageProvider();

    virtual QQuickImageResponse *requestImageResponse(const QString &id, const QSize &requested_size) override;

private:

    QThreadPool m_pool;
};
