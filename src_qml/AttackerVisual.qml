import QtQuick 2.5
import com.towerdefense.fullcommand 2.0


Item {
    property Attacker attacker
    Image {
        source: "./images/attackers/" + attacker.attackerType + ".png"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

    }
    id: viz
   property var startX
    property var startY
    property var endX
    property var endY

    property var waiting_for_waypoint;
    property var ecdx;
    property var ecdy;





    ParallelAnimation {
           running: true;
           id: anim1
           NumberAnimation {  target: viz; property: "x"; to:  endX; duration: 1000 }
           NumberAnimation {  target: viz; property: "y"; to: endY; duration: 1000 }
           onStopped: {

               attacker.next_target();
               attacker.target.squareVisual.isActiveTarget = true;
               attacker.current.squareVisual.isActiveTarget = false;

               if (attacker.speed > 0) {
                   startX = endX;
                   startY = endY;
                   endX = attacker.target.squareVisual.x
                   endY = attacker.target.squareVisual.y
                   attacker.target.squareVisual.distanceToEnd = attacker.distanceToEnd;
                   startAnim();
               } else {
                   attackerPathFinished(attacker);
               }
           }
       }
    signal attackerPathFinished(var attackerObject);
    function startAnim() {
        if (!anim1.running) {
            anim1.restart();
        }
    }



    function truelength(x1, y1, x2, y2) {
        var tl = Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
        return tl;
    }
}
