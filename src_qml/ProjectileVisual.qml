import QtQuick 2.5
import com.towerdefense.fullcommand 2.0


Item {
    property var origin_x;
    property var origin_y;
    property var ctx;
    property var cty;
    property var speed;
    property var max_dist;
    property var projectile_type;
    property var proximity_dist;
    property var splash_distance;
    property var max_damage;
    property var min_damage;
    property var target_x;
    property var target_y;
    property bool finito: false;
    id: proj


  /*  Rectangle {
        border.color: "black"
        border.width: 2
        color: "gray"
        width: parent.width
        height: parent.height
        id: rect

        anchors.centerIn: parent



    } */
     property var possibleHitSquares: new Array

    signal arrivedAtTarget(var i_target_x, var i_target_y, var i_min_damage, var i_max_damage, var i_splash_distance);

    ParallelAnimation {
           running: false;
           id: anim1
           NumberAnimation {  target: proj; property: "x"; from: origin_x; to:  target_x; duration: 200 }
           NumberAnimation {  target: proj; property: "y"; from: origin_y; to: target_y; duration: 200 }
           onStopped: {
             finito = true;
             arrivedAtTarget(target_x, target_y, min_damage, max_damage, splash_distance);
           }
       }
    function startAnim() {
        if (!anim1.running) {
            finito = false;
            anim1.restart();
        }
    }

    Image {
        source: "./images/projectiles/" + projectile_type + ".png"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

    }

}
