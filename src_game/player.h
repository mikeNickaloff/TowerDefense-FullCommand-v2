#ifndef PLAYER_H
#define PLAYER_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>
#include <QVariant>

class Player : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant money MEMBER m_money NOTIFY moneyChanged)
    Q_PROPERTY(QVariant health MEMBER m_health NOTIFY healthChanged)
public:
    explicit Player(QObject *parent = 0);
    QVariant m_money;
    QVariant m_health;
signals:
    void moneyChanged(QVariant newMoney);
    void healthChanged(QVariant newHealth);
public slots:
};

#endif // PLAYER_H
