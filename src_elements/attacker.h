#ifndef ATTACKER_H
#define ATTACKER_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>
#include <QVariant>
#include <QQuickItem>
class Square;
class Attacker : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant speed MEMBER m_speed NOTIFY speedChanged)
    Q_PROPERTY(int attackerType MEMBER m_attackerType NOTIFY attackerTypeChanged)
    Q_PROPERTY(QVariant current MEMBER m_current NOTIFY currentChanged)
    Q_PROPERTY(QVariant target MEMBER m_target NOTIFY targetChanged)
    Q_PROPERTY(QVariant xpos MEMBER m_xpos NOTIFY xposChanged)
    Q_PROPERTY(QVariant ypos MEMBER m_ypos NOTIFY yposChanged)
    Q_PROPERTY(QVariant health MEMBER m_health NOTIFY healthChanged)
    Q_PROPERTY(QObject* attackerVisual MEMBER m_attackerVisual NOTIFY attackerVisualChanged)
    Q_PROPERTY(bool atEndOfPath READ isAtEndOfPath)
    Q_PROPERTY(QVariant distanceToEnd READ m_path_count)

public:
    explicit Attacker(QObject *parent = 0);
    QList<Square*> m_path;
    QVariant m_current;
    QVariant m_target;

    //pixels per frame
    QVariant m_speed;
    int m_attackerType;
    QVariant m_xpos;
    QVariant m_ypos;
    QObject* m_attackerVisual;
    Q_INVOKABLE void set_attackerVisual(QObject* i_attackerVisual) {
        m_attackerVisual = i_attackerVisual;
        //QQmlEngine::setObjectOwnership(m_squareVisual, QQmlEngine::JavaScriptOwnership);
    }

    Q_INVOKABLE bool check_collision(int i_x, int i_y, double i_prox_dist);



    bool isAtEndOfPath() {
        if (m_path.count() < 2) { return true; }
        return false;
    }
    QVariant m_health;
    QVariant m_path_count() { return m_path.count(); }

signals:
    void speedChanged(QVariant newSpeed);
    void attackerTypeChanged(int newAttackerType);
    void currentChanged(QVariant newCurrent);
    void targetChanged(QVariant newTarget);
    void xposChanged(QVariant newVal);
    void yposChanged(QVariant newVal);
    void attackerVisualChanged(QObject* newObj);
    void healthChanged(QVariant newVal);

public slots:
    void next_target();
    void clear_path();
    void add_square_to_path(Square* i_square);


};

#endif // ATTACKER_H
