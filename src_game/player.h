#ifndef PLAYER_H
#define PLAYER_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>

class Player : public QObject
{
    Q_OBJECT
public:
    explicit Player(QObject *parent = 0);

signals:

public slots:
};

#endif // PLAYER_H