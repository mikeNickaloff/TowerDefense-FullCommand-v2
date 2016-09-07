import QtQuick 2.0
import com.towerdefense.fullcommand 2.0


Item {

    property Gun gun
    property AttackerVisual target
    property var next_fire: 1
    property int targetDistance: 2550;
    property Square closest_sq: null;
    property Square tmp_closest_sq: null;
    property var ammo: new Array(4);
    property var bullets: new Array(4);
    property Game game;
    property int fireGroup: 0
    property bool isArmed: false

    Rectangle {


        color: "transparent"
        width: parent.width
        height: parent.height
        id: rect


        anchors.centerIn: parent



    }

    signal request_connect(Gun i_gun);
    signal request_disconnect(Gun i_gun);
    function receive_fire_order(i_fire_group) {

        if (parseInt(i_fire_group) == fireGroup) {
            if (next_fire < Date.now()) {
                if (closest_sq != null) {
                    //console.log("Order received -- assigning closest_sq props to tmp vars");
                    var closest_sqsquareVisual = closest_sq.squareVisual;
                    var closest_sqsquareVisualx = closest_sq.squareVisual.x
                    var closest_sqsquareVisualy = closest_sq.squareVisual.y
                    var _height = height;
                    var _width = width;
                    if (closest_sqsquareVisual.isActiveTarget == true) {
                        //create_projectile(gunP, gunObj.closest_sq.squareVisual.x + (gunObj.width * 0.5), gunObj.closest_sq.squareVisual.y + (gunObj.height * 0.5));
                        fire_projectile(closest_sqsquareVisualx + (_width * 0.5), closest_sqsquareVisualy + (_height * 0.5));

                        next_fire = parseInt(Date.now() + 1500);
                    }
                }
            }
        }
    }


    function add_ammo_round(projectileVisualObject) {
        ammo.push(projectileVisualObject);

    }
    function fire_projectile(targetX, targetY) {

        var _ammo = ammo;
        var _bullets = bullets;
        for (var c=0; c<_ammo.length; c++) {
            var bullet = _ammo[c];
            if (bullet != null) {
                bullet.target_x = targetX;
                bullet.target_y = targetY;
                bullet.finito = false;
                bullet.startAnim();
                _bullets[c] = bullet;
                bullet.opacity = 1.0;
                _ammo[c] = null;
                c = _ammo.length + 1;

            }
        }
        ammo = _ammo;
        bullets = _bullets;

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
        Behavior on width {
            NumberAnimation { duration: 300 }
        }
        Behavior on height {
            NumberAnimation { duration: 300 }
        }
       // Behavior on rotation {
        //    NumberAnimation { duration: 50 }
       // }


    }
    function remove_target_square(i_squareObj) {
        var new_target_squares = [];
        for (var i=0; i<availableTargetSquares.length; i++) {
            var tmp_sq = availableTargetSquares[i];
            if (i_squareObj != tmp_sq) { new_target_squares.push(tmp_sq); }
        }
        availableTargetSquares = new_target_squares;

    }



    function check_new_target(i_isActiveTarget,row, col, i_distanceToEnd) {
        var _closest_sq = closest_sq;
        var _targetDistance = targetDistance;
        if (isArmed == false) { request_connect(gun); }
        if  (_targetDistance > i_distanceToEnd)  {
            tmp_closest_sq = game.board.find_square(row, col);
            if ((tmp_closest_sq != _closest_sq) || (_closest_sq == null)) {
                _closest_sq = tmp_closest_sq;
                targetDistance = i_distanceToEnd;
                if (_closest_sq != null) {
                    var _x = x;
                    var _y = y;
                    var gunImagerotation = gunImage.rotation;
                    var closest_sqsquareVisual = _closest_sq.squareVisual;
                    var tmpAngle = angleTo(_x, _y, closest_sqsquareVisual.x, closest_sqsquareVisual.y);
                    if (gunImagerotation != tmpAngle) {
                        gunImage.rotation = tmpAngle;
                    }
                    closest_sq = _closest_sq;
                }
            }
        }

    }
    function lost_active_target(i_square) {

            find_target();


      // if (closest_sq.squareVisual.isActiveTarget == false) {
       //    targetDistance = 5000;
       //}

        /* if ((i_square == closest_sq) || (closest_sq == null)) {
            if (closest_sq == null) {
                if (availableTargetSquares.indexOf(i_square) > -1) {
                    find_target();
                }
            } else {
                find_target();
            }
        } else {
            if (availableTargetSquares.indexOf(i_square) > -1) {
                find_target();
            }
        } */
    }



    function find_target() {
         //closest_sq = null;
         targetDistance = 5000;
        var found_enemy = false;
        var _availableTargetSquares = availableTargetSquares;
        for (var i=0; i<_availableTargetSquares.length; i++) {
            var tmp_sq = _availableTargetSquares[i];
            if (tmp_sq != null) {
                var tmp_sqsquareVisual = tmp_sq.squareVisual;
                if (tmp_sqsquareVisual.isActiveTarget == true) {
                    found_enemy = true;
                    break;
                }


            }
        }
        /* if (closest_sq != null) {
            var tmpAngle = angleTo(x, y, closest_sq.squareVisual.x, closest_sq.squareVisual.y);
            if (gunImage.rotation != tmpAngle) {
                gunImage.rotation = tmpAngle;
            }


        } */
        if (found_enemy == false) {
           if (isArmed == true) { request_disconnect(gun); }
        }

    }


}
