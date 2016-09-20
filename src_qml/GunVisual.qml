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

    function centerX() { return x + (width * 0.5); }
    function centerY() { return y + (height * 0.5); }


    Rectangle {


        color: "black"
        opacity: 0.7
        border.width: 2
        border.color: "white"

        width: parent.width
        height: parent.height
        id: rect


        anchors.centerIn: parent



    }

    signal request_connect(Gun i_gun);
    signal request_disconnect(Gun i_gun);
    signal muzzle_flash(var x, var y);
    function receive_fire_order(i_fire_group) {

        if (((isArmed == true) && (gun.gunType == 2) && ((i_fire_group % 2) == 0)) || ((isArmed == true) && (parseInt(i_fire_group) == fireGroup))) {
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
                        fire_projectile(closest_sqsquareVisualx + ((gun.gunMaxOffsetLowAccuracy * 0.5) - (2 * Math.random() * gun.gunMaxOffsetLowAccuracy)), closest_sqsquareVisualy + ((gun.gunMaxOffsetLowAccuracy * 0.5) - (2 * Math.random() * gun.gunMaxOffsetHighAccuracy)), closest_sqsquareVisual);

                        next_fire = parseInt(Date.now() + gun.gunFireDelay);
                    }
                }
            }
        }
    }


    function add_ammo_round(projectileVisualObject) {
        ammo.push(projectileVisualObject);

    }
    function fire_projectile(targetX, targetY, targetSquareVisual) {

        var _ammo = ammo;
        var _bullets = bullets;
        for (var c=0; c<_ammo.length; c++) {
            var bullet = _ammo[c];
            if (bullet != null) {
                bullet.target_x = targetX;
                bullet.target_y = targetY;
                bullet.finito = false;
                bullet.target_squareVisual = targetSquareVisual
                //bullet.is_at_point.connect(test_point);
                bullet.startAnim();
                _bullets[c] = bullet;
                bullet.opacity = 1.0;

                _ammo[c] = null;
                //c = _ammo.length + 1;
                if (gun.gunType == 2) {
                    bullet.rotation = gunImage.rotation;
                    muzzle_flash(targetX, targetY);
                }
                break;

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
                  //  bullet.is_at_point.disconnect(test_point);
                    bullets[c] = null;
                    bullet.x = centerX();
                    bullet.y = centerY();
                    c = bullets.length + 1;
                }
            }
        }
    }
    property var availableTargetSquares: new Array

    function test_point(xval, yval, prox_dist) {
        console.log(xval + " " + yval + " " + prox_dist);
    }

    Image {
        source: "./images/guns/" + gun.gunType + ".png"
        anchors.centerIn: parent
        width: parent.width * 1.02
        height: parent.height * 1.02
        id: gunImage
        opacity: isArmed == true ? 1.0 : 0.8
        Behavior on width {
            NumberAnimation { duration: 300 }
        }
        Behavior on height {
            NumberAnimation { duration: 300 }
        }
        Behavior on rotation {
            NumberAnimation {  duration: 300 }
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

        find_target3();


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



    function isEnemyInRange(enemyX, enemyY) {
        var radius = getRange();
        var dx = centerX() - enemyX;
        var dy = centerY() - enemyY;
        dx *= dx;
        dy *= dy;
        var distanceSquared = dx + dy;
        var radiusSquared = radius * radius;
        return distanceSquared <= radiusSquared;
    }

    function centerPoint(v1, v2) {
        var c1 = Math.abs(v2 - v1);
        c1 *= 0.5;
        return Math.min(v1, v2) + c1;
    }

    function find_target2() {
        var tmplist = game.board.attackers;

        var best_length = 999999;
        var best_attacker = null;
        var best_cx = 0;
        var best_cy = 0;
        for (var i=0; i<tmplist.length; i++) {
            var tmp_attacker = tmplist[i];
            if ((tmp_attacker != null) && (tmp_attacker.attackerVisual != null)) {
                var tmp_attacker_cur = tmp_attacker.current.squareVisual;
                var tmp_attacker_target = tmp_attacker.target.squareVisual;
                var cx = centerPoint(tmp_attacker_cur.x, tmp_attacker_target.x);
                var cy = centerPoint(tmp_attacker_cur.y, tmp_attacker_target.y);
                if (isEnemyInRange(cx, cy)) {
                    if (tmp_attacker.distanceToEnd < best_length) {
                        best_length = tmp_attacker.distanceToEnd;
                        best_attacker = tmp_attacker;
                        best_cx = cx;
                        best_cy = cy;
                    }
                }

            }
        }
        if (best_attacker != null) {
            var _ammo = ammo;
            var _bullets = bullets;
            var bullet;
            for (var c=0; c<_ammo.length; c++) {
                bullet = _ammo[c];
                if (bullet != null) {
                    bullet.target_x = best_cx;
                    bullet.target_y = best_cy;

                }
            }
            for (var c=0; c<_bullets.length; c++) {
                bullet = _bullets[c];
                if (bullet != null) {
                    bullet.target_x = best_cx;
                    bullet.target_y = best_cy;
                }
            }

            closest_sq = best_attacker.target;

        }

    }

function find_target3() {
    targetDistance = 99999;
    closest_sq = null;
    var _availableTargetSquares = availableTargetSquares;
    for (var i=0; i<_availableTargetSquares.length; i++) {
        var tmp_sq = _availableTargetSquares[i];
        if (tmp_sq.squareVisual.isActiveTarget == true) {
            if (tmp_sq.squareVisual.distanceToEnd <= targetDistance) {
                closest_sq = tmp_sq;
                targetDistance = tmp_sq.squareVisual.distanceToEnd;
            } else {
                if (closest_sq == null) {
                    closest_sq = tmp_sq;
                    targetDistance = tmp_sq.squareVisual.distanceToEnd;
                }

            }

        }
    }

}
    function find_target() {
        //closest_sq = null;
        //targetDistance = 5000;
        var found_enemy = false;
        var _availableTargetSquares = availableTargetSquares;
        for (var i=0; i<_availableTargetSquares.length; i++) {
            var tmp_sq = _availableTargetSquares[i];
            if (closest_sq == null) {
                closest_sq = tmp_sq;
            }

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
            //if (isArmed == true) { request_disconnect(gun); targetDistance = 99999; }
        } else {
            if (closest_sq != null) {
                if (closest_sq.squareVisual.isActiveTarget == false) {
                    targetDistance = 9999;
                    closest_sq = null;

                }
            } else {

            }
        }

    }

    function getRange(rangeLevel) {
        if (gun != null) {

            var rangeVal = rangeLevel * gun.gunRange * gun.gunUpgradeRangeAmountMultiplier;
            return rangeVal;

        } else {
            return 0;
        }
    }
    function getRangeCost(rangeLevel) {
        return getRangeUpgradeCost(rangeLevel);
    }
    function getDamageCost(damageLevel) {
        return getDamageUpgradeCost(damageLevel);
    }

    function getRangeUpgradeCost(rangeLevel) {
        var rangeCost = rangeLevel * gun.gunUpgradeRangeCostMultiplier * gun.gunUpgradeRangeCost;
        return Math.round(rangeCost)
    }
    function getDamageUpgradeCost(damageLevel) {
        var damageCost = damageLevel * gun.gunUpgradeDamageCostMultiplier * gun.gunUpgradeDamageCost;
        return damageCost;
    }

    function getDamage(damageLevel) {
        if (gun != null) {

            var damageVal = damageLevel * gun.gunDamage * gun.gunUpgradeDamageAmountMultiplier;
            return damageVal;

        } else {
            return 0;
        }
    }

}
