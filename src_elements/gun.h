#ifndef GUN_H
#define GUN_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>
class Square;
class Gun : public QObject
{
    Q_OBJECT
public:
    explicit Gun(QObject *parent = 0);
    bool isBlank;

    /* this square will be a pointer to the Square
     *  that this gun is assigned to */
    Square* m_square;



signals:

public slots:
};

#endif // GUN_H
