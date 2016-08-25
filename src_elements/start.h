#ifndef START_H
#define START_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>

class Start : public QObject
{
    Q_OBJECT
public:
    explicit Start(QObject *parent = 0);

signals:

public slots:
};

#endif // START_H