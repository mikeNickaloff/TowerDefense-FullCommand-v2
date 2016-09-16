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

    ParallelAnimation {
        running: true;
        id: anim1

        XAnimator {  target: viz; from: startX; to:  endX; duration: (Math.abs(viz.x - endX) / attacker.speed) * 150 }
        YAnimator {  target: viz;  from: startY; to: endY; duration: (Math.abs(viz.y - endY) / attacker.speed) * 150 }

       onStopped: {


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

                    attacker.next_target();
                    attacker.target.squareVisual.projectile_hit.connect(projectile_hit);
                    restart();

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
                    restart();
                } else {
                    attacker.target.squareVisual.projectile_hit.disconnect(viz.projectile_hit);
                    attackerPathFinished(attacker);
                }
            }



            //  attacker.target = attackertarget;
            // attacker.current = attackercurrent;
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
