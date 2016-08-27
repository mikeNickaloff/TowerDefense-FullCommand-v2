#ifndef GUN_H
#define GUN_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>
class Square;
class Attacker;
class Gun : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int row MEMBER m_row NOTIFY rowChanged)
    Q_PROPERTY(int col MEMBER m_col NOTIFY colChanged)
    Q_PROPERTY(int gunType MEMBER m_gunType NOTIFY gunTypeChanged)
    Q_PROPERTY(QObject* gunVisual MEMBER m_gunVisual NOTIFY gunVisualChanged)
    Q_PROPERTY(double rangeLowAccuracy MEMBER m_rangeLowAccuracy NOTIFY rangeLowAccuracyChanged)
public:
    explicit Gun(QObject *parent = 0);
    bool isBlank;

    /* this square will be a pointer to the Square
     *  that this gun is assigned to */
    Square* m_square;
    Attacker* m_target;

    int m_row;
    int m_col;


    QObject* m_gunVisual;
    Q_INVOKABLE void set_gunVisual(QObject* i_gunVisual) {
        m_gunVisual = i_gunVisual;
        //QQmlEngine::setObjectOwnership(m_squareVisual, QQmlEngine::JavaScriptOwnership);
    }

    int m_gunType;



    int addonID;

    double rangeHighAccuracy;
    double damageHighAccuracy;
    double maxOffsetHighAccuracy;

    double m_rangeLowAccuracy;
    double damageLowAccuracy;
    double maxOffsetLowAccuracy;

    double fireDelay;

    double projectileSpeed;
    double turnRate;

    bool attacksAir;
    bool attacksGround;
    bool slowOnHit;

    double slowPct;
    int slowTime;

    double splashRadius;
    double proximityDistance;

    double upgradeRangeAmount;
    double upgradeRangeCost;

    double upgradeDamageAmount;
    double upgradeDamageCost;

    double upgradeProjectileSpeedAmount;
    double upgradeProjectileSpeedCost;

    int maxUpgradeLevel;

    int rangeLevel;
    int damageLevel;
    int projectileSpeedLevel;


signals:
    void rowChanged(int newRow);
    void colChanged(int newCol);
    void gunVisualChanged(QObject* newObj);
    void gunTypeChanged(int newGunType);
    void rangeLowAccuracyChanged(double newRange);
public slots:
};

#endif // GUN_H
