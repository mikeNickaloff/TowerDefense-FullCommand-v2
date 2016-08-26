#ifndef END_H
#define END_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>
#include "square.h"
class Square;
class End : public Square
{
    Q_OBJECT
public:
    explicit End(QObject *parent = 0);
    int m_row;
    int m_col;
signals:

public slots:
};

#endif // END_H
