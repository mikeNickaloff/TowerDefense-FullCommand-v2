#ifndef TOWERUPGRADEMENU_H
#define TOWERUPGRADEMENU_H

#include <QtCore/qglobal.h>
#if QT_VERSION >= 0x050000
#include <QQuickItem>
#else
#endif
#include <QObject>
class Gun;
class TowerUpgradeMenu : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(Gun* gun MEMBER m_gun NOTIFY gunChanged)
public:
    TowerUpgradeMenu();
    Gun* m_gun;

signals:
    void gunChanged(Gun* newGun);
public slots:
};

#endif // TOWERUPGRADEMENU_H
