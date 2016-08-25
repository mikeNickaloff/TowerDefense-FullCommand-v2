#ifndef BOARD_H
#define BOARD_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>
#include <QHash>
#include <QVariant>
#include <QVariantMap>
class Square;
class Wall;
class Start;
class End;
class Board : public QObject
{
    Q_PROPERTY(int testArg MEMBER testArg NOTIFY testArgChanged)
    Q_PROPERTY(QVariantList squares READ readSquares WRITE setSquares NOTIFY squaresChanged)
    Q_OBJECT
    Q_PROPERTY(int rowCount MEMBER m_rowCount NOTIFY rowCountChanged)
    Q_PROPERTY(int colCount MEMBER m_colCount NOTIFY colCountChanged)
public:
    explicit Board(QObject *parent = 0);
    QHash<QPair<int, int> , Square*> m_squares;
    QHash<QPair<int, int> , Wall*> m_walls;
    QHash<QPair<int, int> , Start*> m_starts;
    QHash<QPair<int, int> , End*> m_ends;

    Wall* new_wall;
    Start* new_start;
    End* new_end;
    Square* new_square;
    int testArg;
    QVariantList readSquares();

    int m_rowCount;
    int m_colCount;
signals:
    void testArgChanged(int newArg);
    void squaresChanged(QVariantList newMap);
    void squareDataAssigned(QVariant row, QVariant col, QVariant xpos, QVariant ypos);
    void rowCountChanged(int newCount);
    void colCountChanged(int newCount);
public slots:

    void setSquares(QVariantList newMap);


    // slots for initializing map prior to loading
    void changeRowCount(int newCount);
    void changeColCount(int newCount);
    void eraseTile(int row, int col);

    // slots for assigning special map squares that player cannot
    // change during a game

    void placeWall(int row, int col);
    void placeSquare(int row, int col);
    void placeStart(int row, int col);
    void placeEnd(int row, int col);


};

#endif // BOARD_H
