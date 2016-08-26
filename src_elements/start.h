#ifndef START_H
#define START_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>

class Start : public QObject
{
    Q_OBJECT
public:
    explicit Start(QObject *parent = 0);
    int m_row;
    int m_col;
signals:

public slots:
};

#endif // START_H
