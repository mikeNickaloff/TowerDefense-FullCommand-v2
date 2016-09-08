import QtQuick 2.6
import QtQuick.Window 2.2
import com.towerdefense.fullcommand 2.0
import QtQuick.Particles 2.0
import QtQuick.Layouts 1.3
import "src_js/logic.js" as Logic
Window {
    visible: true
    width: 640
    height: 640
    title: qsTr("Tower Defense - Complete Command v2 - 3.9 beta")
    Item {
        id: background
        width: 640
        height: 640
        anchors.fill: parent











    }
    TowerUpgradeMenu {
        id: towerUpgradeMenu
        height: 480
        width: 240
        anchors.right: background.right
        z: 100
        opacity: 0
        property Gun gun
        signal upgradeRange(Gun i_gun)
        signal upgradeDamage(Gun i_gun)

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            spacing: 5
            Timer {
                id: fixUpgradeMenuColors
                interval:  500
                repeat: false
                running: false
                onTriggered: {
                    rangeButton.color = "lightblue";
                    damageButton.color = "gold";
                }
            }
            Rectangle {
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        towerUpgradeMenu.upgradeRange(towerUpgradeMenu.gun);
                        rangeButton.color = "gray";
                        fixUpgradeMenuColors.start();

                    }
                }
                id: rangeButton
                color: "lightblue"; radius: 10.0
                width: 300; height: 50;

                Text { anchors.centerIn: parent
                    font.pointSize: 15; text: "Range" } }

            Rectangle {

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        towerUpgradeMenu.upgradeDamage(towerUpgradeMenu.gun);
                        damageButton.color = "gray";
                        fixUpgradeMenuColors.start();
                    }
                }
                id: damageButton
                color: "gold"; radius: 10.0
                width: 300; height: 50
                Text { anchors.centerIn: parent
                    font.pointSize: 15; text: "Damage" } }
            Rectangle {
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        towerUpgradeMenu.enabled = false;
                        towerUpgradeMenu.opacity = 0;
                    }
                }
                color: "lightgreen"; radius: 10.0
                width: 300; height: 50
                Text { anchors.centerIn: parent
                    font.pointSize: 15; text: "Hide Menu" } }
        }
    }

    Game {
        id: game


        Component.onCompleted: {
            game.createBoard();
            init_squares();
            towerUpgradeMenu.upgradeRange.connect(upgrade_range);
            towerUpgradeMenu.upgradeDamage.connect(upgrade_damage);
            towerUpgradeMenu.enabled = false;

        }
        property var grid;
        property var finder;
        function upgrade_range(i_gun) {





            var gu = i_gun;

            var rangeLowAcc = gu.rangeLowAccuracy;
            rangeLowAcc += gu.upgradeRangeAmount;
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


                        if (TL < rangeLowAcc) {
                            if (gugunVisualavailableTargetSquares.indexOf(sqObj) < 0) {
                                gugunVisualavailableTargetSquares.push(sqObj);
                                sqEl.gunsInRange.push(gu);
                                //sqEl.isActiveTargetChanged.connect(gu.gunVisual.find_target);
                                sqEl.becameActiveTarget.connect(gugunVisual.check_new_target);
                                sqEl.lostActiveTarget.connect(gugunVisual.lost_active_target);
                            }

                        }
                    }
                }
            }
            gu.gunVisual.availableTargetSquares = gugunVisualavailableTargetSquares;
            gu.rangeLowAccuracy = rangeLowAcc;



        }
        function upgrade_damage(i_gun) {
            i_gun.damageLowAccuracy = i_gun.damageLowAccuracy + i_gun.upgradeDamageAmount;
            for (var i=0; i<i_gun.gunVisual.ammo.length; i++) {
                var tmp_ammo = i_gun.gunVisual.ammo[i];
                var tmp_bullet = i_gun.gunVisual.bullets[i];
                if (tmp_ammo != null) {
                    tmp_ammo.min_damage = i_gun.damageLowAccuracy;
                    tmp_ammo.max_damage = i_gun.damageLowAccuracy;

                }
                if (tmp_bullet != null) {
                    tmp_bullet.min_damage = i_gun.damageLowAccuracy;
                    tmp_bullet.max_damage = i_gun.damageLowAccuracy;
                }

            }
        }
    }

    function get_shortest_path(c1, r1, c2, r2) {
        return Logic.get_shortest_path(c1, r1, c2, r2);
    }


    property int numFireGroups:  8;
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
                    //fire_weapons.connect(gu.gunVisual.receive_fire_order);
                    for (var w=0; w<game.board.squares.length; w++) {

                        var sqObj = game.board.squares[w];
                        var sqEl = sqObj.squareVisual;

                        if ((sqObj.row >= min_sq_row) && (sqObj.row <= max_sq_row)) {
                            if ((sqObj.col >= min_sq_col) && (sqObj.col <= max_sq_col)) {



                                var TL = truelength(gu.gunVisual.x, gu.gunVisual.y, sqEl.x, sqEl.y);


                                if (TL < gu.rangeLowAccuracy) {
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
            for (var q=0; q<2; q++) {
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
            squ.attackerVisual.attackerPathFinished.connect(handleAttackerReachedEnd);
            squ.attackerVisual.show_particles.connect(particleOverlay.customEmit);
            squ.attackerVisual.removeAttacker.connect(removeAttacker);




        }
    }

    function removeAttacker(attackerObject) {
        var objattackercurrent = attackerObject.current;
        var objattackertarget = attackerObject.target;

        var objattackercurrentsquareVisual = objattackercurrent.squareVisual;
        var objattackertargetsquareVisual = objattackertarget.squareVisual;


        objattackercurrentsquareVisual.isActiveTarget = false;
        objattackertargetsquareVisual.isActiveTarget = false;
        var attObj = attackerObject;
        var obj = attObj.attackerVisual;
        obj.show_particles.disconnect(particleOverlay.customEmit);
        obj.destroy();
        game.board.removeAttacker(attObj);


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

            var newObj = component.createObject(background, { "origin_x" : gunObjgunVisual.x , "origin_y" : gunObjgunVisual.y, "ctx" : 0, "cty" : 0, "speed" : 20, "max_dist" : gunObj.rangeLowAccuracy, "projectile_type" : 1, "proximity_dist" : 20, "splash_distance" : 10, "max_damage" : gunObj.damageLowAccuracy, "min_damage" : gunObj.damageLowAccuracy, "possibleHitSquares" : gunObjgunVisual.availableTargetSquares, "target_x" : target_x, "target_y" : target_y, "finito" : false, "opacity" : 0 } );
            newObj.width = (background.width / game.board.colCount) * 0.30;
            newObj.height = (background.height / game.board.rowCount) * 0.3;
            newObj.x = gunObjgunVisual.x + (gunObjgunVisual.width * 0.5);
            newObj.y = gunObjgunVisual.y + (gunObjgunVisual.height * 0.5);
            var o = 0;


            gunObj.gunVisual.add_ammo_round(newObj);

            newObj.arrivedAtTarget.connect(handleProjectileArrival);
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
    property int numEnemiesPerWave: 6
    property int numWavesPerLevel: 2
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
        interval: 35000; running:false; repeat: true;
        onTriggered: function() {

            enemyCount = 0;

            timerCreateEnemy.start();



        }
    }
    Timer {
        id: timerCreateEnemy;
        interval: 1700;
        running: false;
        repeat: true;
        onTriggered: {




            game.board.placeAttacker(1,Math.round(game.board.colCount * 0.5),1, 4);
            enemyCount++;

            if (enemyCount == 0) { init_attackers(); } else {
                game.board.lastSpawnedAttacker.health = (Math.pow(15, 0.5 + (game.level * 0.25)));
                create_atttacker(game.board.lastSpawnedAttacker);



            }

            if (enemyCount > numEnemiesPerWave) {
                waveCount++;
                if (waveCount > numWavesPerLevel) { waveCount = 0; game.level = game.level + 1; console.log("Game level is now " + game.level); }
                timerCreateEnemy.stop();
            //    timerSpawn.start();


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
            if (rotO > numFireGroups) { rotO = 0; stopO = 1; }
            fire_weapons(rotO);
            rotO++;
            stopO++;

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

    MouseArea {
        anchors.fill: parent
        onClicked: {
            testBox.text = getTestArg(mouseX, mouseY);
        }
        id: mousezone
        function getTestArg(mx, my) {
            if (game.board.squares.length > 0) {
                var bgch = game.board.squares;
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
                                game.board.placeGun(obj.square.row, obj.square.col, 1);
                                if ((game.board.needBestPathUpdate == true) && (game.board.lastGunPlacementValid == true)) {



                                    var shRoute = get_shortest_path(Math.round(game.board.colCount * 0.5),0, Math.round(game.board.colCount * 0.5), game.board.rowCount - 1);
                                    if (shRoute[2] != null) {
                                        game.board.clear_path_data();
                                        //   console.log(shRoute.length + " - " + shRoute);
                                        var q = 0;
                                        while (shRoute[q] != null) {
                                            game.board.add_path_data(parseInt(shRoute[q][0]),parseInt(shRoute[q][1]));
                                            q++;
                                            //console.log(nd);
                                        }
                                        create_gun(obj.square.row, obj.square.col);
                                    } else {



                                        game.board.removeGun(obj.square.row, obj.square.col);
                                        shRoute = get_shortest_path(Math.round(game.board.colCount * 0.5),0, Math.round(game.board.colCount * 0.5), game.board.rowCount - 1);
                                        if (shRoute[2] != null) {
                                            game.board.clear_path_data();

                                            q = 0;
                                            while (shRoute[q] != null) {
                                                game.board.add_path_data(parseInt(shRoute[q][0]),parseInt(shRoute[q][1]));
                                                q++;
                                                //console.log(nd);
                                            }
                                        }
                                    }
                                } else {
                                    if (game.board.lastGunPlacementValid == true) {

                                        create_gun(obj.square.row, obj.square.col);
                                    } else {
                                        towerUpgradeMenu.opacity = 1.0;
                                        towerUpgradeMenu.gun = game.board.find_gun(obj.square.row, obj.square.col);
                                        towerUpgradeMenu.enabled = true;
                                        console.log("setting upgrade menu gun to " + towerUpgradeMenu.gun);
                                        // display  TowerUpgradeMenu


                                    }
                                }

                                timerSpawn.running = true;
                                  timerCreateEnemy.start();


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
        }
    }
    Item {
        id: particleOverlay
        width: background.width;
        height: background.height;
        anchors.fill: parent

        ParticleSystem {
            id: sys
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
                    size: 13
                    endSize: 8
                    velocity: AngleDirection {angleVariation:360; magnitude: 30}
                }

                property int life: 200
                property real targetX: 0
                property real targetY: 0
                function go() {
                    xAnim.start();
                    yAnim.start();
                    container.enabled = true
                }
                system: sys
                emitRate: 64
                lifeSpan: 300
                size: 24
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
            for (var i=0; i<5; i++) {
                var obj = emitterComp.createObject(particleOverlay);
                obj.x = x
                obj.y = y
                obj.targetX = Math.random() * 24 - 12 + obj.x
                obj.targetY = Math.random() * 24 - 12 + obj.y
                obj.life = Math.round(Math.random() * 24) + 200
                obj.emitRate = Math.round(Math.random() * 32) + 32
                obj.go();
            }
            //! [0]
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
