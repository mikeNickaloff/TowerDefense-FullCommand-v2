#ifndef TEAM_H
#define TEAM_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>
#include <QVariant>

class Player;
class Team : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant side MEMBER m_side NOTIFY sideChanged)
public:
    explicit Team(QObject *parent = 0);
    QVariant m_side;

signals:
    void sideChanged(QVariant newSide);
public slots:
};

#endif // TEAM_H
