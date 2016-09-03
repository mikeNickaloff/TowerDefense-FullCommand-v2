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


  /* PropertyAnimation { id: xanim; target: viz; property: "x"; easing.period: 0.25; easing.amplitude: 0.15; easing.type: Easing.OutElastic; duration: 950;  to: endX; duration: 30 * (attacker.target.squareVisual.width / attacker.speed) }


   PropertyAnimation { id: yanim; target: viz; property: "y"; to: endY; duration: 30 * (attacker.target.squareVisual.width / attacker.speed) } (
*/

    ParallelAnimation {
           running: false;
           id: anim1
           NumberAnimation {  target: viz; property: "x"; to:  endX; duration: 1000 }
           NumberAnimation {  target: viz; property: "y"; to: endY; duration: 1000 }
           onStopped: {
               attacker.next_target();
               waiting_for_waypoint = true;
           }
       }
    function startAnim() {
        if (!anim1.running) {
            anim1.restart();
        }
    }

    function step() {




        var oldTL = truelength(x, y, endX, endY);
             x += ecdx;
        y += ecdy;
        attacker.xpos = x;
        attacker.ypos = y;
        //xanim.to = endX;
        //yanim.to = endY;
        //if (xanim.running == false) { xanim.start(); }
        //if (yanim.running == false) { yanim.start(); }
         //  x += (ecdx * Math.abs(attacker.target.col - attacker.current.col));
          // y += (ecdy * Math.abs(attacker.target.row - attacker.current.row));
           var newTL = truelength(x, y, endX, endY);

        if (newTL > oldTL) {
              x = endX;

              y = endY;
            attacker.xpos = x;
            attacker.ypos = y;
              attacker.next_target();
              waiting_for_waypoint = true;
            if (attacker.atEndOfPath) {

            }
          }



    }

    function truelength(x1, y1, x2, y2) {
        var tl = Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
        return tl;
    }
}
