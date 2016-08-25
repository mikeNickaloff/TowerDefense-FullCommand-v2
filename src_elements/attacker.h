#ifndef ATTACKER_H
#define ATTACKER_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>

class Attacker : public QObject
{
    Q_OBJECT
public:
    explicit Attacker(QObject *parent = 0);

signals:

public slots:
};

#endif // ATTACKER_H