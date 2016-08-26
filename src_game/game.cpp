#include "game.h"
#include "../src_elements/board.h"
#include "map.h"
#include "../src_elements/square.h"
#include "../src_elements/wall.h"
#include "../src_elements/start.h"
#include "../src_elements/end.h"
#include <QObject>
#include <QQmlContext>



Game::Game(QObject *parent, QQmlContext *i_context) : QObject(parent), m_context(i_context)
{

}
void Game::createBoard() {
    this->m_map = new Map(this);
    this->m_board = new Board(this, this);
   this->connect(m_map, SIGNAL(colCountChanged(int)), m_board, SLOT(changeColCount(int)));
    this->connect(m_map, SIGNAL(rowCountChanged(int)), m_board, SLOT(changeRowCount(int)));
    this->connect(m_map, SIGNAL(placeWall(int, int)), m_board, SLOT(placeWall(int,int)));
    this->connect(m_map, SIGNAL(placeStart(int, int)), m_board, SLOT(placeStart(int,int)));
    this->connect(m_map, SIGNAL(placeEnd(int, int)), m_board, SLOT(placeEnd(int,int)));
    this->connect(m_map, SIGNAL(placeSquare(int, int)), m_board, SLOT(placeSquare(int,int)));
    m_map->Map::create_blank_map();
}
