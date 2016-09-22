import QtQuick 2.6
import QtQuick.Window 2.2
import com.towerdefense.fullcommand 2.0
import QtQuick.Particles 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2
import "src_js/logic.js" as Logic
import "src_qml"
Window {
    visible: true

    width: Screen.desktopAvailableWidth * 0.85
    height: Screen.desktopAvailableHeight * 0.85
    title: qsTr("Tower Defense - Complete Command v2 - 5.2 beta")
    color: "black"

    Component.onCompleted:  {
        animation_rotate_scene.start();
        particleOverlay.shellEmit(Math.random() * width, height * 0.5);

    }
    SequentialAnimation {
        id: animation_rotate_scene
        RotationAnimation {
            to: 35
            duration: 1000
            target: sceneRotation
            property: "angle"
            easing.type: Easing.InOutQuad
        }
        RotationAnimation {
            to: 35
            duration: 1000
            target: particleSceneRotation
            property: "angle"
            easing.type: Easing.InOutQuad
        }
    }
    ParallelAnimation {
        id: animation_translate_scene
        NumberAnimation {
            to: bg_x_translation
            duration: 100
            target: sceneTranslation
            property: "x"
        }
        NumberAnimation {
            to: bg_y_translation
            duration: 100
            target: sceneTranslation
            property: "y"
        }
        NumberAnimation {
            to: bg_x_translation
            duration: 100
            target: particleSceneTranslation
            property: "x"
        }
        NumberAnimation {
            to: bg_y_translation
            duration: 100
            target: particleSceneTranslation
            property: "y"
        }
    }
    property var bg_x_translation: 0
    property var bg_y_translation: 0
    Item {
        id: background
        width: Screen.desktopAvailableWidth * 0.85
        height: Screen.desktopAvailableHeight * 0.85 * 0.95
        Rectangle {
            color: "black"
            anchors.fill: parent
            z: -1
        }
        transform: [
            Rotation {
                id: sceneRotation
                axis.x: 1
                axis.y: 0
                axis.z: 0
                origin.x: width / 2
                origin.y: height / 2
            },
            Translate {
                id: sceneTranslation
                x: bg_x_translation
                y: bg_y_translation
            }
        ]



        anchors.top: scoreHUD.bottom


        /*

        Flickable {
            id: flick
            anchors.fill: parent
            contentWidth: 500
            contentHeight: 500
            z: 999
            PinchArea {
                width: Math.max(flick.contentWidth, flick.width)
                height: Math.max(flick.contentHeight, flick.height)

                property real initialWidth
                property real initialHeight
                //![0]
                onPinchStarted: {
                    initialWidth = flick.contentWidth
                    initialHeight = flick.contentHeight
                }

                onPinchUpdated: {
                    // adjust content pos due to drag
                    flick.contentX += pinch.previousCenter.x - pinch.center.x
                    flick.contentY += pinch.previousCenter.y - pinch.center.y

                    // resize content
                    flick.resizeContent(initialWidth * pinch.scale, initialHeight * pinch.scale, pinch.center)
                }

                onPinchFinished: {
                    // Move its content within bounds.
                    flick.returnToBounds()
                }
                //![0]

                Rectangle {
                    width: flick.contentWidth
                    height: flick.contentHeight
                    color: "white"
                    Image {
                        anchors.fill: parent
                        source: "./src_qml/images/guns/tanks.png"
                        MouseArea {
                            anchors.fill: parent
                            onDoubleClicked: {
                                flick.contentWidth = 500
                                flick.contentHeight = 500
                            }
                        }
                    }
                }
            }
        } */




    }



    ScoreHUDVisual {
        id: scoreHUD

        height: background.height * 0.05
        width: background.width
        x: 0
        y: 0
    }


    function create_tower_chooser() {
        towerChooser.visible = true;
        towerChooser.enabled = true;
        towerUpgradeMenu.visible = false;
        towerUpgradeMenu.enabled = false;
    }

    TowerChooserVisual {
        id: towerChooser;
        width: background.width * 0.2
        height: background.height * 0.8
        function toggle_menu(makeVisible) {
            towerChooser.visible = makeVisible;
            towerChooser.enabled = makeVisible;
            towerUpgradeMenu.visible = !makeVisible;
            towerUpgradeMenu.enabled = !makeVisible;
        }
    }



    TowerUpgradeMenuVisual {
        id: towerUpgradeMenu
        height: background.height * 0.75
        width: background.width * 0.42
    }


    Game {
        id: game


        Component.onCompleted: {
            game.createBoard();
            init_squares();
            towerUpgradeMenu.upgradeRange.connect(upgrade_range);
            towerUpgradeMenu.upgradeDamage.connect(upgrade_damage);
            towerUpgradeMenu.enabled = false;
            game.board.spent_cash.connect(cash_spent);

        }
        property var grid;
        property var finder;
        property var money: 500

        function cash_spent(amount) { money -= amount; }

        function upgrade_range(i_gun) {





            var gu = i_gun;

            var rangeLowAcc = gu.gunVisual.getRange(gu.gunRangeLevel) * gu.gunRangeLowAccuracy;
            //rangeLowAcc *= gu.upgradeRangeAmount;
            var rangeCost = gu.gunVisual.getRangeCost(gu.gunRangeLevel + 1);

            var squ = i_gun;
            var sqvis = i_gun.gunVisual;
            var gugunVisual = sqvis;
            var gugunVisualx = gugunVisual.x
            var gugunVisualy = gugunVisual.y
            var gugunVisualavailableTargetSquares = gu.gunVisual.availableTargetSquares;
            var squcol = squ.col;
            var squrow = squ.row;
            var sqviswidth = sqvis.width;
            var sqvisheight = sqvis.height;

            var min_sq_col = squcol - Math.round(rangeLowAcc / sqviswidth) - 1;
            var min_sq_row = squrow - Math.round(rangeLowAcc / sqvisheight) - 1;
            var max_sq_col = squcol + Math.round(rangeLowAcc / sqviswidth) + 1;
            var max_sq_row = squrow + Math.round(rangeLowAcc / sqviswidth) + 1;
            //fire_weapons.connect(gu.gunVisual.receive_fire_order);
            var gameboardsquares = game.board.squares;
            for (var w=0; w<gameboardsquares.length; w++) {

                var sqObj = gameboardsquares[w];
                var sqEl = sqObj.squareVisual;
                var sqElx = sqEl.x;
                var sqEly = sqEl.y;
                var sqObjrow = sqObj.row;
                var sqObjcol = sqObj.col;

                if ((sqObjrow >= min_sq_row) && (sqObjrow <= max_sq_row)) {
                    if ((sqObjcol >= min_sq_col) && (sqObjcol <= max_sq_col)) {



                        var TL = truelength(gugunVisualx, gugunVisualy, sqElx, sqEly);


                        // if (TL < rangeLowAcc) {
                        //if (i_gun.gunVisual.isEnemyInRange(sqElx, sqEly)) {
                        if (TL < gu.gunVisual.getRange(gu.gunRangeLevel)) {
                            if (gugunVisualavailableTargetSquares.indexOf(sqObj) < 0) {
                                gugunVisualavailableTargetSquares.push(sqObj);
                                sqEl.gunsInRange.push(gu);
                                //sqEl.isActiveTargetChanged.connect(gu.gunVisual.find_target);
                                i_gun.gunVisual.request_connect.connect(request_connect);
                                i_gun.gunVisual.request_disconnect.connect(request_disconnect);


                                sqEl.becameActiveTarget.connect(gugunVisual.check_new_target);
                                sqEl.lostActiveTarget.connect(gugunVisual.lost_active_target);
                            }

                        }
                    }
                }
            }
            gu.gunVisual.availableTargetSquares = gugunVisualavailableTargetSquares;
            gu.rangeLowAccuracy = rangeLowAcc;
            gu.gunRangeLevel++;
            game.cash_spent(rangeCost);
            var damage_new_level = towerUpgradeMenu.gun.gunVisual.getDamage(towerUpgradeMenu.gun.gunDamageLevel + 1);
            var range_new_level = towerUpgradeMenu.gun.gunVisual.getRange(towerUpgradeMenu.gun.gunRangeLevel + 1);
            towerUpgradeMenu.set_next_levels(range_new_level, damage_new_level);


        }
        function upgrade_damage(i_gun) {
            i_gun.damageLowAccuracy = i_gun.damageLowAccuracy * i_gun.upgradeDamageAmount;
            var damageCost = i_gun.gunVisual.getDamageCost(i_gun.gunDamageLevel + 1);
            game.cash_spent(damageCost);
            i_gun.gunDamageLevel++;

            for (var i=0; i<i_gun.gunVisual.ammo.length; i++) {
                var tmp_ammo = i_gun.gunVisual.ammo[i];
                var tmp_bullet = i_gun.gunVisual.bullets[i];
                if (tmp_ammo != null) {
                    tmp_ammo.min_damage = i_gun.gunVisual.getDamage(i_gun.gunDamageLevel) * i_gun.gunDamageLowAccuracy;
                    tmp_ammo.max_damage = i_gun.gunVisual.getDamage(i_gun.gunDamageLevel) * i_gun.gunDamageHighAccuracy;

                }
                if (tmp_bullet != null) {
                    tmp_bullet.min_damage = i_gun.gunVisual.getDamage(i_gun.gunDamageLevel) * i_gun.gunDamageLowAccuracy;
                    tmp_bullet.max_damage = i_gun.gunVisual.getDamage(i_gun.gunDamageLevel) * i_gun.gunDamageHighAccuracy;
                }

            }


            var damage_new_level = towerUpgradeMenu.gun.gunVisual.getDamage(towerUpgradeMenu.gun.gunDamageLevel + 1);
            var range_new_level = towerUpgradeMenu.gun.gunVisual.getRange(towerUpgradeMenu.gun.gunRangeLevel + 1);
            towerUpgradeMenu.set_next_levels(range_new_level, damage_new_level);
        }
    }

    function get_shortest_path(c1, r1, c2, r2) {
        return Logic.get_shortest_path(c1, r1, c2, r2);
    }


    property int numFireGroups:  6;
    property var squareHash: new Array(10);
    property var squareObjHash : new Array(10);
    property var gunHash: new Array(10);
    property var attackerHash: new Array(10);


    function get_fire_group(row, col) {

        var tmp = row + numFireGroups;
        tmp += (col * 3);
        var rv = (tmp % numFireGroups);
        return rv;
    }

    function clear_type_from_board(type_to_erase) {
        var bgch = background.children;
        for (var c=0; c<bgch.length; c++) {
            var obj = bgch[c];
            if (qmltypeof(obj, type_to_erase)) {
                obj.destroy();
            }

        }
    }

    function init_squares() {
        var component;
        component = Qt.createComponent("src_qml/SquareVisual.qml");
        var tmp_sq = game.board.squares;
        for (var u=0; u<tmp_sq.length; u++) {
            var squ = tmp_sq[u];
            if (component.status == Component.Ready) {
                var dynamicObject = component.createObject(background, { "square" : squ });
                dynamicObject.width = (background.width / game.board.colCount);
                dynamicObject.height = (background.height / game.board.rowCount);
                dynamicObject.x = (background.width / game.board.colCount) * squ.col;
                dynamicObject.y = (background.height / game.board.rowCount) * squ.row;
                squ.set_squareVisual(dynamicObject);
            }
        }

    }
    function update_squares() {
        var tmp_sq = game.board.squares;

        for (var u=0; u<tmp_sq.length; u++) {

            var squ = tmp_sq[u];
            var sqvis = squ.squareVisual;
            if (sqvis == null) {
                var component;
                component = Qt.createComponent("src_qml/SquareVisual.qml");
                if (component.status == Component.Ready) {
                    var dynamicObject = component.createObject(background, { "square" : squ });
                    dynamicObject.width = (background.width / game.board.colCount);
                    dynamicObject.height = (background.height / game.board.rowCount);
                    dynamicObject.x = (background.width / game.board.colCount) * squ.col;
                    dynamicObject.y = (background.height / game.board.rowCount) * squ.row;
                    squ.set_squareVisual(dynamicObject);
                }
            } else {
                sqvis.width = (background.width / game.board.colCount);
                sqvis.height = (background.height / game.board.rowCount);
                sqvis.x = (background.width / game.board.colCount) * squ.col;
                sqvis.y = (background.height / game.board.rowCount) * squ.row;
            }

        }
    }

    function init_guns() {
        clear_type_from_board("GunVisual");
        var component;
        component = Qt.createComponent("src_qml/GunVisual.qml");
        var tmp_gu = game.board.guns;
        for (var u=0; u<tmp_gu.length; u++) {
            var gu = tmp_gu[u];
            if (component.status == Component.Ready) {
                var dynamicObject = component.createObject(background, { "gun" : gu });
                dynamicObject.width = (background.width / game.board.colCount);
                dynamicObject.height = (background.height / game.board.rowCount);
                dynamicObject.x = (background.width / game.board.colCount) * gu.col;
                dynamicObject.y = (background.height / game.board.rowCount) * gu.row;
                gu.set_gunVisual(dynamicObject);


            }

        }

    }

    signal fire_weapons(var i_fire_group);
    function request_connect(i_gun) {
        i_gun.gunVisual.isArmed = true;
        fire_weapons.connect(i_gun.gunVisual.receive_fire_order);
    }
    function request_disconnect(i_gun) {
        i_gun.gunVisual.isArmed = false;
        fire_weapons.disconnect(i_gun.gunVisual.receive_fire_order);
    }

    function create_gun(row, col) {
        var component;
        component = Qt.createComponent("src_qml/GunVisual.qml");
        var tmp_gu = game.board.guns;
        for (var u=0; u<tmp_gu.length; u++) {
            var gu = tmp_gu[u];
            if ((gu.row == row) && (gu.col == col)) {
                if (component.status == Component.Ready) {
                    var dynamicObject = component.createObject(background, { "gun" : gu, "game" : game, "fireGroup" : get_fire_group(row, col) });
                    dynamicObject.width = (background.width / game.board.colCount);
                    dynamicObject.height = (background.height / game.board.rowCount);
                    dynamicObject.x = (background.width / game.board.colCount) * gu.col;
                    dynamicObject.y = (background.height / game.board.rowCount) * gu.row;
                    gu.set_gunVisual(dynamicObject);

                    var squ = gu;
                    var sqvis = dynamicObject;
                    var min_sq_col = squ.col - Math.round(gu.rangeLowAccuracy / sqvis.width) - 1;
                    var min_sq_row = squ.row - Math.round(gu.rangeLowAccuracy / sqvis.height) - 1;
                    var max_sq_col = squ.col + Math.round(gu.rangeLowAccuracy / sqvis.width) + 1;
                    var max_sq_row = squ.row + Math.round(gu.rangeLowAccuracy / sqvis.width) + 1;
                    gu.gunVisual.isArmed = false;
                    //gu.gunVisual.muzzle_flash.connect(particleOverlay.flashEmit);
                    // gu.gunVisual.muzzle_flash.connect(particleOverlay.tinyEmit);
                    //fire_weapons.connect(gu.gunVisual.receive_fire_order);
                    for (var w=0; w<game.board.squares.length; w++) {

                        var sqObj = game.board.squares[w];
                        var sqEl = sqObj.squareVisual;

                        if ((sqObj.row >= min_sq_row) && (sqObj.row <= max_sq_row)) {
                            if ((sqObj.col >= min_sq_col) && (sqObj.col <= max_sq_col)) {



                                var TL = truelength(gu.gunVisual.x, gu.gunVisual.y, sqEl.x, sqEl.y);


                                //if (TL < gu.rangeLowAccuracy) {
                                if (TL < gu.gunVisual.getRange(gu.gunRangeLevel)) {
                                    gu.gunVisual.availableTargetSquares.push(sqObj);
                                    sqEl.gunsInRange.push(gu);
                                    gu.gunVisual.request_connect.connect(request_connect);
                                    gu.gunVisual.request_disconnect.connect(request_disconnect);
                                    //sqEl.isActiveTargetChanged.connect(gu.gunVisual.find_target);
                                    sqEl.becameActiveTarget.connect(gu.gunVisual.check_new_target);
                                    sqEl.lostActiveTarget.connect(gu.gunVisual.lost_active_target);

                                }
                            }
                        }
                    }


                }
            }
            var b = 1;
            if (gu.gunType == 2) { b = 2; }
            for (var q=0; q<b; q++) {
                create_projectile(gu, gu.gunVisual.x, gu.gunVisual.y);
            }

        }
    }

    function update_guns() {
        var tmp_sq = game.board.guns;



        for (var u=0; u<tmp_sq.length; u++) {

            var squ = tmp_sq[u];
            var sqvis = squ.gunVisual;
            sqvis.width = (background.width / game.board.colCount);
            sqvis.height = (background.height / game.board.rowCount);
            sqvis.x = (background.width / game.board.colCount) * squ.col;
            sqvis.y = (background.height / game.board.rowCount) * squ.row;


            var gu = squ;


        }
    }

    function init_attackers() {






        var tmp_sq = game.board.attackers;




        for (var u=0; u<tmp_sq.length; u++) {
            create_atttacker(tmp_sq[u]);




        }



    }
    property Component attackerComponent: Qt.createComponent("src_qml/AttackerVisual.qml");
    function create_atttacker(i_attacker)  {
        var component;
        var squ = i_attacker;
        component = attackerComponent;
        if (component.status == Component.Ready) {

            var dynamicObject = component.createObject(background, { "attacker" : squ, "startX" : getX(squ.current.col), "x" : getX(squ.current.col), "y" : getY(squ.current.row),  "startY" : getY(squ.current.row), "endX" : getX(squ.target.col), "endY" : getY(squ.target.row), "speed" : squ.speed,  "ecdx" : 0, "ecdy" : 0, "game" : game });
            dynamicObject.width = (background.width / game.board.colCount);
            dynamicObject.height = (background.height / game.board.rowCount);

            squ.set_attackerVisual(dynamicObject);

            squ.attackerVisual.show_particles_fire.connect(particleOverlay.customEmit);
            squ.attackerVisual.show_particles_flash.connect(particleOverlay.flashEmit);
            squ.attackerVisual.show_particles_tiny.connect(particleOverlay.tinyEmit);
            squ.attackerVisual.attackerPathFinished.connect(handleAttackerReachedEnd);
            squ.attackerVisual.removeAttacker.connect(removeAttacker);




        }
    }

    function removeAttacker(attackerObject) {
        if (attackerObject != null) {
            var objattackercurrent = attackerObject.current;
            var objattackertarget = attackerObject.target;

            var objattackercurrentsquareVisual = objattackercurrent.squareVisual;
            var objattackertargetsquareVisual = objattackertarget.squareVisual;


            //objattackercurrentsquareVisual.isActiveTarget = false;
            objattackertargetsquareVisual.isActiveTarget = false;
            var attObj = attackerObject;
            var obj = attObj.attackerVisual;

            obj.show_particles_fire.disconnect(particleOverlay.customEmit);
            obj.show_particles_flash.disconnect(particleOverlay.flashEmit);
            obj.show_particles_tiny.disconnect(particleOverlay.tinyEmit);
            obj.destroy();
            game.board.removeAttacker(attObj);
        }

    }


    function handleAttackerReachedEnd(attackerObject) {
        attackerObject.target.squareVisual.isActiveTarget = false;
        attackerObject.current.squareVisual.isActiveTarget = false;

        attackerObject.attackerVisual.destroy();
        game.board.removeAttacker(attackerObject);

    }

    property var projectileHash: new Array(1005);




    function create_projectile(gunObj, target_x, target_y) {
        var projectileComponent = Qt.createComponent("src_qml/ProjectileVisual.qml");
        var component = projectileComponent;
        if (component.status == Component.Ready) {



            var gunObjgunVisual = gunObj.gunVisual;

            var newObj = component.createObject(background, { "origin_x" : gunObjgunVisual.x + (gunObjgunVisual.width * 0) , "origin_y" : gunObjgunVisual.y  + (gunObjgunVisual.height * 0), "ctx" : 0, "cty" : 0, "speed" : gunObj.gunProjectileSpeed, "max_dist" : gunObj.rangeLowAccuracy, "projectile_type" : gunObj.gunType, "proximity_dist" : gunObj.gunProximityDistance, "splash_distance" : gunObj.gunSplashRadius, "max_damage" : gunObj.damageLowAccuracy, "min_damage" : gunObj.damageLowAccuracy, "possibleHitSquares" : gunObjgunVisual.availableTargetSquares, "target_x" : target_x, "target_y" : target_y, "finito" : false, "opacity" : 0 } );
            newObj.width = (background.width / game.board.colCount) * 0.30 * gunObj.gunType;
            newObj.height = (background.height / game.board.rowCount) * 0.3 * gunObj.gunType;
            /*
            newObj.x = gunObjgunVisual.x + (gunObjgunVisual.width * 0.5);
            newObj.y = gunObjgunVisual.y + (gunObjgunVisual.height * 0.5); */
            newObj.x = gunObjgunVisual.x;
            newObj.y = gunObjgunVisual.y;
            var o = 0;


            gunObj.gunVisual.add_ammo_round(newObj);

            //newObj.arrivedAtTarget.connect(handleProjectileArrival);
            newObj.arrivedAtTarget.connect(gunObjgunVisual.check_projectiles);
            //newObj.finitoChanged.connect(gunObjgunVisual.check_projectiles);

        }
    }
    function handleProjectileArrival(i_target_x, i_target_y, i_min_damage, i_max_damage, i_splash_distance) {
        var attackerObjects = game.board.attackers;



        var myx = i_target_x;
        var myy = i_target_y;
        var hit_attacker = false;


        /*
        for (var c=0; c<attackerObjects.length; c++) {
            var obj = attackerObjects[c].attackerVisual;

            //var apos = background.mapToItem(obj, myx, myy)
            //var xpos = apos.x;
            //var ypos = apos.y;
            var xpos = Math.abs(obj.endX - myx);
            var ypos = Math.abs(obj.endY - myy);
            if ((xpos >= 0) && (xpos <= obj.width)) {
                if ((ypos >= 0) && (ypos <= obj.height)) {


                    var objattacker = obj.attacker;
                    var objattackerhealth = objattacker.health;
                    objattackerhealth = objattackerhealth - i_max_damage;

                    var objattackercurrent = objattacker.current;
                    var objattackertarget = objattacker.target;

                    var objattackercurrentsquareVisual = objattackercurrent.squareVisual;
                    var objattackertargetsquareVisual = objattackertarget.squareVisual;

                    if (objattackerhealth < 1) {
                        objattackercurrentsquareVisual.isActiveTarget = false;
                        objattackertargetsquareVisual.isActiveTarget = false;
                        var attObj = objattacker;
                        particleOverlay.customEmit(myx, myy);
                        obj.destroy();
                        game.board.removeAttacker(attObj);

                    }


                    // particleOverlay.customEmit(myx, myy);

                    break;
                }

            }


        } */

    }

    function getX(col) {
        return (background.width / game.board.colCount) * (col - 0);
    }
    function getY(row) {
        return (background.height / game.board.rowCount) * (row - 0);
    }

    function qmltypeof(obj, className) { // QtObject, string -> bool

        var str = obj.toString();
        return str.indexOf(className + "(") == 0 || str.indexOf(className + "_QML") == 0;
    }
    property int enemyCount: 0;
    property int waveCount: 0;
    property int numEnemiesPerWave: 4
    property int numWavesPerLevel: 3
    property int curAttackerArrayStart: 0
    property int curAttackerArrayStop : 50
    property int numAttackersPerFrame: 50
    property int curProjectileArrayStart: 0
    property int curProjectileArrayStop: 350
    property int numProjectilesPerFrame: 350




    function angleTo(cx, cy, ex, ey) {
        var dy = ey - cy;
        var dx = ex - cx;
        var theta = Math.atan2(dy, dx); // range (-PI, PI]
        theta *= 180 / Math.PI; // rads to degs, range (-180, 180]
        return theta;
    }
    function truelength(x1, y1, x2, y2) {
        var tl = Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
        return tl;
    }



    Timer {
        id: timerSpawn;
        interval: 17500; running:false; repeat: true;
        onTriggered: function() {

            enemyCount = 0;

            timerCreateEnemy.restart();



        }
    }
    Timer {
        id: timerCreateEnemy;
        interval: 4000;
        running: false;
        repeat: true;
        onTriggered: {


            if (timerRotateGuns.running == false) { timerRotateGuns.running = true; timerRotateGuns.repeat = true;

                // for (var g=0; g<game.board.guns.length; g++) {
                //     var gu = game.board.guns[g];

                // request_connect(gu);

                //  }

            }

            if (timerEnemyStep.running == false) { timerEnemyStep.running = true; timerEnemyStep.restart(); }

            game.board.placeAttacker(1,Math.round(game.board.colCount * 0.5),(waveCount + 1), 0.2 * (2 + (Math.random() * 5)));
            enemyCount++;

            /*if (enemyCount == 0) { init_attackers(); } else { */
            game.board.lastSpawnedAttacker.health = (70 * (game.level * 1.75));
            create_atttacker(game.board.lastSpawnedAttacker);



            //}

            if (enemyCount > numEnemiesPerWave) {
                waveCount++;
                if (waveCount > numWavesPerLevel) { waveCount = 0; game.level = game.level + 1; console.log("Game level is now " + game.level); }
                timerCreateEnemy.running = false;
                timerCreateEnemy.stop();
                //    timerSpawn.start();


            }
        }
    }

    Timer {
        id: timerEnemyStep;
        interval: 70
        running: false
        repeat: true
        onTriggered:  {
            var enemies = game.board.attackers;
            if (enemies.length > 0) {
                for (var a=0; a<enemies.length; a++) {
                    var att = enemies[a].attackerVisual;
                    att.stepOnce();
                }
            }
        }
    }


    property int rotO: -1;
    property int stopO: 0;
    Timer {
        id: timerRotateGuns;
        interval: 200
        running: true;
        repeat: true;

        onTriggered: function() {
            if (rotO == -1) { init_squares(); init_guns(); rotO = 0; stopO = rotO + 1; }
            //for (var f=0; f<2; f++) {
            if (rotO > numFireGroups) { rotO = 0; stopO = 1; }
            fire_weapons(rotO);
            rotO++;
            stopO++;
            if (((rotO % 3) == 0) || (rotO == 0)) {
                if (game.board.attackers.length == 0) {
                    //  for (var s=0; s<game.board.squares.length; s++) {
                    //     var sq = game.board.squares[s];
                    //    sq.squareVisual.isActiveTarget = false;
                    //}
                    // for (var g=0; g<game.board.guns.length; g++) {
                    //   var gu = game.board.guns[g];
                    //request_disconnect(gu);
                    // gu.gunVisual.targetDistance = 9999
                    // gu.gunVisual.closest_sq = null;
                    // }

                    timerRotateGuns.repeat = false;
                    timerRotateGuns.running = false;
                    timerRotateGuns.stop();
                    timerEnemyStep.stop();

                } else {



                    //}
                }

                /* if (stopO > game.board.guns.length) { stopO = game.board.guns.length; }

            for (var t=rotO; t<stopO; t++) {

                var gunP = game.board.guns[t];
                var gunObj = gunP.gunVisual;

                var gunx = gunObj.x
                var guny = gunObj.y
                var closest_sq;
                var closest_dist = 99999;

                if (gunObj.next_fire < Date.now()) {
                    if (gunObj.closest_sq != null) {
                        if (gunObj.closest_sq.squareVisual.isActiveTarget == true) {
                            //create_projectile(gunP, gunObj.closest_sq.squareVisual.x + (gunObj.width * 0.5), gunObj.closest_sq.squareVisual.y + (gunObj.height * 0.5));
                            gunObj.fire_projectile(gunObj.closest_sq.squareVisual.x + (gunObj.width * 0.5), gunObj.closest_sq.squareVisual.y + (gunObj.height * 0.5));

                            gunObj.next_fire = parseInt(Date.now() + 850 + (Math.random() * 500));
                        }
                    }
                }
                // }


            }
            if (stopO == game.board.guns.length) {
                rotO = 0;
                stopO = 12;
            } else {
                rotO = stopO;
                stopO = rotO + 12;
            }*/

                //timerRotateGuns.start();
            }

        }
    }

    property var isDragModeOn: false
    property var offset_start_x: 0
    property var offset_start_y: 0
    property var old_bg_x_translation: 0
    property var old_bg_y_translation: 0
    property var hide_chooser_mode: false
    MouseArea {
        anchors.fill: parent
        onPressed: {
            isDragModeOn = true;
            offset_start_x = mouseX;
            offset_start_y = mouseY;
            old_bg_x_translation = bg_x_translation
            old_bg_y_translation = bg_y_translation
            hide_chooser_mode = false;
        }
        onPositionChanged:  {
            if (isDragModeOn == true) {
                var new_bg_x_translation;
                var new_bg_y_translation;
                new_bg_x_translation = (0.25 * (mouseX - offset_start_x));
                new_bg_y_translation = (0.25 * (mouseY - offset_start_y));
                if ((Math.abs(new_bg_x_translation) > 10) || (Math.abs(new_bg_y_translation) > 10)) {
                    hide_chooser_mode = true;
                    bg_x_translation = old_bg_x_translation + new_bg_x_translation;
                    bg_y_translation = old_bg_y_translation + new_bg_y_translation;
                    animation_translate_scene.restart();
                }
            }
        }
        onReleased:  {
            isDragModeOn = false;
            // hide_chooser_mode = false;
        }
        onClicked: {
            if (hide_chooser_mode == false) {
                testBox.text = getTestArg(mouseX, mouseY);
            }
        }
        id: mousezone
        function getTestArg(mx, my) {
            if (game.board.squares.length > 0) {
                var bgch = game.board.squares;
                if ((towerChooser.visible == true) || (towerUpgradeMenu.visible == true)) {
                    towerChooser.visible = false;
                    towerChooser.enabled = false;
                    towerUpgradeMenu.visible = false;
                    towerUpgradeMenu.enabled = false;
                    return "";
                }
                towerChooser.visible = false;
                towerChooser.enabled = false;
                towerUpgradeMenu.visible = false;
                towerUpgradeMenu.enabled = false;
                for (var c=0; c<bgch.length; c++) {
                    var obj = bgch[c].squareVisual;
                    if (qmltypeof(obj, "SquareVisual")) {
                        var xymap = mapToItem(obj, mx, my);
                        var xpos = xymap.x;
                        var ypos = xymap.y;
                        if ((xpos >= 0) && (xpos <= obj.width)) {
                            if ((ypos >= 0) && (ypos <= obj.height)) {
                                var mRow = obj.square.row;
                                var mCol = obj.square.col;
                                towerChooser.square = obj.square;

                                var tmp_chk = game.board.check_for_gun_placement(obj.square);
                                if (tmp_chk == true) {
                                    towerUpgradeMenu.opacity = 1.0;
                                    towerUpgradeMenu.gun = game.board.find_gun(obj.square.row, obj.square.col);
                                    towerUpgradeMenu.enabled = true;
                                    towerUpgradeMenu.visible = true;
                                    var damage_new_level = towerUpgradeMenu.gun.gunVisual.getDamage(towerUpgradeMenu.gun.gunDamageLevel + 1);
                                    var range_new_level = towerUpgradeMenu.gun.gunVisual.getRange(towerUpgradeMenu.gun.gunRangeLevel + 1);
                                    towerUpgradeMenu.set_next_levels(range_new_level, damage_new_level);
                                    console.log("setting upgrade menu gun to " + towerUpgradeMenu.gun);
                                    // display  TowerUpgradeMenu
                                } else {

                                    create_tower_chooser();
                                }


                                /* this code to be moved to TowerChoose */

                                /* end of code to move to TowerChooser */

                            }
                        }
                    }
                }

                return "guns built - enemy inbound";
            } else {
                return "uninitialized.";
            }
        }



        Text {
            id: testBox
            text: qsTr("Click on the grid to build towers")
            anchors.centerIn: parent
            visible: false
        }
    }
    Item {
        id: particleOverlay
        width: background.width;
        height: background.height;
        anchors.fill: parent
        transform: [
            Rotation {
                id: particleSceneRotation
                axis.x: 1
                axis.y: 0
                axis.z: 0
                origin.x: background.width / 2
                origin.y: background.height / 2
            },
            Translate {
                id: particleSceneTranslation
                x: bg_x_translation
                y: bg_y_translation
            }
        ]
        ParticleSystem {
            id: sys

            ParticleGroup {
                name: "unlit"
                duration: 1000
                to: {"lighting":1, "unlit":99}
                ImageParticle {
                    source: "./src_qml/images/particles/particleA.png"
                    colorVariation: 0.1
                    color: "#2060160f"
                }
                GroupGoal {
                    whenCollidingWith: ["lit"]
                    goalState: "lighting"
                    jump: true
                }
            }
            // ![unlit]
            // ![lighting]
            ParticleGroup {
                name: "lighting"
                duration: 100
                to: {"lit":1}
            }
            // ![lighting]
            // ![lit]
            ParticleGroup {
                name: "lit"
                duration: 10000
                onEntered: score++;
                TrailEmitter {
                    id: fireballFlame
                    group: "flame"

                    emitRatePerParticle: 38
                    lifeSpan: 200
                    emitWidth: 8
                    emitHeight: 8

                    size: 24
                    sizeVariation: 0
                    endSize: 4
                }

                TrailEmitter {
                    id: fireballSmoke
                    group: "smoke"
                    // ![lit]

                    emitRatePerParticle: 120
                    lifeSpan: 2000
                    emitWidth: 16
                    emitHeight: 16

                    velocity: PointDirection {yVariation: 16; xVariation: 16}
                    acceleration: PointDirection {y: -16}

                    size: 24
                    sizeVariation: 8
                    endSize: 8
                }
            }

            ImageParticle {
                id: smoke
                anchors.fill: parent
                groups: ["smoke"]
                source: "qrc:///particleresources/glowdot.png"
                colorVariation: 0
                color: "#00111111"
            }
            ImageParticle {
                id: pilot
                anchors.fill: parent
                groups: ["pilot"]
                source: "qrc:///particleresources/glowdot.png"
                redVariation: 0.01
                blueVariation: 0.4
                color: "#0010004f"
            }
            ImageParticle {
                id: flame
                anchors.fill: parent
                groups: ["flame", "lit", "lighting"]
                source: "./src_qml/images/particles/particleA.png"
                colorVariation: 0.1
                color: "#00ff400f"
            }


        }
        ImageParticle {
            system: sys
            source: "./src_qml/images/particles/particle2.png"
            color: "yellow"
            colorVariation: 0.3
            alpha: 0.1
        }

        Component {
            id: emitterComp
            Emitter {
                id: container
                Emitter {
                    id: emitMore
                    system: sys
                    emitRate: 16
                    lifeSpan: 100
                    size: 23
                    endSize: 8
                    velocity: AngleDirection {angleVariation:360; magnitude: 30}
                }

                property int life: 200
                property real targetX: 0
                property real targetY: 0
                function go() {
                    xAnim.running = true;
                    yAnim.running = true;
                    container.enabled = true
                }
                system: sys
                emitRate: 64
                lifeSpan: 300
                size: 34
                endSize: 2
                NumberAnimation on x {
                    id: xAnim;
                    to: targetX
                    duration: life
                    running: false
                }
                NumberAnimation on y {
                    id: yAnim;
                    to: targetY
                    duration: life
                    running: false
                }
                Timer {
                    interval: life
                    running: true
                    onTriggered: container.destroy();
                }
            }
        }

        function customEmit(x,y) {
            //! [0]
            for (var i=0; i<3; i++) {
                var obj = emitterComp.createObject(particleOverlay);
                obj.x = x + 20
                obj.y = y + 20
                obj.targetX = Math.random() * 24 - 12 + obj.x
                obj.targetY = Math.random() * 24 - 12 + obj.y
                obj.life = Math.round(Math.random() * 24) + 200
                obj.emitRate = Math.round(Math.random() * 32) + 32
                obj.go();
            }
            //! [0]
        }

        function flashEmit(x, y) {
            var obj = flashParticle.createObject(particleOverlay);
            obj.x = x + 10;
            obj.y = y + 10;
            obj.enabled = true;
        }
        function tinyEmit(x, y) {
            var obj = tinyParticle.createObject(particleOverlay);
            obj.x = x + 10;
            obj.y = y + 10;
            obj.enabled = true;
        }

        ImageParticle {
            objectName: "asdf"
            groups: ["asdf"]
            source: "./src_qml/images/particles/particle.png"
            color: "#e3d253"
            colorVariation: 0
            alpha: 0.8
            alphaVariation: 0.4
            redVariation: 0.2
            greenVariation: 0
            blueVariation: 0
            rotation: 11
            rotationVariation: 10
            autoRotation: false
            rotationVelocity: 6
            rotationVelocityVariation: 8
            entryEffect: ImageParticle.Scale
            system: sys
        }


        Component {

            id: flashParticle

            Emitter {
                id: flashContainer
                objectName: "asdf"
                x: 40
                y: 40
                width: 17
                height: 23
                enabled: false
                group: "asdf"
                emitRate: 12
                maximumEmitted: 1
                startTime: 0
                lifeSpan: 150
                lifeSpanVariation: 150
                size: 20
                sizeVariation: 10
                endSize: 40
                velocityFromMovement: 0
                system: sys
                velocity:
                    PointDirection {
                    x: 0
                    xVariation: 0
                    y: 0
                    yVariation: 0
                }
                acceleration:
                    PointDirection {
                    x: 0
                    xVariation: 0
                    y: 0
                    yVariation: 0
                }
                shape:
                    RectangleShape {}

                Timer {
                    interval: lifeSpan
                    running: true
                    onTriggered: flashContainer.destroy();
                }
            }

        }


        ImageParticle {
            objectName: "tiny"
            groups: ["tiny"]
            source: "./src_qml/images/particles/tracer.png"
            color: "#9e8c22"
            colorVariation: 0
            alpha: 0.4
            alphaVariation: 0.2
            redVariation: 0
            greenVariation: 0
            blueVariation: 0
            rotation: 5
            rotationVariation: 10
            autoRotation: false
            rotationVelocity: 0
            rotationVelocityVariation: 0
            entryEffect: ImageParticle.None
            system: sys
        }
        Component {
            id: tinyParticle
            Emitter {
                id: tinyContainer
                objectName: "tiny"
                x: 192
                y: 131
                width: 4
                height: 11
                enabled: true
                group: "tiny"
                emitRate: 19
                maximumEmitted: 2
                startTime: 10
                lifeSpan: 120
                lifeSpanVariation: 50
                size: 3
                sizeVariation: 2
                endSize: 13
                velocityFromMovement: 0
                system: sys
                velocity:
                    CumulativeDirection {}
                acceleration:
                    CumulativeDirection {}
                shape:
                    RectangleShape {}

                Timer {
                    interval: lifeSpan
                    running: true
                    onTriggered: tinyContainer.destroy();
                }
            }


        }


        /* tank shell particle */
        function shellEmit(x, y) {
            var obj = shellRound.createObject(particleOverlay);
            obj.x = x + 10;
            obj.y = y + 10;
            obj.enabled = true;
        }

            Component {
                id: shellRound
                Emitter {
                    id: blaster
                    height: 0
                    emitRate: 1

                    lifeSpan: 1400//TODO: Infinite & kill zone
                    size: 24
                    sizeVariation: 4
                    velocity: PointDirection {x:(0 - (particleOverlay.width * 0.5)); xVariation: 00; y: (0 - (particleOverlay.height * 0.5))}
                    //acceleration: PointDirection {}
                    group: "lit"
                    x: particleOverlay.width * 0.5
                    y: particleOverlay.height * 0.5

                    Timer {
                        id: controlParticleTimer
                        interval: blaster.lifeSpan
                        running: true
                        repeat:  false
                        onTriggered:  {
                            blaster.destroy();
                        }
                    }
                }


                /* Emitter {
                id: flamer
                x: 100
                y: 300
                group: "pilot"
                emitRate: 80
                lifeSpan: 600
                size: 24
                sizeVariation: 2
                endSize: 0
                velocity: PointDirection { y:-100; yVariation: 4; xVariation: 4 }
                // ![groupgoal-pilot]
                GroupGoal {
                    groups: ["unlit"]
                    goalState: "lit"
                    jump: true
                    system: particles
                    x: -15
                    y: -55
                    height: 105
                    width: 60
                    shape: MaskShape {source: "../../images/matchmask.png"}
                }
                // ![groupgoal-pilot]
            } */
                // ![groupgoal-ma]
                //Click to enflame
                /* GroupGoal {
                groups: ["unlit"]
                goalState: "lighting"
                jump: true
                enabled: ma.pressed
                width: 48
                height: 48
                x: ma.mouseX - width/2
                 y: ma.mouseY - height/2
            } */
                // ![groupgoal-ma]

            }


    }
    ListModel {
        id: projectile_model;
    }
    ListModel {
        id: attacker_model;
    }

    ListModel {
        id: gun_model;
    }

    ListModel {
        id: attacker_ids;
    }

    function create_collision_data() {
        var gameboard = game.board;
        var m_guns = gameboard.guns;
        var m_attackers = gameboard.attackers;

        for (var g=0; g<m_guns.length; g++) {
            var gun = m_guns[g];
            if (gun !=  null) {
                var gun_bullets = gun.gunVisual.bullets;
                for (var b=0; b<gun_bullets.length; b++) {
                    var gun_bullet = gun_bullets[b];
                    if (gun_bullet != null) {
                        projectile_model.append({
                                                    "x" : gun_bullet.x,
                                                    "y" : gun_bullet.y,
                                                    "target_x" : gun_bullet.target_x,
                                                    "target_y" : gun_bullet.target_y,
                                                    "min_damage" : gun_bullet.min_damage,
                                                    "max_damage" : gun_bullet.max_damage,
                                                    "speed" : gun_bullet.speed,
                                                    "proximity_distance" : gun_bullet.proximity_distance,
                                                    "splash_distance" : gun_bullet.splash_distance,
                                                } );
                    }
                }



            }
        }
        for (var m=0; m<m_attackers.length; m++) {
            var attacker = m_attackers[m].attackerVisual;
            if (attacker != null) {
                attacker_ids.set(m, attacker);
                attacker_model.append({
                                          "x" : attacker.x,
                                          "y" : attacker.y,
                                          "width": attacker.width,
                                          "height" : attacker.height,
                                          "health" : attacker.health,
                                          "attacker_id" : m
                                      });
            }
        }
        var tmp_message = { "projectile_model" : projectile_model, "attacker_model" : attacker_model };
        projectileWorker.sendMessage(tmp_message);
        projectile_model.clear();
        attacker_model.clear();
    }




    WorkerScript {
        id: projectileWorker
        source: "./src_js/ProjectileWorker.js"

        onMessage: function(messageObject) {

            if (messageObject.msgtype == "hit") {
                console.log("attacker " +  messageObject.id + " took " + messageObject.damage + " damage");

            } else {
                if (messageObject.msgtype == "end") {   create_collision_data(); }
            }
        }



    }
}
