#ifndef MAP_H
#define MAP_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>

class Square;
class Wall;
class Start;
class End;

class Map : public QObject
{
    Q_PROPERTY(int rowCount MEMBER rowCount NOTIFY rowCountChanged)
    Q_PROPERTY(int colCount MEMBER colCount NOTIFY colCountChanged)
    Q_OBJECT
public:
     Map(QObject *parent = 0);
     int rowCount;
     int colCount;

signals:
     void rowCountChanged(int newCount);
     void colCountChanged(int newCount);

     // signals sent to Game object which forwards to Board object
     void placeWall(int row, int col);
     void placeStart(int row, int col);
     void placeEnd(int row, int col);
     void placeSquare(int row, int col);
public slots:
     void create_blank_map();
};

#endif // MAP_H
