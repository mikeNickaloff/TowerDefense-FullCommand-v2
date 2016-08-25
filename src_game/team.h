#ifndef TEAM_H
#define TEAM_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>

class Team : public QObject
{
    Q_OBJECT
public:
    explicit Team(QObject *parent = 0);

signals:

public slots:
};

#endif // TEAM_H