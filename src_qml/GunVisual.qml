import QtQuick 2.0
import com.towerdefense.fullcommand 2.0


Item {

    property Gun gun
    property AttackerVisual target
    property var next_fire: 1
    property int targetDistance: 255
    property Square closest_sq;
    property var ammo: new Array(4);
    property var bullets: new Array(4);

    Rectangle {


        color: "transparent"
        width: parent.width
        height: parent.height
        id: rect


        anchors.centerIn: parent



    }

    function add_ammo_round(projectileVisualObject) {
        ammo.push(projectileVisualObject);

    }
    function fire_projectile(targetX, targetY) {

        for (var c=0; c<ammo.length; c++) {
            var bullet = ammo[c];
            if (bullet != null) {
               bullet.target_x = targetX;
               bullet.target_y = targetY;
              bullet.finito = false;
                bullet.startAnim();
                bullets[c] = bullet;
                bullet.opacity = 1.0;
                ammo[c] = null;
                c = ammo.length + 1;

            }
        }

    }
    function check_projectiles() {
        for (var c=0; c<bullets.length; c++) {
                var bullet = bullets[c];
            if (bullet != null) {
                if (bullet.finito == true) {
                    ammo[c] = bullet;
                    bullet.opacity = 0;
                    bullets[c] = null;
                    bullet.x = bullet.origin_x;
                    bullet.y = bullet.origin_y;
                    c = bullets.length + 1;
                }
            }
        }
    }
    property var availableTargetSquares: new Array
    Image {
        source: "./images/guns/" + gun.gunType + ".png"
        anchors.centerIn: parent
        width: parent.width * 1.02
        height: parent.height * 1.02
        id: gunImage


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
            if (gunImage.rotation != tmpAngle) {
                gunImage.rotation = tmpAngle;
            }


        }

    }


}
