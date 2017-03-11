#pragma once

#include <QList>
#include <QObject>

class CollectionSet;
class CollectionEntryInfo;

class Collections : public QObject
{
    Q_OBJECT
public:

    Q_PROPERTY(int collectionsOptionsCount READ getCollectionsCount CONSTANT)

    explicit Collections(QObject *parent = 0);

    Q_INVOKABLE QString getCollectionOption(int index) const;

    Q_INVOKABLE QString getNextImage(int set) const;

    Q_INVOKABLE float getNextImageBaseWidth(int set) const;

    Q_INVOKABLE float getNextImageBaseHeight(int set) const;

    Q_INVOKABLE float getNextImageWidth(int set, int base_height) const;

    Q_INVOKABLE float getNextImageHeight(int set, int base_width) const;

    Q_INVOKABLE QString getNextImageCollection(int set) const;

    Q_INVOKABLE QString getImageTitle(QString source) const;

    Q_INVOKABLE QString getImageDate(QString source) const;

    Q_INVOKABLE QString getImageArtist(QString source) const;

    Q_INVOKABLE QString getImageDescription(QString source) const;

    bool parseContentFolder(int set_number, QString collection_name, QString folder_path);

    bool parseFolder(QString folder_path, bool recursive);

    int getCollectionsCount() const;

signals:

public slots:

private:

    bool makeTempFolder(QString temp_name);

    bool parseCsvs(QStringList paths);

    bool parseCsv(QString path, QList<CollectionEntryInfo*> &all_entries);

    CollectionEntryInfo *getEntry(QString source) const;

    QString m_temp_folder;

    QList<CollectionSet*> m_collections_sets;
};
