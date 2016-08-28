import QtQuick 2.0
import com.towerdefense.fullcommand 2.0


Item {
    property Attacker attacker
    Image {
        source: "./images/attackers/" + attacker.attackerType + ".png"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

    }
   property var startX
    property var startY
    property var endX
    property var endY

    property var waiting_for_waypoint;
    property var ecdx;
    property var ecdy;

    function step() {



        var oldTL = truelength(x, y, endX, endY);
             x += ecdx;
        y += ecdy;
        attacker.xpos = x;
        attacker.ypos = y;
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
