#include "board.h"
#include "../src_elements/square.h"
#include "../src_elements/wall.h"
#include "../src_elements/start.h"
#include "../src_elements/end.h"
#include "../src_elements/gun.h"
#include "../src_game/game.h"
#include "attacker.h"
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
    new_start->m_row = row;
    new_start->m_col = col;
    placeWall(row + 1, col + 1);
}

void Board::placeEnd(int row, int col) {
    eraseTile(row, col);
    new_end = new End(this);
    QPair<int, int> pair = qMakePair(row, col);
    m_ends[pair] = new_end;
    new_end->m_row = row;
    new_end->m_col = col;
}
void Board::placeGun(int row, int col, int gunType) {

    if (!is_neighbor_of_start(row, col)) {
        eraseTile(row, col);
        bool valid_placement = true;
      // this->m_deadEnds.clear();
        populate_dead_ends();

        foreach (Start* tmpstart, m_starts.values()) {
            QList<Square*> check_list;
            check_list << readPath(tmpstart->m_row, tmpstart->m_col);
            //qDebug() << check_list;
            if (check_list.count() == 1) {
                valid_placement = false;
            }
        }
        if (valid_placement) {

            new_gun = new Gun(this);
            QPair<int, int> pair = qMakePair(row, col);
            m_guns[pair] = new_gun;
            new_gun->m_row = row;
            new_gun->m_col = col;
            new_gun->m_gunType = gunType;
            new_gun->m_rangeLowAccuracy = 100;
         //   this->m_deadEnds.clear();
            populate_dead_ends();

        } else {
            placeSquare(row, col);
           // this->m_deadEnds.clear();
            populate_dead_ends();

        }
    }

}

void Board::placeAttacker(int row, int col, int attackerType, QVariant speed) {

    new_attacker = new Attacker(this);

    int u = 0;
    while (m_attackers.contains(u)) {
        u++;
    }
    m_attackers[u] = new_attacker;
    new_attacker->m_speed = speed;
    new_attacker->m_attackerType = attackerType;
    QList<Square*> tmpPath;
    tmpPath << readPath(1, 1);
    new_attacker->m_path << tmpPath;
    new_attacker->m_current = QVariant::fromValue(new_attacker->m_path.takeFirst());
    new_attacker->m_target = QVariant::fromValue(new_attacker->m_path.takeFirst());
    m_lastSpawnedAttacker = QVariant::fromValue(new_attacker);
}
void Board::correctPaths() {
    foreach (Attacker* attacker, m_attackers.values()) {
        QList<Square*> tmpPath;
        QVariant cur = attacker->m_current;
        tmpPath << cur.value<Square*>();
         attacker->m_path.clear();
         attacker->m_path << this->next_path_square(tmpPath);

        //attacker->m_current = QVariant::fromValue(attacker->m_path.takeFirst());
        //attacker->m_target = QVariant::fromValue(attacker->m_path.takeFirst());
    }
}

void Board::removeAttacker(Attacker* att) {

    int keyToRemove = -1;
    if (m_attackers.values().contains(att)) {
        foreach (int u, m_attackers.keys()) {
            Attacker* chkAtt = m_attackers.value(u);
            if (chkAtt == att) {
                keyToRemove = u;
                break;
            }

        }
        m_attackers.remove(keyToRemove);

    }
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

    // qDebug() << rv;
    return rv;
}
QList<Square*> Board::readPath(int row, int col) {
    //populate_dead_ends();
    QList<Square*> rv;
    QList<Square*> neighbors;
    neighbors << this->find_neighbors(row, col);

    // qDebug() << "Read Path Neighbors: " << neighbors;
    if (neighbors.count() > 0) {
        rv << neighbors.first();
        rv << next_path_square(rv);
    }
    //qDebug() << "Final value:" << rv;
    return rv;
}

