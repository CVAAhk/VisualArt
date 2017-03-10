#ifndef HEIST_H
#define HEIST_H

#include <QObject>


class Heist: public QObject
{
    Q_OBJECT
    public:
        Heist();
        ~Heist();

        void initialize(void);

        //// clears all heist records associated with this instance
        Q_INVOKABLE void clearAllSessions();
        //// start session by adding a new entry with provided code
        Q_INVOKABLE void startPairingSession(QString code);
        //// end session by removing entry with specified code
        Q_INVOKABLE void endPairingSession(QString code);
        //// checks to see if session exists on the server
        Q_INVOKABLE bool sessionExists(QString code);
        //// checks to see if device exists
        Q_INVOKABLE bool deviceExists(QString code);
        //// set the session device
        Q_INVOKABLE void setDevice(QString code);
        //// append session's item list
        Q_INVOKABLE void addItem(QString code);
        //// returns session's item list
        Q_INVOKABLE QString getItems(QString code);

    private:
        //// returns heist entry id (internally incremented)
        QString sessionId(QString);
        //// maps session ids to pairing codes
        std::map<QString, QString> m_codes;
        //// maps session ids to item lists
        std::map<QString, QString> m_items;
        //// omeka endpoint
        QString url;
};

#endif // HEIST_H
