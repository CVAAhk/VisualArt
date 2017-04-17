#pragma once

#include <QObject>
#include <QString>
#include <QPixmap>
#include <QFileInfo>
#include <QVariantList>

class CollectionEntryInfo : public QObject
{
    Q_OBJECT
public:
    explicit CollectionEntryInfo(QObject *parent = 0);

signals:

public slots:

public:

    inline void setFilename(QString filename);
    inline QString getFilename() const;
    inline bool doesFileExist() const;
    inline QString getFullFilenameBase() const;
    inline QString getFullFilename() const;

    inline void setTitle(QString title);
    inline QString getTitle() const;

    inline void setDate(QString date);
    inline QString getDate() const;

    inline void setArtist(QString artist);
    inline QString getArtist() const;

    inline void setDescription(QString description);
    inline QString getDescription() const;

    inline void setCollection(QString collection);
    inline QString getCollection() const;

    inline int getWidth() const;
    inline int getHeight() const;

private:

    QString m_filename;

    QString m_title;

    QString m_date;

    QString m_artist;

    QString m_description;

    QString m_collection;

    int m_width, m_height;
};

void CollectionEntryInfo::setFilename(QString filename)
{
    m_filename = filename;

    QString base_path = getFullFilenameBase();
    QPixmap pixmap(base_path);

    if(!pixmap.isNull())
    {
        m_width = pixmap.width();
        m_height = pixmap.height();
    }
}

QString CollectionEntryInfo::getFilename() const
{
    return m_filename;
}

bool CollectionEntryInfo::doesFileExist() const
{
    return QFileInfo(getFullFilenameBase()).exists();
}

QString CollectionEntryInfo::getFullFilenameBase() const
{
    QString filename = m_filename;

    filename = filename.replace('\\', '/');

    return filename;
}

QString CollectionEntryInfo::getFullFilename() const
{
    return "file:///" + getFullFilenameBase();
}

void CollectionEntryInfo::setTitle(QString title)
{
    m_title = title;
}

QString CollectionEntryInfo::getTitle() const
{
    return m_title;
}

void CollectionEntryInfo::setDate(QString date)
{
    m_date = date;
}

QString CollectionEntryInfo::getDate() const
{
    return m_date;
}

void CollectionEntryInfo::setArtist(QString artist)
{
    m_artist = artist;
}

QString CollectionEntryInfo::getArtist() const
{
    return m_artist;
}

void CollectionEntryInfo::setDescription(QString description)
{
    m_description = description;
}

QString CollectionEntryInfo::getDescription() const
{
    return m_description;
}

void CollectionEntryInfo::setCollection(QString collection)
{
    m_collection = collection;
}

QString CollectionEntryInfo::getCollection() const
{
    return m_collection;
}

int CollectionEntryInfo::getWidth() const
{
    return m_width;
}

int CollectionEntryInfo::getHeight() const
{
    return m_height;
}
