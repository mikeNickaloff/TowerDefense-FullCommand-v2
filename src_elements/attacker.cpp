#include "attacker.h"
#include "square.h"
#include <QQuickItem>
#include "../src_game/game.h"
#include "../src_elements/board.h"
Attacker::Attacker(QObject *parent) : QObject(parent)
{
m_xpos = 0;
m_ypos = 0;
}

bool Attacker::check_collision(int i_x, int i_y, double i_prox_dist)
{

}
void Attacker::next_target() {




    if (m_path.count() > 0) {
        this->m_current = m_target;
        this->m_target = QVariant::fromValue(this->m_path.takeFirst());
    } else {
        //m_target = m_current;
        m_speed = 0;

    }
}

void Attacker::clear_path()
{
    this->m_path.clear();
}

void Attacker::add_square_to_path(Square *i_square)
{
    if (!m_path.contains(i_square)) {
        m_path << i_square;
    }
}

