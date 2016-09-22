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


    signal show_particles_fire(var xPos, var yPos);
    signal show_particles_flash(var xPos, var yPos);
    signal show_particles_tiny(var xPos, var yPos);
    signal removeAttacker(var attacker);

    function get_shortest_path(c1, r1, c2, r2) {
        return Logic.get_shortest_path(c1, r1, c2, r2);
    }

    function projectile_hit(min_damage, max_damage, splash_distance, projectile_type) {
        if (viz) {
            if (projectile_type == 1) {
                viz.show_particles_flash(endX + Math.random() * splash_distance, endY + Math.random() * splash_distance);
                //viz.show_particles_fire(endX + Math.random() * splash_distance, endY + Math.random() * splash_distance);

            }
            if (projectile_type == 2) {
                // viz.show_particles_flash(endX + Math.random() * splash_distance, endY + Math.random() * splash_distance);
                viz.show_particles_tiny(endX + Math.random() * splash_distance, endY + Math.random() * splash_distance);
            }

            if (attacker != null) {
                var attackerHealth = attacker.health;
                attackerHealth -= (Math.random() * (max_damage - min_damage)) + min_damage
                if (attackerHealth < 1) {
                    game.money += game.level;
                    viz.show_particles_fire(endX + Math.random() * splash_distance, endY + Math.random() * splash_distance);
                    viz.removeAttacker(attacker);


                }
                attacker.health = attackerHealth;
            }
        }
    }

    function get_property_to_animate() {
        if (startX != endX) { return "x";
        } else {
            if (startY != endY) {
                return "y";
            } else {
                return "opacity";
            }
        }
    }

    function get_animation_duration() {
        return (Math.max(Math.abs(startX - endX), Math.abs(startY - endY)) / attacker.speed) * 150;
    }

    function get_animation_start() {
        if (startX != endX) { return startX; } else { return startY; }
    }
    function get_animation_end() {
        if (startX != endX) { return endX; } else { return endY; }
    }

    SequentialAnimation {
        running: false
        id: anim1

        PropertyAnimation { property: get_property_to_animate(); target: viz; from: get_animation_start(); to:  get_animation_end(); duration: get_animation_duration(); }
        //YAnimator {  target: viz;  from: startY; to: endY; duration: (Math.abs(startY - endY) / attacker.speed) * 200 }
        PauseAnimation {
            duration: 200
        }
        onStopped: { }
    }
    signal attackerPathFinished(var attackerObject);
    function startAnim() {
        if (!anim1.running) {
            anim1.restart();
        }
    }
    function stepOnce() {
        var step_x  = 0;
        var step_y = 0;
       if (startX > endX) { step_x = -1; }
       if (startX < endX) { step_x = 1; }
       if (startY > endY) { step_y = -1; }
       if (startY < endY) { step_y = 1; }
       var aspeed = attacker.speed;
       var osx = step_x * aspeed;
       var osy = step_y * aspeed;

       if ((Math.abs(x - endX) <= Math.abs(osx)) && (Math.abs(y - endY) <= Math.abs(osy))) {
           stepsComplete();
       }
       var  check_dx1  = (x + osx) - endX;
       var  check_dx2  = (x + osx + osx) - endX;
       var  check_dy1  = (y + osy) - endY;
       var  check_dy2  = (y + osy + osy) - endY;
       if ((Math.abs(check_dx1) < Math.abs(check_dx2)) || (Math.abs(check_dy1) < Math.abs(check_dy2))) {
        //attacker.next_target();
           //attacker.next_target();
           //startX = viz.x
           //startY = viz.y
           //endX = attacker.target.squareVisual.x
           //endY = attacker.target.squareVisual.y
           stepsComplete();
       } else {
           x += osx;
           y += osy;
       }
    }

    function stepsComplete() {




                   attacker.next_target();

                   var attackertarget = attacker.target;
                   var attackercurrent = attacker.current;
                   attacker.current.squareVisual.projectile_hit.disconnect(projectile_hit);

                   var attackertargetsquareVisual = attackertarget.squareVisual;
                   var attackercurrentsquareVisual = attackercurrent.squareVisual

                   attackertargetsquareVisual.projectile_hit.connect(viz.projectile_hit);


                   attackertargetsquareVisual.isActiveTarget = true;
                   attackercurrentsquareVisual.isActiveTarget = false;
                   var i_result = game.board.check_for_gun_placement(attackertarget);

                   if (i_result == true) {
                       attackertargetsquareVisual.isActiveTarget = false;
                       // generate a new path
                       var shRoute = get_shortest_path(attackercurrent.col ,attackercurrent.row, Math.round(game.board.colCount * 0.5), game.board.rowCount - 1);
                       if (shRoute[2] != null) {
                           attacker.clear_path();
                           //   console.log(shRoute.length + " - " + shRoute);
                           var q = 0;
                           //var pathArray = [][2];
                           attacker.add_square_to_path(attackercurrent);
                           var gameboard = game.board;
                           while (shRoute[q] != null) {

                               var tmpRow = parseInt(shRoute[q][1]);
                               var tmpCol = parseInt(shRoute[q][0]);
                               var isEnd = gameboard.is_end_square(tmpRow, tmpCol);
                               if (isEnd == false) {
                                   i_square = gameboard.find_square(parseInt(shRoute[q][1]), parseInt(shRoute[q][0]));
                                   attacker.add_square_to_path(i_square);
                               }
                               q++;


                               //console.log(nd);
                           }
                           console.log(JSON.stringify(shRoute));


                        //   attacker.next_target();
                           startX = viz.x
                           startY = viz.y
                           endX = attacker.target.squareVisual.x
                           endY = attacker.target.squareVisual.y
                           attacker.target.squareVisual.projectile_hit.connect(projectile_hit);
                          //stepsComplete();

                       } else {

                           console.log("attacker is trapped");
                       }


                   } else {
                       // dont worry about it
                       if (attacker.speed > 0) {
                           startX = endX;
                           startY = endY;
                           endX = attackertargetsquareVisual.x
                           endY = attackertargetsquareVisual.y
                           attackertargetsquareVisual.distanceToEnd = attacker.distanceToEnd;
                           //  startAnim();
                           //restart();
                           //stepsComplete();
                       } else {
                           attacker.target.squareVisual.projectile_hit.disconnect(viz.projectile_hit);
                           attackerPathFinished(attacker);
                       }
                   }



                   //  attacker.target = attackertarget;
                   // attacker.current = attackercurrent;
               }





    function truelength(x1, y1, x2, y2) {
        var tl = Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
        return tl;
    }
}
