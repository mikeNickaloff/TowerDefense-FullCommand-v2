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
class Game;
class Gun;
class Attacker;
class Projectile;
class Board : public QObject
{
    Q_PROPERTY(int testArg MEMBER testArg NOTIFY testArgChanged)
    Q_PROPERTY(QVariantList squares READ readSquares WRITE setSquares NOTIFY squaresChanged)
    Q_PROPERTY(QVariantList guns READ readGuns NOTIFY gunsChanged)
    Q_PROPERTY(QVariantList attackers READ readAttackers NOTIFY attackersChanged)
    Q_OBJECT
    Q_PROPERTY(int rowCount MEMBER m_rowCount NOTIFY rowCountChanged)
    Q_PROPERTY(int colCount MEMBER m_colCount NOTIFY colCountChanged)
    Q_PROPERTY(QObject* lastSpawnedAttacker MEMBER m_lastSpawnedAttacker NOTIFY lastSpawnedAttackerChanged)
public:
    explicit Board(QObject *parent = 0, Game* i_game = 0);
    Game* m_game;

    QHash<QPair<int, int> , Square*> m_squares;
    QHash<QPair<int, int> , Wall*> m_walls;
    QHash<QPair<int, int> , Start*> m_starts;
    QHash<QPair<int, int> , End*> m_ends;
    QHash<QPair<int, int> , Gun*> m_guns;
    QHash<int, Projectile*> m_projectiles;
    QHash<QPair<int, int>, Square*> m_deadEnds;

    QHash<int, Attacker*> m_attackers;

    QList<Square*> find_neighbors(int row, int col);


    Wall* new_wall;
    Start* new_start;
    End* new_end;
    Square* new_square;
    Gun* new_gun;
    Attacker* new_attacker;
    Projectile* new_projectile;
    int testArg;
    QVariantList readSquares();
QVariantList readGuns();
QList<Square*> readPath(int row, int col);
QList<Square*> next_path_square(QList<Square*> cur_path);

QVariantList readAttackers();
    int m_rowCount;
    int m_colCount;
    bool is_neighbor_of_end(int row, int col);
    bool is_neighbor_of_start(int row, int col);
    int distance_from_end(Square* square);
QList<Square*> m_best_path;

    QObject* m_lastSpawnedAttacker;


signals:
    void testArgChanged(int newArg);
    void squaresChanged(QVariantList newMap);
    void gunsChanged(QVariantList newList);
    void squareDataAssigned(QVariant row, QVariant col, QVariant xpos, QVariant ypos);
    void rowCountChanged(int newCount);
    void colCountChanged(int newCount);
    void attackersChanged(QVariantList newList);
    void lastSpawnedAttackerChanged(QObject* newLast);
public slots:
    void add_path_data(QVariant c1, QVariant r1);
    void clear_path_data() { m_best_path.clear(); }
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
    void placeGun(int row, int col, int gunType);
    void placeAttacker(int row, int col, int attackerType, QVariant speed);

    void correctPaths();
void removeAttacker(Attacker *att);
    void populate_dead_ends();




};

#endif // BOARD_H
