import QtQuick 2.0
import com.towerdefense.fullcommand 2.0


Item {

    property Gun gun
    property AttackerVisual target
    property var next_fire: 1
    property int targetDistance: 255
    property Square closest_sq;
  /*  Rectangle {
        border.color: "black"
        border.width: 2
        color: "gray"
        width: parent.width
        height: parent.height
        id: rect

        anchors.centerIn: parent



    } */
    property var availableTargetSquares: new Array
    Image {
        source: "./images/guns/" + gun.gunType + ".png"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

    }
    function find_target() {
        closest_sq = null;
        targetDistance = 5000;
        for (var i=0; i<availableTargetSquares.length; i++) {
            var tmp_sq = availableTargetSquares[i];
            if (tmp_sq != null) {

                 if (tmp_sq.squareVisual.isActiveTarget == true) {
                     if (tmp_sq.squareVisual.distanceToEnd < targetDistance) {
                         targetDistance = tmp_sq.squareVisual.distanceToEnd;
                         closest_sq = tmp_sq;
                     }
                 }

            }
        }
        if (closest_sq != null) {
            var tmpAngle = angleTo(x, y, closest_sq.squareVisual.x, closest_sq.squareVisual.y);
            if (rotation != tmpAngle) {
                rotation = tmpAngle;
            }


        }

    }


}
