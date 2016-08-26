#ifndef GUN_H
#define GUN_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>
class Square;
class Gun : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int row MEMBER m_row NOTIFY rowChanged)
    Q_PROPERTY(int col MEMBER m_col NOTIFY colChanged)
    Q_PROPERTY(int gunType MEMBER m_gunType NOTIFY gunTypeChanged)
public:
    explicit Gun(QObject *parent = 0);
    bool isBlank;

    /* this square will be a pointer to the Square
     *  that this gun is assigned to */
    Square* m_square;

    int m_row;
    int m_col;
    int m_gunType;

signals:
    void rowChanged(int newRow);
    void colChanged(int newCol);
    void gunTypeChanged(int newGunType);
public slots:
};

#endif // GUN_H
