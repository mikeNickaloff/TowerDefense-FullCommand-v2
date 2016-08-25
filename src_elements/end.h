#ifndef END_H
#define END_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>

class End : public QObject
{
    Q_OBJECT
public:
    explicit End(QObject *parent = 0);

signals:

public slots:
};

#endif // END_H