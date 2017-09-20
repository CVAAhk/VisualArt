#include "sequentialguid.h"

bool SequentialGUID::rand_init = false;

SequentialGUID::SequentialGUID()
{

}

SequentialGUID::~SequentialGUID()
{

}

void SequentialGUID::InitRand()
{
    if(!rand_init) {
        QTime t = QTime::currentTime();
        qsrand((uint)t.msec());
        rand_init = true;
    }
}

int SequentialGUID::randInt(int low, int high)
{
    InitRand();
    return qrand() % ((high+1) - low) + low;
}

QString SequentialGUID::getSequentialGUID()
{
    QByteArray randBytes;
    for(int i=0; i<10; i++) {
        char b = (char)randInt(0, 255);
        randBytes.append(b);
    }

    qint64 timestamp = QDateTime::currentMSecsSinceEpoch();
    QByteArray timestampBytes;
    timestampBytes.resize(sizeof(timestamp));
    QByteArray timestampBytesRev;
    timestampBytesRev.resize(sizeof(timestamp));

    char *ptr = (char *)&timestamp;
    for(int i=0; i<8; i++) {
        timestampBytes[i] = ptr[i];
        timestampBytesRev[7-i] = ptr[i];
    }

    timestampBytes.remove(6,2);
    timestampBytesRev.remove(0,2);

    QByteArray tsBytes;
#if Q_BYTE_ORDER == Q_LITTLE_ENDIAN
    tsBytes = timestampBytesRev;
#else
    tsBytes = timestampBytes;
#endif

    QByteArray guidBytes;
    guidBytes.append(tsBytes);
    guidBytes.append(randBytes);

    QString m_guid = QUuid::fromRfc4122(guidBytes).toString();
    m_guid.remove(0,1);
    m_guid.remove(m_guid.length()-1, 1);

    return m_guid;
}
