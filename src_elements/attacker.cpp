#include "attacker.h"
#include "square.h"
#include <QQuickItem>
Attacker::Attacker(QObject *parent) : QQuickItem()
{
m_xpos = 0;
m_ypos = 0;
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
