#ifndef SQUARE_H
#define SQUARE_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>
#include <QQuickItem>

class Gun;
class Square :  public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(int row MEMBER m_row NOTIFY rowChanged)
    Q_PROPERTY(int col MEMBER m_col NOTIFY colChanged)
public:
    explicit Square(QObject *parent = 0);
    Gun* m_gun;
    int m_row;
    int m_col;
signals:

    void rowChanged(int newRow);
    void colChanged(int newCol);
public slots:
};

#endif // SQUARE_H
