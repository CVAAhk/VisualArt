#include "collectionset.h"

#include "artcollection.h"
#include "collectionentryinfo.h"

CollectionSet::CollectionSet(QObject *parent) : QObject(parent),
    m_current_image_index(-1)
{

}

QString CollectionSet::getCollectionOption(int index) const
{
    if(index <= 0 || index - 1 >= m_collections.size())
    {
        return "ALL CATEGORIES";
    }

    return m_collections.at(index - 1)->getName();
}

QString CollectionSet::getNextImage() const
{
    if(m_images.isEmpty())
    {
        return "";
    }

    m_current_image_index++;
    if(m_current_image_index >= m_images.size())
    {
        return "";
    }

    QString image = "image://async/" + m_images.at(m_current_image_index)->getFullFilenameBase();


    if(m_current_image_index >= m_images.size())
    {
        // m_current_image_index = 0;
        // return "";
    }

    return image;
}

float CollectionSet::getNextImageBaseWidth() const
{
    if(m_images.isEmpty())
    {
        return 0.0;
    }

    if(m_current_image_index >= m_images.size())
    {
        return 0.0;
    }

    return m_images[m_current_image_index]->getWidth();
}

float CollectionSet::getNextImageBaseHeight() const
{
    if(m_images.isEmpty())
    {
        return 0.0;
    }

    if(m_current_image_index >= m_images.size())
    {
        return 0.0;
    }

    return m_images[m_current_image_index]->getHeight();
}

float CollectionSet::getNextImageWidth(int base_height) const
{
    if(m_images.isEmpty())
    {
        return 0.0;
    }

    if(m_current_image_index >= m_images.size())
    {
        return 0.0;
    }

    const float image_width = m_images[m_current_image_index]->getWidth();
    const float image_height = m_images[m_current_image_index]->getHeight();

    const float height_scale = base_height / image_height;

    return image_width * height_scale;

}

float CollectionSet::getNextImageHeight(int base_width) const
{
    if(m_images.isEmpty())
    {
        return 0.0;
    }

    if(m_current_image_index >= m_images.size())
    {
        return 0.0;
    }

    const float image_width = m_images[m_current_image_index]->getWidth();
    const float image_height = m_images[m_current_image_index]->getHeight();

    const float width_scale = base_width / image_width;

    return image_height * width_scale;
}

QString CollectionSet::getNextImageCollection() const
{
    if(m_images.isEmpty())
    {
        return "";
    }

    if(m_current_image_index >= m_images.size())
    {
        return "";
    }

    return m_images[m_current_image_index]->getCollection();
}

void CollectionSet::loadEntries(QList<CollectionEntryInfo*> all_entries)
{
    for(int i = 0; i != all_entries.size(); ++i)
    {
        CollectionEntryInfo *entry = all_entries.at(i);

        ArtCollection *collection = getCollection(entry->getCollection());
        if(!collection)
        {
            collection = new ArtCollection(entry->getCollection());
            m_collections.push_back(collection);
        }

        collection->addImage(entry);
    }

    for(int i = 0; i != m_collections.size(); ++i)
    {
        ArtCollection *collection = m_collections.at(i);

        collection->updateCollectionEntries();

        if(!collection->isValid())
        {
            continue;
        }

        collection->addImagesToList(m_images);
    }
}

ArtCollection* CollectionSet::getCollection(QString name) const
{
    for(int i = 0; i != m_collections.size(); ++i)
    {
        if(m_collections.at(i)->getName() == name)
        {
            return m_collections.at(i);
        }
    }

    return nullptr;
}

CollectionEntryInfo* CollectionSet::getEntry(QString source) const
{
    for(int i = 0; i != m_collections.size(); ++i)
    {
        CollectionEntryInfo* entry = m_collections.at(i)->getEntry(source);

        if(entry)
        {
            return entry;
        }
    }

    return nullptr;
}