QList<Square*> Board::next_path_square(QList<Square*> cur_path) {
    QList<Square*> cp;
    cp << cur_path;
    Square* lastSquare = cp.last();
    if (is_neighbor_of_end(lastSquare->m_row, lastSquare->m_col)) {
        return cp;
    }
    QList<Square*> neighbors;
    neighbors << find_neighbors(lastSquare->m_row, lastSquare->m_col);
   // qDebug() << "current path: " << cur_path.last();
    foreach (Square* sq, cp) {
        neighbors.removeAll(sq);
    }
    if (neighbors.count() > 0) {
        int random = (qrand() % 255);
        Square* chosen = neighbors.first();
        int dist = distance_from_end(chosen);
        if ((random % 2) == 0) {
        foreach (Square* nsq, neighbors) {
            if (this->distance_from_end(nsq) < dist) {
                dist = this->distance_from_end(nsq);
                chosen = nsq;
            }
        }

        cp << chosen;
        } else {
            cp << neighbors.first();
        }

        return next_path_square(cp);
    } else {
        QList<Square*> errorList;
        return errorList;
    }
    QList<Square*> errorList;
    return errorList;
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


    QList<Square*> final;
    foreach (Square* sq, rv) {
        if ((!m_deadEnds.values().contains(sq)) || (is_neighbor_of_end(sq->m_row, sq->m_col))) {
            final << sq;
        }
    }
    return final;

}

QVariantList Board::readAttackers() {
    QVariantList rv;
    QList<Attacker*> tmp_attackers;
    tmp_attackers << this->m_attackers.values();
    int u = 0;
    //qDebug() << tmp_squares;
    foreach (Attacker* att, tmp_attackers) {
        u++;
        rv.append(QVariant::fromValue(att));
    }

    // qDebug() << rv;
    return rv;
}



void Board::populate_dead_ends() {
    //this->m_deadEnds.clear();
    foreach (Square* sq, m_squares.values()) {
        if ((find_neighbors(sq->m_row, sq->m_col).count() < 1) && (!is_neighbor_of_end(sq->m_row, sq->m_col))) {
            if (!m_deadEnds.contains(qMakePair(sq->m_row, sq->m_col))) {
                m_deadEnds[qMakePair(sq->m_row, sq->m_col)] = sq;
                populate_dead_ends();
            }

        }
    }


}
bool Board::is_neighbor_of_end(int row, int col) {
    bool rv = false;
    QPair<int, int> p1 = qMakePair(row + 1, col + 0);
    QPair<int, int> p2 = qMakePair(row + 0, col + 1);
    QPair<int, int> p3 = qMakePair(row - 1, col + 0);
    QPair<int, int> p4 = qMakePair(row + 0, col - 1);
    if (m_ends.contains(p1)) { rv = true; }
    if (m_ends.contains(p2)) { rv = true; }
    if (m_ends.contains(p3)) { rv = true; }
    if (m_ends.contains(p4)) { rv = true; }
    return rv;

}
bool Board::is_neighbor_of_start(int row, int col) {
    bool rv = false;
    QPair<int, int> p1 = qMakePair(row + 1, col + 1);
    QPair<int, int> p2 = qMakePair(row - 1, col + 1);
    QPair<int, int> p3 = qMakePair(row + 1, col - 1);
    QPair<int, int> p4 = qMakePair(row - 1, col - 1);
    QPair<int, int> p5 = qMakePair(row + 1, col + 0);
    QPair<int, int> p6 = qMakePair(row + 0, col + 1);
    QPair<int, int> p7 = qMakePair(row - 1, col + 0);
    QPair<int, int> p8 = qMakePair(row + 0, col - 1);
    if (m_starts.contains(p1)) { rv = true; }
    if (m_starts.contains(p2)) { rv = true; }
    if (m_starts.contains(p3)) { rv = true; }
    if (m_starts.contains(p4)) { rv = true; }
    if (m_starts.contains(p5)) { rv = true; }
    if (m_starts.contains(p6)) { rv = true; }
    if (m_starts.contains(p7)) { rv = true; }
    if (m_starts.contains(p8)) { rv = true; }
    return rv;

}
int Board::distance_from_end(Square* square) {
    int rv = 99999;
    foreach (End* end, m_ends.values()) {
        int row_diff = qAbs(end->m_row - square->m_row);
        int col_diff = qAbs(end->m_col - square->m_col);
        int total = row_diff + col_diff;
        if (total < rv) { rv = total; }
    }

    return rv;
}
