#include "attacker.h"
#include "square.h"
Attacker::Attacker(QObject *parent) : QObject(parent)
{
m_xpos = 0;
m_ypos = 0;
}
void Attacker::next_target() {
    this->m_current = m_target;

    if (m_path.count() > 0) {
        this->m_target = QVariant::fromValue(this->m_path.takeFirst());
    } else {
        m_target = m_current;
        m_speed = 0;

    }
}
