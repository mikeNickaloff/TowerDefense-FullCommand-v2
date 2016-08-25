#include "square.h"
#include "gun.h"
#include <QtCore/QObject>
#include <QQuickItem>


Square::Square(QObject *parent) :  QQuickItem()
{
this->m_gun = new Gun(this);
    m_gun->isBlank = true;
}
