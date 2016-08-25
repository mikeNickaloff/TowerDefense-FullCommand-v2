#ifndef TOWERINFO_H
#define TOWERINFO_H

#include <QtCore/qglobal.h>
#if QT_VERSION >= 0x050000
#include <QQuickItem>
#else
#endif

class TowerInfo : public QQuickItem
{
    Q_OBJECT
public:
    TowerInfo();

signals:

public slots:
};

#endif // TOWERINFO_H