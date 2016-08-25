#ifndef PROJECTILE_H
#define PROJECTILE_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>

class Projectile : public QObject
{
    Q_OBJECT
public:
    explicit Projectile(QObject *parent = 0);

signals:

public slots:
};

#endif // PROJECTILE_H