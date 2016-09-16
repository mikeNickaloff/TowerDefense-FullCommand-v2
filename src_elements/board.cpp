#include "board.h"
#include "../src_elements/square.h"
#include "../src_elements/wall.h"
#include "../src_elements/start.h"
#include "../src_elements/end.h"
#include "../src_elements/gun.h"
#include "../src_game/game.h"
#include "attacker.h"
#include "projectile.h"
#include <QObject>
#include <QtDebug>
#include <QQmlContext>
#include <QQmlListProperty>


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
    this->m_deadEnds.remove(pair);
    this->m_guns.remove(pair);
    //correctPaths();
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

    QVariantList rv;
    QList<Square*> tmp_squares;
    tmp_squares << this->m_squares.values();
    // int u = 0;
    //qDebug() << tmp_squares;
    foreach (Square* sq, tmp_squares) {
        //    u++;
        rv.append(QVariant::fromValue(sq));
    }

    v_squares.clear();
    v_squares = rv;

}

void Board::placeStart(int row, int col) {
    eraseTile(row, col);
    new_start = new Start(this);
    QPair<int, int> pair = qMakePair(row, col);
    m_starts[pair] = new_start;
    new_start->m_row = row;
    new_start->m_col = col;
    //placeWall(row + 1, col + 1);
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

        bool valid_placement = true;

        QPair<int, int> pair = qMakePair(row, col);
        if (m_guns.contains(pair)) { valid_placement = false; this->m_lastGunPlacementValid = QVariant::fromValue(false); this->m_needBestPathUpdate = QVariant::fromValue(false); }
        if (valid_placement) {


            new_gun = new Gun(this);
            QPair<int, int> pair = qMakePair(row, col);
            m_guns[pair] = new_gun;
            new_gun->m_row = row;
            new_gun->m_col = col;
            new_gun->m_gunType = gunType;
            new_gun->m_rangeLowAccuracy = 200;
            new_gun->upgradeRangeAmount = 1.75;
            new_gun->upgradeRangeCost = 4;
            new_gun->damageLowAccuracy = 10;
            new_gun->upgradeDamageAmount = 2;
            this->m_lastGunPlacementValid = QVariant::fromValue(true);
            if (m_squares.contains(pair)) {
                Square* tmp_sq = m_squares.value(pair);
                if (this->m_best_path.contains(tmp_sq)) {
                    this->m_needBestPathUpdate = QVariant::fromValue(true);
                } else {
                    this->m_needBestPathUpdate = QVariant::fromValue(false);
                }
            }
            if (m_best_path.count() < 2) { this->m_needBestPathUpdate = QVariant::fromValue(true); }


            QVariantList rv;
            QList<Gun*> tmp_guns;
            tmp_guns << this->m_guns.values();
            // int u = 0;
            //qDebug() << tmp_squares;
            foreach (Gun* gu, tmp_guns) {
                //        u++;
                rv.append(QVariant::fromValue(gu));
            }
            v_guns.clear();
            v_guns = rv;


        } else {
            this->m_needBestPathUpdate = QVariant::fromValue(false);
            this->m_lastGunPlacementValid = QVariant::fromValue(false);


        }
    } else {
        this->m_lastGunPlacementValid = QVariant::fromValue(false);
        this->m_needBestPathUpdate = QVariant::fromValue(false);
    }
}



