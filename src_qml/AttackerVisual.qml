import QtQuick 2.5
import com.towerdefense.fullcommand 2.0
import "../src_js/logic.js" as Logic


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
    property Game game;
    property Square i_square;

    function get_shortest_path(c1, r1, c2, r2) {
        return Logic.get_shortest_path(c1, r1, c2, r2);
    }


    ParallelAnimation {
           running: true;
           id: anim1
           NumberAnimation {  target: viz; property: "x"; to:  endX; duration: 1000 }
           NumberAnimation {  target: viz; property: "y"; to: endY; duration: 1000 }
           onStopped: {

               attacker.next_target();
               attacker.target.squareVisual.isActiveTarget = true;
               attacker.current.squareVisual.isActiveTarget = false;
               var i_result = game.board.check_for_gun_placement(attacker.target);

               if (i_result == true) {
                   attacker.target.squareVisual.isActiveTarget = false;
                   // generate a new path
                   var shRoute = get_shortest_path(attacker.current.col ,attacker.current.row, Math.round(game.board.colCount * 0.5), game.board.rowCount - 1);
                   if (shRoute[2] != null) {
                       attacker.clear_path();
                    //   console.log(shRoute.length + " - " + shRoute);
                       var q = 0;
                       //var pathArray = [][2];
                       attacker.add_square_to_path(attacker.current);
                       while (shRoute[q] != null) {

                           var tmpRow = parseInt(shRoute[q][1]);
                           var tmpCol = parseInt(shRoute[q][0]);
                           var isEnd = game.board.is_end_square(tmpRow, tmpCol);
                           if (isEnd == false) {
                               i_square = game.board.find_square(parseInt(shRoute[q][1]), parseInt(shRoute[q][0]));
                               attacker.add_square_to_path(i_square);
                           }
                           q++;


                           //console.log(nd);
                       }

                       attacker.next_target();

                   } else {

                        console.log("attacker is trapped");
                   }


               } else {
                   // dont worry about it

               }

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
