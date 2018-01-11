#pragma once

#include <QObject>

class ArtCollection;
class CollectionEntryInfo;

class CollectionSet : public QObject
{
    Q_OBJECT
public:
    explicit CollectionSet(QObject *parent = 0);

    Q_INVOKABLE QString getCollectionOption(int index) const;

    Q_INVOKABLE QString getNextImage() const;

    Q_INVOKABLE float getNextImageBaseWidth() const;

    Q_INVOKABLE float getNextImageBaseHeight() const;

    Q_INVOKABLE float getNextImageWidth(int base_height) const;

    Q_INVOKABLE float getNextImageHeight(int base_width) const;

    Q_INVOKABLE QString getNextImageCollection() const;

    void loadEntries(QList<CollectionEntryInfo*> all_entries);

    ArtCollection* getCollection(QString name) const;

    CollectionEntryInfo *getEntry(QString source) const;

    inline int getCollectionsCount() const;

signals:

public slots:

private:

    QList<ArtCollection*> m_collections;

    QList<CollectionEntryInfo*> m_images;

    mutable int m_current_image_index;
};

int CollectionSet::getCollectionsCount() const
{
    return m_collections.size();
}