void Board::placeAttacker(int row, int col, int attackerType, QVariant speed) {


    QList<Square*> tmpPath;

    tmpPath << m_best_path;
    if (tmpPath.count() > 1) {


        new_attacker = new Attacker(this);

        int u = 0;
        while (m_attackers.contains(u)) {
            u++;
        }
        m_attackers[u] = new_attacker;
        new_attacker->m_speed = speed;
        new_attacker->m_attackerType = attackerType;




        new_attacker->m_path << tmpPath;
        new_attacker->m_current = QVariant::fromValue(new_attacker->m_path.takeFirst());
        new_attacker->m_target = QVariant::fromValue(new_attacker->m_path.takeFirst());

        m_lastSpawnedAttacker = new_attacker;
        QVariantList rv;
        QList<Attacker*> tmp_attackers;
        tmp_attackers << this->m_attackers.values();
        // int u = 0;
        //qDebug() << tmp_squares;
        foreach (Attacker* att, tmp_attackers) {
            //        u++;
            rv.append(QVariant::fromValue(att));
        }
        v_attackers.clear();
        v_attackers = rv;
    }


}
void Board::correctPaths() {
    foreach (Attacker* attacker, m_attackers.values()) {
        QList<Square*> tmpPath;
        QObject* cur = qvariant_cast<QObject*>(attacker->m_current);
        tmpPath << qobject_cast<Square*>(cur);
        attacker->m_path.clear();
        attacker->m_path << this->m_best_path;

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
void Board::removeGun(int row, int col) {
    m_guns.remove(qMakePair(row, col));
}

void Board::setSquares(QVariant newMap) {

}
QVariant Board::readSquares() {
    //    QVariantList rv;
    QList<Square*> tmp_squares;
    tmp_squares << this->m_squares.values();
    //   int u = 0;
    //qDebug() << tmp_squares;
    //    foreach (Square* sq, tmp_squares) {
    //      u++;
    //    rv.append(QVariant::fromValue(sq));
    //  }

    // qDebug() << rv;
    QVariant list = QVariant::fromValue(tmp_squares);
    return list;
}

QVariant Board::readGuns() {
    //QVariantList rv;
    QList<Gun*> tmp_guns;
    tmp_guns << this->m_guns.values();
    // int u = 0;
    //qDebug() << tmp_squares;
    //foreach (Gun* gu, tmp_guns) {
    //        u++;
    //       rv.append(QVariant::fromValue(gu));
    //  }

    // qDebug() << rv;
    QVariant list = QVariant::fromValue(tmp_guns);
    return list;
}
QList<Square*> Board::readPath(int row, int col) {
    return m_best_path;
}

QList<Square*> Board::next_path_square(QList<Square*> cur_path) {
    QList<Square*> cp;
    cp << cur_path;
    if (cp.count() > 0) {
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

            foreach (Square* nsq, neighbors) {
                if (this->distance_from_end(nsq) < dist) {
                    dist = this->distance_from_end(nsq);
                    chosen = nsq;
                }
            }

            cp << chosen;
        }

        QList<Square*> chk;
        chk << next_path_square(cp);
        if (chk.count() > 0) {
            return chk;
        }
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
            if (!m_guns.contains(qMakePair(sq->m_row, sq->m_col))) {
                final << sq;
            }
        }
    }
    return final;

}

QVariant Board::readAttackers() {
    //QVariantList rv;
    QList<Attacker*> tmp_attackers;
    tmp_attackers << this->m_attackers.values();
    // int u = 0;
    //qDebug() << tmp_squares;
    //foreach (Attacker* att, tmp_attackers) {
    //        u++;
    //        rv.append(QVariant::fromValue(att));
    //  }

    // qDebug() << rv;
    QVariant list = QVariant::fromValue(tmp_attackers);
    return list;
}



void Board::populate_dead_ends() {
    //this->m_deadEnds.clear();
    bool madeChanges = false;
    foreach (Square* sq, m_squares.values()) {
        if ((find_neighbors(sq->m_row, sq->m_col).count() < 1) && (!is_neighbor_of_end(sq->m_row, sq->m_col))) {


        }
    }



}

QVariant Board::check_for_gun_placement(Square *i_square)
{
    if (m_guns.contains(qMakePair(i_square->m_row, i_square->m_col)))
    {
        return QVariant::fromValue(true);
    } else {
        return QVariant::fromValue(false);
    }
    return QVariant::fromValue(false);
}

Square* Board::find_square(QVariant row, QVariant col)
{
    QPair<int, int> pair;
    pair.first = row.toInt();
    pair.second = col.toInt();
    if (m_squares.contains(pair)) {
        Square* rv = m_squares.value(pair);
        return rv;
    } else {
        qDebug() << "Invalid Square Object";
        qApp->exit(0);
    }
    qDebug() << "Invalid Square Object";
    qApp->exit(0);
    return 0;
}

QVariant Board::is_end_square(QVariant row, QVariant col)
{
    QVariant rv;
    if (m_ends.contains(qMakePair(row.toInt(), col.toInt()))) {
        rv = QVariant::fromValue(true);
    } else {
        if (m_starts.contains(qMakePair(row.toInt(), col.toInt()))) {
            rv = QVariant::fromValue(true);
        } else {
            rv = QVariant::fromValue(false);
        }
    }
    return rv;
}

Gun *Board::find_gun(QVariant row, QVariant col)
{
    QPair<int, int> pair;
    pair.first = row.toInt();
    pair.second = col.toInt();
    if (m_guns.contains(pair)) {
        Gun* rv = m_guns.value(pair);
        return rv;
    } else {
        qDebug() << "Invalid Gun Object";
        qApp->exit(0);
    }
    qDebug() << "Invalid Gun Object";
    qApp->exit(0);
    return 0;
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
        int total = row_diff * col_diff;
        if (total < rv) { rv = total; }
    }

    return rv;
}
void Board::add_path_data(QVariant c1, QVariant r1) {


    QPair<int,int> pair = qMakePair(r1.toInt(), c1.toInt());
    //qDebug() << "adding" << pair;
    if (m_squares.contains(pair)) {
        m_best_path << m_squares.value(pair);
    }
}

