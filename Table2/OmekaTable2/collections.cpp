#include "collections.h"

#include "collectionset.h"
#include "artcollection.h"
#include "collectionentryinfo.h"

#include <QFileInfo>
#include <QDirIterator>
#include <QStandardPaths>
#include <QMessageBox>
#include <QDebug>

Collections::Collections(QObject *parent) : QObject(parent)
{
    makeTempFolder("collections");

    const int default_count = 4;
    for(int i = 0; i != default_count; i++)
    {
        CollectionSet *default_collection = new CollectionSet;
        m_collections_sets.push_back(default_collection);
    }
}

QString Collections::getCollectionOption(int index) const
{
    if(m_collections_sets.empty())
    {
        return "";
    }

    return m_collections_sets.at(0)->getCollectionOption(index);
}

QString Collections::getNextImage(int set) const
{
    if(set < 0 || set >= m_collections_sets.size()) { return ""; }

    return m_collections_sets.at(set)->getNextImage();
}

float Collections::getNextImageBaseWidth(int set) const
{
    if(set < 0 || set >= m_collections_sets.size()) { return 0.0f; }

    return m_collections_sets.at(set)->getNextImageBaseWidth();
}

float Collections::getNextImageBaseHeight(int set) const
{
    if(set < 0 || set >= m_collections_sets.size()) { return 0.0f; }

    return m_collections_sets.at(set)->getNextImageBaseHeight();
}

float Collections::getNextImageWidth(int set, int base_height) const
{
    if(set < 0 || set >= m_collections_sets.size()) { return 0.0f; }

    return m_collections_sets.at(set)->getNextImageWidth(base_height);
}

float Collections::getNextImageHeight(int set, int base_width) const
{
    if(set < 0 || set >= m_collections_sets.size()) { return 0.0f; }

    return m_collections_sets.at(set)->getNextImageHeight(base_width);
}

QString Collections::getNextImageCollection(int set) const
{
    if(set < 0 || set >= m_collections_sets.size()) { return ""; }

    return m_collections_sets.at(set)->getNextImageCollection();
}

QString Collections::getImageTitle(QString source) const
{
    CollectionEntryInfo *entry = getEntry(source);
    return entry ? entry->getTitle() : "";
}

QString Collections::getImageDate(QString source) const
{
    CollectionEntryInfo *entry = getEntry(source);
    return entry ? entry->getDate() : "";
}

QString Collections::getImageArtist(QString source) const
{
    CollectionEntryInfo *entry = getEntry(source);
    return entry ? entry->getArtist() : "";
}

QString Collections::getImageDescription(QString source) const
{
    CollectionEntryInfo *entry = getEntry(source);
    return entry ? entry->getDescription() : "";
}

CollectionEntryInfo* Collections::getEntry(QString source) const
{
    for(int i = 0; i != m_collections_sets.size(); ++i)
    {
        CollectionEntryInfo *entry =
                m_collections_sets.at(i)->getEntry(source);

        if(entry)
        {
            return entry;
        }
    }

    return nullptr;
}

bool Collections::parseContentFolder(int set_number, QString collection_name, QString folder_path)
{
    if(!QFileInfo(folder_path).exists())
    {
        QMessageBox::warning(nullptr, "Could not find content folders",
                             "Could not find collections folder: " + folder_path);

        return false;
    }

    QDir directory(folder_path);
    directory.setFilter(QDir::Files | QDir::NoSymLinks | QDir::NoDot | QDir::NoDotDot);

    QStringList filters;
    filters << "*.png" << "*.jpeg";
    directory.setNameFilters(filters);

    QDirIterator iterator(directory, QDirIterator::NoIteratorFlags);

    QList<CollectionEntryInfo*> collection_entries;

    while (iterator.hasNext())
    {
        QString path = iterator.next();

        CollectionEntryInfo *collection_entry_info = new CollectionEntryInfo();
        collection_entry_info->setFilename(path);
        collection_entry_info->setCollection(collection_name);

        collection_entries.push_back(collection_entry_info);
    }

    CollectionSet *set = m_collections_sets[set_number];
    set->loadEntries(collection_entries);

    return true;
}

bool Collections::parseFolder(QString folder_path, bool recursive)
{
    if(!QFileInfo(folder_path).exists())
    {
        QMessageBox::warning(nullptr, "Could not find content folders",
                             "Could not find collections folder: " + folder_path);

        return false;
    }

    QDir directory(folder_path);
    directory.setFilter(QDir::Files | QDir::NoSymLinks | QDir::NoDot | QDir::NoDotDot);

    QStringList filters;
    filters.append("*.csv");
    directory.setNameFilters(filters);

    QDirIterator iterator(directory,
                          recursive ?
                              QDirIterator::Subdirectories :
                              QDirIterator::NoIteratorFlags);

    QStringList paths;

    while (iterator.hasNext())
    {
        QString csv_path = iterator.next();
        paths.push_back(csv_path);
    }

    return parseCsvs(paths);
}

bool Collections::parseCsvs(QStringList paths)
{
    QList<CollectionEntryInfo*> all_entries;

    for(int i = 0; i != paths.size(); ++i)
    {
        QString path = paths.at(i);

        parseCsv(path, all_entries);
    }

    for(int j = 0; j != m_collections_sets.size(); ++j)
    {
        m_collections_sets[j]->loadEntries(all_entries);
    }

    return true;
}

bool Collections::parseCsv(QString path, QList<CollectionEntryInfo*> &all_entries)
{
    /*
    const bool adult_mode_on = DataGeneralSettings::Instance->getAdultMode();
    QList<CollectionEntryInfo*> entries = CollectionInfoParser::parseCollectionInfo(path, adult_mode_on);

    for(int i = 0; i != entries.size(); ++i)
    {
        all_entries.push_back(entries[i]);
    }

    return !entries.empty();
    */

    qWarning() << "Collections::parseCSV is not supported yet";

    return false;
}

bool Collections::makeTempFolder(QString temp_name)
{
    QString base_folder =  m_temp_folder =  QStandardPaths::writableLocation(QStandardPaths::PicturesLocation) +
            QStringLiteral("/Ideum Temp/");

    if(!QFileInfo(base_folder).exists())
    {
        QDir().mkdir(base_folder);

         if(!QFileInfo(base_folder).exists())
         {
             return false;
         }
    }

    m_temp_folder = base_folder + temp_name + QStringLiteral("/");

    if(!QFileInfo(m_temp_folder).exists())
    {
        QDir().mkdir(m_temp_folder);

        if(!QFileInfo(m_temp_folder).exists())
        {
            m_temp_folder =  QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
        }
    }

    return QFileInfo(m_temp_folder).exists();
}

int Collections::getCollectionsCount() const
{
    if(m_collections_sets.empty())
    {
        return 0;
    }

    return m_collections_sets[0]->getCollectionsCount();
}
