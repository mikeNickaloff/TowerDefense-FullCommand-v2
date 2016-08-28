#include "projectile.h"

Projectile::Projectile(QObject *parent) : QQuickItem()
{




}

void Projectile::initialize(QVariant i_origin_x, QVariant i_origin_y, QVariant i_ctx, QVariant i_cty, QVariant i_speed, QVariant i_max_dist, QVariant i_projectile_type, QVariant i_proximity_dist, QVariant i_splash_distance, QVariant i_max_damage, QVariant i_min_damage)
{
    m_origin_x = i_origin_x;
     m_origin_y =  i_origin_y;
    m_ctx =  i_ctx;
    m_cty =  i_cty;
    m_speed =  i_speed;
    m_max_dist =  i_max_dist;
    m_projectile_type =  i_projectile_type;
    m_proximity_dist =  i_proximity_dist;
    m_splash_distance =  i_splash_distance;
    m_max_damage =  i_max_damage;
    m_min_damage =  i_min_damage;

    QObject::setProperty("origin_x", m_origin_x);
    QObject::setProperty("origin_y", m_origin_y);
    QObject::setProperty("ctx", m_ctx);
    QObject::setProperty("cty", m_cty);
    QObject::setProperty("speed", m_speed);
    QObject::setProperty("max_dist", m_max_dist);
    QObject::setProperty("projectile_type", m_projectile_type);
    QObject::setProperty("proximity_dist", m_proximity_dist);
    QObject::setProperty("splash_distance", m_splash_distance);
    QObject::setProperty("max_damage", m_max_damage);
    QObject::setProperty("min_damage", m_min_damage);

}
