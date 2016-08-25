#ifndef WALL_H
#define WALL_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>

class Wall : public QObject
{
    Q_OBJECT
public:
    explicit Wall(QObject *parent = 0);

signals:

public slots:
};

#endif // WALL_H