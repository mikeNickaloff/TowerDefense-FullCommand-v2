#ifndef SCOREHUD_H
#define SCOREHUD_H

#include <QtCore/qglobal.h>
#if QT_VERSION >= 0x050000
#include <QQuickItem>
#else
#endif

class ScoreHUD : public QQuickItem
{
    Q_OBJECT
public:
    ScoreHUD();

signals:

public slots:
};

#endif // SCOREHUD_H
