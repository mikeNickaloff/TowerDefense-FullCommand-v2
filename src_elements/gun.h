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
    Q_PROPERTY(double damageLowAccuracy MEMBER damageLowAccuracy NOTIFY damageLowAccuracyChanged)
    Q_PROPERTY( double upgradeRangeAmount MEMBER upgradeRangeAmount NOTIFY upgradeRangeAmountChanged)
    Q_PROPERTY( double upgradeDamageAmount MEMBER upgradeDamageAmount NOTIFY upgradeDamageAmountChanged)
    Q_PROPERTY( double upgradeRangeCost MEMBER upgradeRangeCost NOTIFY upgradeRangeCostChanged)

    Q_PROPERTY(double gunDamage MEMBER gunDamage NOTIFY gunDamageChanged)
        Q_PROPERTY(double gunRangeHighAccuracy MEMBER gunRangeHighAccuracy NOTIFY gunRangeHighAccuracyChanged)
        Q_PROPERTY(double gunDamageHighAccuracy MEMBER gunDamageHighAccuracy NOTIFY gunDamageHighAccuracyChanged)
        Q_PROPERTY(double gunMaxOffsetHighAccuracy MEMBER gunMaxOffsetHighAccuracy NOTIFY gunMaxOffsetHighAccuracyChanged)
        Q_PROPERTY(double gunRangeLowAccuracy MEMBER gunRangeLowAccuracy NOTIFY gunRangeLowAccuracyChanged)
        Q_PROPERTY(double gunDamageLowAccuracy MEMBER gunDamageLowAccuracy NOTIFY gunDamageLowAccuracyChanged)
        Q_PROPERTY(double gunMaxOffsetLowAccuracy MEMBER gunMaxOffsetLowAccuracy NOTIFY gunMaxOffsetLowAccuracyChanged)
        Q_PROPERTY(double gunFireDelay MEMBER gunFireDelay NOTIFY gunFireDelayChanged)
        Q_PROPERTY(double gunProjectileSpeed MEMBER gunProjectileSpeed NOTIFY gunProjectileSpeedChanged)
        Q_PROPERTY(bool gunAttacksAir MEMBER gunAttacksAir NOTIFY gunAttacksAirChanged)
        Q_PROPERTY(bool gunAttacksGround MEMBER gunAttacksGround NOTIFY gunAttacksGroundChanged)
        Q_PROPERTY(bool gunSplashRadius MEMBER gunSplashRadius NOTIFY gunSplashRadiusChanged)
        Q_PROPERTY(double gunProximityDistance MEMBER gunProximityDistance NOTIFY gunProximityDistanceChanged)
        Q_PROPERTY(double gunUpgradeRangeAmountMultiplier MEMBER gunUpgradeRangeAmountMultiplier NOTIFY gunUpgradeRangeAmountMultiplierChanged)
        Q_PROPERTY(double gunUpgradeRangeCostMultiplier MEMBER gunUpgradeRangeCostMultiplier NOTIFY gunUpgradeRangeCostMultiplierChanged)
        Q_PROPERTY(double gunUpgradeRangeCost MEMBER gunUpgradeRangeCost NOTIFY gunUpgradeRangeCostChanged)
        Q_PROPERTY(double gunUpgradeDamageAmountMultiplier MEMBER gunUpgradeDamageAmountMultiplier NOTIFY gunUpgradeDamageAmountMultiplierChanged)
        Q_PROPERTY(double gunUpgradeDamageCostMultiplier MEMBER gunUpgradeDamageCostMultiplier NOTIFY gunUpgradeDamageCostMultiplierChanged)
        Q_PROPERTY(double gunUpgradeDamageCost MEMBER gunUpgradeDamageCost NOTIFY gunUpgradeDamageCostChanged)
        Q_PROPERTY(int gunMaxUpgradeLevel MEMBER gunMaxUpgradeLevel NOTIFY gunMaxUpgradeLevelChanged)
        Q_PROPERTY(int gunRangeLevel MEMBER gunRangeLevel NOTIFY gunRangeLevelChanged)
        Q_PROPERTY(int gunDamageLevel MEMBER gunDamageLevel NOTIFY gunDamageLevelChanged)
        Q_PROPERTY(double gunRange MEMBER gunRange NOTIFY gunRangeChanged)


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


    int gunType; double gunDamage; double gunRange; double gunRangeHighAccuracy; double gunDamageHighAccuracy; double gunMaxOffsetHighAccuracy; double gunRangeLowAccuracy; double gunDamageLowAccuracy; double gunMaxOffsetLowAccuracy; double gunFireDelay; double gunProjectileSpeed; bool gunAttacksAir; bool gunAttacksGround; bool gunSplashRadius; double gunProximityDistance; double gunUpgradeRangeAmountMultiplier; double gunUpgradeRangeCostMultiplier; double gunUpgradeRangeCost; double gunUpgradeDamageAmountMultiplier; double gunUpgradeDamageCostMultiplier; double gunUpgradeDamageCost; int gunMaxUpgradeLevel; int gunRangeLevel; int gunDamageLevel;

signals:
    void rowChanged(int newRow);
    void colChanged(int newCol);
    void gunVisualChanged(QObject* newObj);
    void gunTypeChanged(int newGunType);
    void rangeLowAccuracyChanged(double newRange);
    void damageLowAccuracyChanged(double newDamage);
    void upgradeRangeAmountChanged(double newAmt);
    void upgradeDamageAmountChanged(double newAmt);
    void upgradeRangeCostChanged(double newAmt);


    void gunDamageChanged(double gunDamage);
  void gunRangeChanged(double gunRange);
   void gunRangeHighAccuracyChanged(double gunRangeHighAccuracy);
  void gunDamageHighAccuracyChanged(double gunDamageHighAccuracy);
   void gunMaxOffsetHighAccuracyChanged(double gunMaxOffsetHighAccuracy);
   void gunRangeLowAccuracyChanged(double gunRangeLowAccuracy);
  void gunDamageLowAccuracyChanged(double gunDamageLowAccuracy);
  void gunMaxOffsetLowAccuracyChanged(double gunMaxOffsetLowAccuracy);
  void gunFireDelayChanged(double gunFireDelay);
  void gunProjectileSpeedChanged(double gunProjectileSpeed);
  void gunAttacksAirChanged(bool gunAttacksAir);
  void gunSplashRadiusChanged(bool gunSplashRadius);
  void gunAttacksGroundChanged(bool gunAttacksGround);
  void gunProximityDistanceChanged(double gunProximityDistance);
  void gunUpgradeRangeAmountMultiplierChanged(double gunUpgradeRangeAmountMultiplier);
  void gunUpgradeRangeCostMultiplierChanged(double gunUpgradeRangeCostMultiplier);
  void gunUpgradeRangeCostChanged(double gunUpgradeRangeCost);
  void gunUpgradeDamageAmountMultiplierChanged(double gunUpgradeDamageAmountMultiplier);
  void gunUpgradeDamageCostMultiplierChanged(double gunUpgradeDamageCostMultiplier);
  void gunUpgradeDamageCostChanged(double gunUpgradeDamageCost);
  void gunMaxUpgradeLevelChanged(int gunMaxUpgradeLevel);
  void gunRangeLevelChanged(int gunRangeLevel);
  void gunDamageLevelChanged(int gunDamageLevel);



public slots:
};

#endif // GUN_H