void Board::placeGun2(int row, int col, int gunType, double gunDamage, double gunRange, double gunRangeHighAccuracy, double gunDamageHighAccuracy, double gunMaxOffsetHighAccuracy, double gunRangeLowAccuracy, double gunDamageLowAccuracy, double gunMaxOffsetLowAccuracy, double gunFireDelay, double gunProjectileSpeed, bool gunAttacksAir, bool gunAttacksGround, bool gunSplashRadius, double gunProximityDistance, double gunUpgradeRangeAmountMultiplier, double gunUpgradeRangeCostMultiplier, double gunUpgradeRangeCost, double gunUpgradeDamageAmountMultiplier, double gunUpgradeDamageCostMultiplier, double gunUpgradeDamageCost, int gunMaxUpgradeLevel, int gunRangeLevel, int gunDamageLevel, int gunCost)
{


if (!is_neighbor_of_start(row, col)) {

  bool valid_placement = true;

  QPair<int, int> pair = qMakePair(row, col);
  if (m_guns.contains(pair)) { valid_placement = false; this->m_lastGunPlacementValid = QVariant::fromValue(false); this->m_needBestPathUpdate = QVariant::fromValue(false); }
  if (valid_placement) {


      new_gun = new Gun(this);
      QPair<int, int> pair = qMakePair(row, col);
      m_guns[pair] = new_gun;
      new_gun->m_row = row;
      new_gun->m_col = col;
      new_gun->gunType = gunType;
      new_gun->m_gunType = gunType;



      new_gun->m_rangeLowAccuracy = gunRangeLowAccuracy * gunRange;
      new_gun->upgradeRangeAmount = gunUpgradeRangeAmountMultiplier;
      new_gun->upgradeRangeCost = gunUpgradeRangeCost;
      new_gun->damageLowAccuracy = gunDamageLowAccuracy * gunDamage;
      new_gun->upgradeDamageAmount = gunUpgradeDamageAmountMultiplier;
      this->m_lastGunPlacementValid = QVariant::fromValue(true);


      new_gun->gunAttacksAir = gunAttacksAir;
      new_gun->gunAttacksGround = gunAttacksGround;
      new_gun->gunDamage = gunDamage;
      new_gun->gunDamageHighAccuracy = gunDamageHighAccuracy;
      new_gun->gunDamageLevel = gunDamageLevel;
      new_gun->gunDamageLowAccuracy = gunDamageLowAccuracy;
      new_gun->gunFireDelay = gunFireDelay;
      new_gun->gunMaxOffsetHighAccuracy = gunMaxOffsetHighAccuracy;
      new_gun->gunMaxOffsetLowAccuracy = gunMaxOffsetLowAccuracy;
      new_gun->gunMaxUpgradeLevel = gunMaxUpgradeLevel;
      new_gun->gunProjectileSpeed = gunProjectileSpeed;
      new_gun->gunProximityDistance = gunProximityDistance;
      new_gun->gunRange = gunRange;
      new_gun->gunRangeHighAccuracy = gunRangeHighAccuracy;
      new_gun->gunRangeLevel = gunRangeLevel;
      new_gun->gunRangeLowAccuracy = gunRangeLowAccuracy;
      new_gun->gunSplashRadius = gunSplashRadius;
      new_gun->gunUpgradeDamageAmountMultiplier = gunUpgradeDamageAmountMultiplier;
      new_gun->gunUpgradeDamageCost = gunUpgradeDamageCost;
      new_gun->gunUpgradeDamageCostMultiplier = gunUpgradeDamageCostMultiplier;
      new_gun->gunUpgradeRangeAmountMultiplier = gunUpgradeRangeAmountMultiplier;
      new_gun->gunUpgradeRangeCost = gunUpgradeRangeCost;
      new_gun->gunUpgradeRangeCostMultiplier = gunUpgradeRangeCostMultiplier;
      new_gun->gunCost = gunCost;


      this->m_lastGunPlacementValid = QVariant::fromValue(true);
      if (m_squares.contains(pair)) {
          Square* tmp_sq = m_squares.value(pair);
          if (this->m_best_path.contains(tmp_sq)) {
              this->m_needBestPathUpdate = QVariant::fromValue(true);
          } else {
              this->m_needBestPathUpdate = QVariant::fromValue(false);
          }
      }
      if (m_best_path.count() < 2) { this->m_needBestPathUpdate = QVariant::fromValue(true); }


      QVariantList rv;
      QList<Gun*> tmp_guns;
      tmp_guns << this->m_guns.values();
      // int u = 0;
      //qDebug() << tmp_squares;
      foreach (Gun* gu, tmp_guns) {
          //        u++;
          rv.append(QVariant::fromValue(gu));
      }
      v_guns.clear();
      v_guns = rv;
      emit this->spent_cash(gunCost);


  } else {
      this->m_needBestPathUpdate = QVariant::fromValue(false);
      this->m_lastGunPlacementValid = QVariant::fromValue(false);


  }
} else {
  this->m_lastGunPlacementValid = QVariant::fromValue(false);
  this->m_needBestPathUpdate = QVariant::fromValue(false);
}
}


