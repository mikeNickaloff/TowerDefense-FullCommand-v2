#ifndef ATTACKER_H
#define ATTACKER_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>
#include <QVariant>
#include <QQuickItem>
class Square;
class Game;
class Board;
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
    Q_PROPERTY(int startX MEMBER attacker_startX NOTIFY attacker_startX_changed)
    Q_PROPERTY(int endX MEMBER attacker_endX NOTIFY attacker_endX_changed)
    Q_PROPERTY(int startY MEMBER attacker_startX NOTIFY attacker_startY_changed)
    Q_PROPERTY(int endY MEMBER attacker_endX NOTIFY attacker_endY_changed)
    Q_PROPERTY(Game* game MEMBER m_game NOTIFY game_changed)
    Q_PROPERTY(Attacker* attacker READ thisObject)

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

    int attacker_startX;
    int attacker_startY;
    int attacker_endX;
    int attacker_endY;
    Game* m_game;
    Attacker* thisObject() { return this; }

signals:
    void speedChanged(QVariant newSpeed);
    void attackerTypeChanged(int newAttackerType);
    void currentChanged(QVariant newCurrent);
    void targetChanged(QVariant newTarget);
    void xposChanged(QVariant newVal);
    void yposChanged(QVariant newVal);
    void attackerVisualChanged(QObject* newObj);
    void healthChanged(QVariant newVal);
    void attacker_startX_changed(int new_startX);
    void attacker_startY_changed(int new_startY);
    void attacker_endX_changed(int new_endX);
    void attacker_endY_changed(int new_endY);
    void game_changed(Game* new_game);
    void show_particles_fire(QVariant xPos, QVariant yPos);
    void show_particles_flash(QVariant xPos, QVariant yPos);
    void show_particles_tiny(QVariant xPos, QVariant yPos);
    void removeAttacker(Attacker* attacker);
    void attackerPathFinished(Attacker* attacker);

public slots:
    void next_target();
    void clear_path();
    void add_square_to_path(Square* i_square);


};

#endif // ATTACKER_H
