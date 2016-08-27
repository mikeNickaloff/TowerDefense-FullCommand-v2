#ifndef SQUARE_H
#define SQUARE_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>
#include <QQuickItem>
#include <QQmlEngine>
#include <QVariant>
class Gun;
class Square :  public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(int row MEMBER m_row NOTIFY rowChanged)
    Q_PROPERTY(int col MEMBER m_col NOTIFY colChanged)
    Q_PROPERTY(QObject* squareVisual MEMBER m_squareVisual NOTIFY squareVisualChanged)
public:
    explicit Square(QObject *parent = 0);
    Gun* m_gun;
    int m_row;
    int m_col;
    QObject* m_squareVisual;
    Q_INVOKABLE void set_squareVisual(QObject* i_squareVisual) {
        m_squareVisual = i_squareVisual;
        //QQmlEngine::setObjectOwnership(m_squareVisual, QQmlEngine::JavaScriptOwnership);
    }

signals:

    void rowChanged(int newRow);
    void colChanged(int newCol);
    void squareVisualChanged(QVariant newObj);
public slots:

};

#endif // SQUARE_H
