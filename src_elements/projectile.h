#ifndef PROJECTILE_H
#define PROJECTILE_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>
#include <QQuickItem>


class Projectile : public QQuickItem
{
    Q_OBJECT

public:
    explicit Projectile(QObject *parent = 0);


    QVariant m_origin_x;
    QVariant m_origin_y;
    QVariant m_ctx;
    QVariant m_cty;
    QVariant m_speed;
    QVariant m_max_dist;
    QVariant m_projectile_type;
    QVariant m_proximity_dist;
    QVariant m_splash_distance;
    QVariant m_max_damage;
    QVariant m_min_damage;
signals:

public slots:
    void initialize(QVariant i_origin_x, QVariant i_origin_y, QVariant i_ctx, QVariant i_cty, QVariant i_speed, QVariant i_max_dist, QVariant i_projectile_type, QVariant i_proximity_dist, QVariant i_splash_distance, QVariant i_max_damage, QVariant i_min_damage );
};

#endif // PROJECTILE_H
