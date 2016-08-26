#include "board.h"
#include "../src_elements/square.h"
#include "../src_elements/wall.h"
#include "../src_elements/start.h"
#include "../src_elements/end.h"
#include "../src_elements/gun.h"
#include "../src_game/game.h"
#include <QObject>
#include <QtDebug>
#include <QQmlContext>


Board::Board(QObject *parent, Game *i_game) : QObject(parent), m_game(i_game)
{
    testArg = 0;
    // qRegisterMetaType<Square>("Square");
}


// changing the rowCount or colCount will initialize the board.
//  and should only be used at the start of loading a new map
void Board::changeRowCount(int newCount) {
    m_ends.clear();
    m_walls.clear();
    m_squares.clear();
    m_starts.clear();
    this->testArg++;
    m_rowCount = newCount;
}
void Board::changeColCount(int newCount) {
    m_ends.clear();
    m_walls.clear();
    m_squares.clear();
    m_starts.clear();
    this->testArg++;
    m_colCount = newCount;
}
void Board::eraseTile(int row, int col) {
    QPair<int, int> pair = qMakePair(row, col);
    this->m_ends.remove(pair);
    this->m_squares.remove(pair);
    this->m_starts.remove(pair);
    this->m_walls.remove(pair);
    this->testArg++;
}

void Board::placeWall(int row, int col) {
    eraseTile(row, col);
    new_wall = new Wall(this);
    QPair<int, int> pair = qMakePair(row, col);
    m_walls[pair] = new_wall;
    this->testArg++;
    //  qDebug() << "placed wall at row/col " << row << "/" << col;
}

void Board::placeSquare(int row, int col) {
    eraseTile(row, col);
    new_square = new Square(this);
    QPair<int, int> pair = qMakePair(row, col);
    m_squares[pair] = new_square;
    //qDebug() << "placed square at row/col " << row << "/" << col;
    new_square->m_row = row;
    new_square->m_col = col;


}

void Board::placeStart(int row, int col) {
    eraseTile(row, col);
    new_start = new Start(this);
    QPair<int, int> pair = qMakePair(row, col);
    m_starts[pair] = new_start;
}

void Board::placeEnd(int row, int col) {
    eraseTile(row, col);
    new_end = new End(this);
    QPair<int, int> pair = qMakePair(row, col);
    m_ends[pair] = new_end;
}
void Board::placeGun(int row, int col, int gunType) {
    eraseTile(row, col);
    new_gun = new Gun(this);
    QPair<int, int> pair = qMakePair(row, col);
    m_guns[pair] = new_gun;
    new_gun->m_row = row;
    new_gun->m_col = col;
    new_gun->m_gunType = gunType;

}

void Board::setSquares(QVariantList newMap) {

}
QVariantList Board::readSquares() {
    QVariantList rv;
    QList<Square*> tmp_squares;
    tmp_squares << this->m_squares.values();
    int u = 0;
    //qDebug() << tmp_squares;
    foreach (Square* sq, tmp_squares) {
        u++;
        rv.append(QVariant::fromValue(sq));
    }

   // qDebug() << rv;
    return rv;
}

QVariantList Board::readGuns() {
    QVariantList rv;
    QList<Gun*> tmp_guns;
    tmp_guns << this->m_guns.values();
    int u = 0;
    //qDebug() << tmp_squares;
    foreach (Gun* gu, tmp_guns) {
        u++;
        rv.append(QVariant::fromValue(gu));
    }

    qDebug() << rv;
    return rv;
}

QList<Square*> Board::find_neighbors(int row, int col) {
    QList<Square*> rv;
    if (m_squares.contains(qMakePair(row, col + 1))) {
        rv << m_squares.value(qMakePair(row, col + 1));
    }
    if (m_squares.contains(qMakePair(row + 1, col))) {
        rv << m_squares.value(qMakePair(row + 1, col));
    }
    if (m_squares.contains(qMakePair(row - 1, col))) {
        rv << m_squares.value(qMakePair(row - 1, col));
    }
    if (m_squares.contains(qMakePair(row, col - 1))) {
        rv << m_squares.value(qMakePair(row, col - 1));
    }

    if (m_ends.contains(qMakePair(row, col + 1))) {
        rv << m_ends.value(qMakePair(row, col + 1));
    }
    if (m_ends.contains(qMakePair(row + 1, col))) {
        rv << m_ends.value(qMakePair(row + 1, col));
    }
    if (m_ends.contains(qMakePair(row - 1, col))) {
        rv << m_ends.value(qMakePair(row - 1, col));
    }
    if (m_ends.contains(qMakePair(row, col - 1))) {
        rv << m_ends.value(qMakePair(row, col - 1));
    }

    return rv;

}
void Board::populate_dead_ends() {

}
