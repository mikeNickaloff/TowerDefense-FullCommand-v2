#ifndef GAME_H
#define GAME_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>


class Map;
class Square;
class Wall;
class Start;
class End;
class Board;
class Game : public QObject
{
    Q_OBJECT
     Q_PROPERTY(Board* board MEMBER m_board NOTIFY boardChanged)
public:
    Game(QObject *parent = 0);
    Board* m_board;
    Map* m_map;

signals:
    void boardChanged(Board &new_board);

public slots:
    // creates map object, too.
    void createBoard();

};

#endif // GAME_H
