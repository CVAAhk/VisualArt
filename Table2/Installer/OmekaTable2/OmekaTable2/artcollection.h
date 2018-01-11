#pragma once

#include <QList>
#include <QObject>

class CollectionEntryInfo;

class ArtCollection : public QObject
{
    Q_OBJECT
public:
    explicit ArtCollection(QString name, QObject *parent = 0);

    void updateCollectionEntries();

    void addImage(CollectionEntryInfo *image);

    void addImagesToList(QList<CollectionEntryInfo*> &images);

    CollectionEntryInfo* getEntry(QString source) const;

    inline bool isValid() const;

    inline QString getName() const;

signals:

public slots:

private:

    QString m_name;

    QList<CollectionEntryInfo*> m_entries;

    bool m_is_valid;
};

bool ArtCollection::isValid() const
{
    return m_is_valid;
}

QString ArtCollection::getName() const
{
    return m_name;
}
