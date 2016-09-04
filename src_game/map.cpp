#include "map.h"
#include "../src_elements/square.h"
#include "../src_elements/wall.h"
#include "../src_elements/start.h"
#include "../src_elements/end.h"


Map::Map(QObject *parent) : QObject(parent)
{

}
void Map::create_blank_map() {
    this->rowCount = 15;
    this->colCount = 15;
    emit this->Map::rowCountChanged(rowCount);
    emit this->Map::colCountChanged(colCount);
    for (int i=0; i<rowCount; i++) {
        for (int j=0; j<colCount; j++) {
            bool placed = false;
            if ((i == 0) || (j == 0) || (i == (rowCount - 1)) || (j == (colCount - 1))) {

                if ((i == 0) && (j == qRound(colCount * 0.5))) { emit this->placeStart(i,j); placed = true; }
                if ((i == (rowCount - 1)) && (j == qRound(rowCount * 0.5))) { emit this->placeEnd(i,j); placed = true; }
               if (!placed) {
                   emit this->placeWall(i,j);
               }
            }
            if (!placed) {
                emit this->placeSquare(i,j);
            }
        }
    }

}
