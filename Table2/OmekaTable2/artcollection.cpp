#include "artcollection.h"

#include "collectionentryinfo.h"

#include <QFileInfo>
#include <QDebug>

ArtCollection::ArtCollection(QString name, QObject *parent) :
    m_name(name),
    QObject(parent),
    m_is_valid(false)
{
}

void ArtCollection::updateCollectionEntries()
{
    QList<CollectionEntryInfo*> entries;

    for(int i = 0; i != m_entries.size(); ++i)
    {
        CollectionEntryInfo *entry_info = m_entries.at(i);

        if(!entry_info)
        {
            continue;
        }

        QString path = entry_info->getFilename();
        if(!QFileInfo(path).exists())
        {
            qDebug() << "Warning could not process " <<
                        m_name << " collection image " << QFileInfo(path).absoluteFilePath();
        }
        else
        {
            entries.push_back(entry_info);
        }
    }

    m_entries = entries;

    m_is_valid = m_entries.size() > 0;
}

void ArtCollection::addImage(CollectionEntryInfo *image)
{
    m_entries.push_back(image);
}

void ArtCollection::addImagesToList(QList<CollectionEntryInfo*> &images)
{
    qDebug() << "Adding images to list " << images.size() << " " << m_name << " " << m_entries.size();

    for(int i = 0; i != m_entries.size(); ++i)
    {
        images.push_back(m_entries[i]);
    }
}

CollectionEntryInfo* ArtCollection::getEntry(QString source) const
{
    QString name = source.remove("image://async/");
    for(int i = 0; i != m_entries.size(); ++i)
    {
        if(m_entries[i]->getFullFilename().contains(name))
        {
            return m_entries[i];
        }
    }

    return nullptr;
}
