import QtQuick 2.6
import QtQuick.Window 2.2
import com.towerdefense.fullcommand 2.0
import "src_js/logic.js" as Logic
Window {
    visible: true
    width: 640
    height: 640
    title: qsTr("Hello World")
    Item {
        id: background
        width: 640
        height: 640
        anchors.fill: parent

    }

    Game {
        id: game


        Component.onCompleted: {
            game.createBoard();
            init_squares();
            for (var i=0; i<1000; i++) { projectileHash[i] = null; }
            //  var shRoute = get_shortest_path(0,0, game.board.colCount - 1, game.board.rowCount - 1);

            // game.board.set_path_data(shRoute);

        }
        property var grid;
        property var finder;
    }

    function get_shortest_path(c1, r1, c2, r2) {
        return Logic.get_shortest_path(c1, r1, c2, r2);
    }


    property var squareHash: new Array(1000);
    property var squareObjHash : new Array(1000);
    property var gunHash: new Array(1000);
    property var attackerHash: new Array(1000);


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
        //var shRoute = get_shortest_path(0,0, game.board.colCount - 1, game.board.rowCount - 1);

        //game.board.set_path_data(shRoute);
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
    function create_gun(row, col) {
        var component;
        component = Qt.createComponent("src_qml/GunVisual.qml");
        var tmp_gu = game.board.guns;
        for (var u=0; u<tmp_gu.length; u++) {
            var gu = tmp_gu[u];
            if ((gu.row == row) && (gu.col == col)) {
                if (component.status == Component.Ready) {
                    var dynamicObject = component.createObject(background, { "gun" : gu });
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
                    for (var w=0; w<game.board.squares.length; w++) {

                        var sqObj = game.board.squares[w];
                        var sqEl = sqObj.squareVisual;

                        if ((sqObj.row >= min_sq_row) && (sqObj.row <= max_sq_row)) {
                            if ((sqObj.col >= min_sq_col) && (sqObj.col <= max_sq_col)) {



                                var TL = truelength(gu.gunVisual.x, gu.gunVisual.y, sqEl.x, sqEl.y);
                                if (TL < gu.rangeLowAccuracy) {
                                    gu.gunVisual.availableTargetSquares.push(sqObj);
                                    sqEl.gunsInRange.push(gu);
                                }
                            }
                        }
                    }


                }
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

        // clear_type_from_board("AttackerVisual");


        // var existingAttackerVisuals = new Array(1000);




        var tmp_sq = game.board.attackers;




        for (var u=0; u<tmp_sq.length; u++) {
            create_atttacker(tmp_sq[u]);




        }



    }
    function create_atttacker(i_attacker)  {
        var component;
        var squ = i_attacker;
        component = Qt.createComponent("src_qml/AttackerVisual.qml");
        if (component.status == Component.Ready) {

            var angle = Math.atan2(getY(squ.target.row) - getY(squ.current.row), getX(squ.target.col) - getX(squ.current.col));

            var ecdx = squ.speed * Math.cos(angle);
            var ecdy = squ.speed * Math.sin(angle);


            var dynamicObject = component.createObject(background, { "attacker" : squ, "startX" : getX(squ.current.col), "startY" : getY(squ.current.row), "endX" : getX(squ.target.col), "endY" : getY(squ.target.row), "speed" : squ.speed,  "ecdx" : ecdx, "ecdy" : ecdy });
            dynamicObject.width = (background.width / game.board.colCount);
            dynamicObject.height = (background.height / game.board.rowCount);
            if (squ.xpos > 0) { dynamicObject.x = squ.xpos; } else {
                dynamicObject.x = getX(squ.current.col);
            }
            if (squ.ypos > 0) { dynamicObject.y = squ.ypos; } else {
                dynamicObject.y = getY(squ.current.row);
            }

            squ.set_attackerVisual(dynamicObject);
            //dynamicObject.anim1.running = true;
            //dynamicObject.anim2.running = true;


        }
    }


    property var projectileHash: new Array(1005);
    property var projectileComponent: Qt.createComponent("src_qml/ProjectileVisual.qml");
    function create_projectile(gunObj, target_x, target_y) {

        var component = projectileComponent;
        if (component.status == Component.Ready) {

            var angle = Math.atan2(target_y - gunObj.gunVisual.y , target_x - gunObj.gunVisual.x);
            //var angle = gunObj.gunVisual.rotation + 90;

            var ecdx = 25 * Math.cos(angle);
            var ecdy = 25 * Math.sin(angle);


            var newObj = component.createObject(background, { "origin_x" : gunObj.gunVisual.x , "origin_y" : gunObj.gunVisual.y, "ctx" : ecdx, "cty" : ecdy, "speed" : 25, "max_dist" : gunObj.rangeLowAccuracy, "projectile_type" : 1, "proximity_dist" : 20, "splash_distance" : 10, "max_damage" : 10, "min_damage" : 10, "possibleHitSquares" : gunObj.gunVisual.availableTargetSquares, "target_x" : target_x, "target_y" : target_y } );
            newObj.width = (background.width / game.board.colCount) * 0.30;
            newObj.height = (background.height / game.board.rowCount) * 0.3;
            newObj.x = gunObj.gunVisual.x + (gunObj.gunVisual.width * 0.5);
            newObj.y = gunObj.gunVisual.y + (gunObj.gunVisual.height * 0.5);
            var o = 0;
            while ((o < 1000) && (projectileHash[o] != null)) { o++; }
            projectileHash[o] = newObj;
        }
    }

    function getX(col) {
        return (background.width / game.board.colCount) * (col - 0);
    }
    function getY(row) {
        return (background.height / game.board.rowCount) * (row - 0);
    }

    function qmltypeof(obj, className) { // QtObject, string -> bool
        // className plus "(" is the class instance without modification
        // className plus "_QML" is the class instance with user-defined properties
        var str = obj.toString();
        return str.indexOf(className + "(") == 0 || str.indexOf(className + "_QML") == 0;
    }
    property int enemyCount: 0;
    property int numEnemiesPerWave: 5;
    property int curAttackerArrayStart: 0
    property int curAttackerArrayStop : 50
    property int numAttackersPerFrame: 50
    property int curProjectileArrayStart: 0
    property int curProjectileArrayStop: 350
    property int numProjectilesPerFrame: 350
    Timer {
        id:timerAttackers;
        interval: 500; running: true; repeat: false;
        onTriggered: function() {
            timerAttackers.stop();


            if (curAttackerArrayStop > game.board.attackers.length) {
                curAttackerArrayStop = game.board.attackers.length;
            }

            for (var r=curAttackerArrayStart; r<curAttackerArrayStop; r++) {
                var attObj = game.board.attackers[r];
                if (attObj != null) {
                    var attviz = attObj.attackerVisual;

                    if (attviz.waiting_for_waypoint) {
                        //   attacker.next_target();

                        attviz.startX = attviz.x;
                        attviz.startY = attviz.y;
                        if (attObj.target != null) {
                            var tgt = attObj.target;
                            if (tgt.squareVisual != null) {
                                attviz.endX = tgt.squareVisual.x;
                                attviz.endY = tgt.squareVisual.y;
                                // var angle = Math.atan2(attviz.endY - attviz.y, attviz.endX - attviz.x);

                                //attviz.ecdx = attObj.speed * Math.cos(angle);
                                //attviz.ecdy = attObj.speed * Math.sin(angle);
                                //attviz.xanim.start();
                                //attviz.yanim.start();
                                attviz.waiting_for_waypoint = false;

                                tgt.squareVisual.isActiveTarget = true;
                                tgt.squareVisual.distanceToEnd = attObj.distanceToEnd;
                                for (var g=0; g<tgt.squareVisual.gunsInRange.length; g++) {
                                    var tmp_gun = tgt.squareVisual.gunsInRange[g];
                                    if (tmp_gun != null) {
                                        if (tmp_gun.gunVisual != null) {
                                            tmp_gun.gunVisual.find_target();
                                        }
                                    }
                                }

                                attObj.current.squareVisual.isActiveTarget = false;
                            } else {


                            }
                        } else {
                            attviz.visible = false;
                            attviz.opacity = 0.0;
                            //attObj.attackerVisual.destroy();
                            // attviz.destroy();
                            // game.board.removeAttacker(attObj);

                        }
                    } else {
                        attObj.target.squareVisual.isActiveTarget = true;
                    }


                    //  attviz.step();
                    attviz.startAnim();

                    if (attObj.atEndOfPath) {
                        // bgch[c].destroy();
                        attviz.visible = false;
                        attviz.opacity = 0.0;
                        attObj.target.squareVisual.isActiveTarget = false;
                        //attObj.attackerVisual.destroy();
                        attviz.destroy();
                        game.board.removeAttacker(attObj);

                        //  init_attackers();

                    }



                    // game.board.correctPaths();

                    //}


                }
            }
            if (curAttackerArrayStop >= game.board.attackers.length) {
                curAttackerArrayStart = 0;
                curAttackerArrayStop = numAttackersPerFrame;
            } else {

                curAttackerArrayStart = curAttackerArrayStop;
                curAttackerArrayStop += numAttackersPerFrame;
            }


            timerAttackers.start();
        }

    }

    Timer {
        id:timerProjectiles;
        interval: 60; running: true; repeat: true
        onTriggered: function() {
            timerProjectiles.stop();

            if (curProjectileArrayStop > projectileHash.length) {
                curProjectileArrayStop = projectileHash.length;
            }

            var attackerObjects = [];

            var bgch = background.children;
            for (var c=0; c<bgch.length; c++) {
                var obj = bgch[c];
                if (qmltypeof(obj, "AttackerVisual")) {
                    attackerObjects.push(obj);
                }
            }

            for (var p=curProjectileArrayStart; p<curProjectileArrayStop; p++) {
                var proObj = projectileHash[p];
                if (proObj != null) {
                    if (proObj.finito == true) {
                        // proObj.x += proObj.ctx;
                        //proObj.y += proObj.cty;
                        var myx = proObj.target_x;
                        var myy = proObj.target_y;
                        var hit_attacker = false;


                       // var bgch = background.children;
                        for (var c=0; c<attackerObjects.length; c++) {
                            var obj = attackerObjects[c];
                            if (qmltypeof(obj, "AttackerVisual")) {
                                var apos = background.mapToItem(obj, myx, myy)
                                var xpos = apos.x;
                                var ypos = apos.y;
                                if ((xpos >= 0) && (xpos <= obj.width)) {
                                    if ((ypos >= 0) && (ypos <= obj.height)) {
                                        obj.attacker.health = obj.attacker.health - proObj.max_damage;
                                        if (obj.attacker.health < 1) {
                                            obj.attacker.target.squareVisual.isActiveTarget = false;
                                            var attObj = obj.attacker;
                                            obj.destroy();
                                            game.board.removeAttacker(attObj);

                                        }
                                        hit_attacker = true;
                                        c = bgch.length;
                                    }

                                }

                            }
                        }



                        /*
                    for (var b=0; b<proObj.possibleHitSquares.length; b++) {
                        if (hit_attacker == false) {
                            var sqObj = proObj.possibleHitSquares[b];
                            var xpos = background.mapToItem(sqObj.squareVisual, myx, myy).x;
                            var ypos = background.mapToItem(sqObj.squareVisual, myx, myy).y;
                            if ((xpos >= 0) && (xpos <= sqObj.squareVisual.width)) {
                                if ((ypos >= 0) && (ypos <= sqObj.squareVisual.height)) {
                                    if (sqObj.squareVisual.isActiveTarget) {
                                        for (var r=0; r<game.board.attackers.length; r++) {
                                            var attObj = game.board.attackers[r];
                                            //var attviz = attObj.attackerVisual;
                                            if (attObj.target == sqObj) {
                                                attObj.health = attObj.health - proObj.max_damage;
                                                if (attObj.health < 1) {
                                                    sqObj.squareVisual.isActiveTarget = false;
                                                    attObj.attackerVisual.destroy();
                                                    game.board.removeAttacker(attObj);


                                                    for (var g=0; g<sqObj.squareVisual.gunsInRange.length; g++) {
                                                        var tmp_gun = sqObj.squareVisual.gunsInRange[g];
                                                        if (tmp_gun != null) {
                                                            if (tmp_gun.gunVisual != null) {
                                                                tmp_gun.gunVisual.find_target();
                                                            }
                                                        }
                                                    }


                                                }
                                                hit_attacker = true;
                                                r = game.board.attackers.length;
                                                //break;

                                            }
                                        }
                                    }
                                }
                            }
                            if (hit_attacker == true) {
                                //break;
                            }
                        } else {
                            b = proObj.possibleHitSquares.length;
                        }
                    } */
                      //  var TL = truelength(proObj.origin_x, proObj.origin_y, proObj.x, proObj.y);
                        // var TL = Math.abs(proObj.x - proObj.origin_x) + Math.abs(proObj.y - proObj.origin_y);
                        //if ((TL >= proObj.max_dist) || (hit_attacker == true)) {
                        if ((hit_attacker == true) || (proObj.finito == true)) {
                            projectileHash[p].destroy();
                            projectileHash[p] = null;

                        }
                } else {
                       // projectileHash[p].destroy();
                       // projectileHash[p] = null;

                    }

                } else {
                    curProjectileArrayStop++;
                    if (curProjectileArrayStop > projectileHash.length) {
                        curProjectileArrayStop = projectileHash.length;
                    }
                }

            }

            if (curProjectileArrayStop >= projectileHash.length) {
                curProjectileArrayStart = 0;
                curProjectileArrayStop = numProjectilesPerFrame;
            } else {

                curProjectileArrayStart = curProjectileArrayStop;
                curProjectileArrayStop += numProjectilesPerFrame;
            }

            timerProjectiles.start();
        }
    }

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
        interval: 12000; running:false; repeat: true;
        onTriggered: function() {
            timerSpawn.stop();
            enemyCount = 0;
            clear_type_from_board("ProjectileVisual");
            for (var i=0; i<1000; i++) { projectileHash[i] = null; }

            timerCreateEnemy.start();



        }
    }
    Timer {
        id: timerCreateEnemy;
        interval: 2000;
        running: false;
        repeat: true;
        onTriggered: {



            //  var coefficient = Math.round(game.level * 0.2);
            game.board.placeAttacker(1,1,1, 9);
            enemyCount++;
            //init_attackers();
            if (enemyCount == 0) { init_attackers(); } else {
                game.board.lastSpawnedAttacker.health = 100  * game.level;
                create_atttacker(game.board.lastSpawnedAttacker);

                //game.board.lastSpawnedAttacker.attackerVisual.anim1.running = true;
                //game.board.lastSpawnedAttacker.attackerVisual.anim2.running = true;

            }

            if (enemyCount > numEnemiesPerWave) {
                game.level = game.level + 1;
                console.log("Game level is now " + game.level);
                timerCreateEnemy.stop();
                timerSpawn.start();
            }
        }
    }

    property int rotO: -1;
    property int stopO: 0;
    Timer {
        id: timerRotateGuns;
        interval: 50;
        running: true;
        repeat: true;

        onTriggered: function() {
            if (rotO == -1) { init_squares(); init_guns(); rotO = 0; stopO = rotO + 6; }
            if (stopO > game.board.guns.length) { stopO = game.board.guns.length; }
            timerRotateGuns.stop();
            for (var t=rotO; t<stopO; t++) {
                //var activeguns = [];
                //  for (var a=0; a<game.board.attackers.length; a++) {
                //    var attObj = game.board.attackers[a];
                //   var attTarget = attObj.target;
                // for (var u=0; u<attObj.target.squareVisual.gunsInRange.length; u++) {

                /* for (var u=0; u<game.board.squares.length; u++) {
                var sqViz = game.board.squares[u].squareVisual;
                if (sqViz.isActiveTarget) {
                    for (var g=0; g<game.board.guns.length; g++) {
                        var tmpGun = game.board.guns[g];
                        if (tmpGun.gunVisual.availableTargetSquares.indexOf(game.board.squares[u]) > -1) {
                            activeguns.push(tmpGun);
                        }
                    }
                }





            } */
                //
                //            }

                //          }

                //  for (var t=0; t<activeguns.length; t++) {
                var gunP = game.board.guns[t];
                var gunObj = gunP.gunVisual;

                var gunx = gunObj.x
                var guny = gunObj.y
                var closest_sq;
                var closest_dist = 99999;
                /*for (var a=0; a<game.board.attackers.length; a++) {

                    var attP = game.board.attackers[a];
                    var attObj = attP.attackerVisual;

                    var attx = attObj.x
                    var atty = attObj.y
                    var TL = truelength(gunx, guny, attx, atty);
                    if (TL < closest_dist) {
                        closest_att = attObj;
                        closest_dist = TL;
                    }


                } */
                /* for (var a=0; a<gunObj.availableTargetSquares.length; a++) {
                    var tmp_sq = gunObj.availableTargetSquares[a];
                    if (tmp_sq.squareVisual.isActiveTarget == true) {
                        var sqx = tmp_sq.squareVisual.x;
                        var sqy = tmp_sq.squareVisual.y;
                        var TL = truelength(gunx, guny, sqx, sqy);
                        if (TL < closest_dist) {
                            closest_sq = tmp_sq;
                            closest_dist = TL;
                        }
                    }

                } */

                // if (closest_dist <= gunP.rangeLowAccuracy) {
                /*          var tmpAngle = angleTo(gunx, guny, closest_sq.squareVisual.x, closest_sq.squareVisual.y);
                    if (gunObj.rotation != tmpAngle) {
                        gunObj.rotation = tmpAngle;
                    }
                    */

                if (gunObj.next_fire < Date.now()) {
                    if (gunObj.closest_sq != null) {
                        if (gunObj.closest_sq.squareVisual.isActiveTarget == true) {
                            create_projectile(gunP, gunObj.closest_sq.squareVisual.x + (gunObj.width * 0.5), gunObj.closest_sq.squareVisual.y + (gunObj.height * 0.5));

                            gunObj.next_fire = parseInt(Date.now() + 300);
                        }
                    }
                }
                // }


            }
            if (stopO == game.board.guns.length) {
                rotO = 0;
                stopO = 6;
            } else {
                rotO = stopO;
                stopO = rotO + 6;
            }

            timerRotateGuns.start();
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
                var bgch = background.children;
                for (var c=0; c<bgch.length; c++) {
                    var obj = bgch[c];
                    if (qmltypeof(obj, "SquareVisual")) {
                        var xpos = mapToItem(obj, mx, my).x;
                        var ypos = mapToItem(obj, mx, my).y;
                        if ((xpos >= 0) && (xpos <= obj.width)) {
                            if ((ypos >= 0) && (ypos <= obj.height)) {
                                var mRow = obj.square.row;
                                var mCol = obj.square.col;
                                game.board.placeGun(obj.square.row, obj.square.col, 1);

                                var shRoute = get_shortest_path(0,0, game.board.colCount - 1, game.board.rowCount - 1);
                                if (shRoute[2] != null) {
                                    game.board.clear_path_data();
                                    console.log(shRoute.length + " - " + shRoute);
                                    var q = 0;
                                    while (shRoute[q] != null) {
                                        game.board.add_path_data(parseInt(shRoute[q][0]),parseInt(shRoute[q][1]));
                                        q++;
                                        //console.log(nd);
                                    }
                                    create_gun(obj.square.row, obj.square.col);
                                } else {

                                    //game.board.placeSquare(mRow, mCol);

                                    game.board.removeGun(obj.square.row, obj.square.col);
                                    shRoute = get_shortest_path(0,0, game.board.colCount - 1, game.board.rowCount - 1);
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
                                timerSpawn.running = true;

                                // update_squares();

                                //init_guns();
                                //init_attackers();
                                //game.board.correctPaths();

                                //return " " + c + " " + obj + " " + mx + " " + my;
                            }
                        }
                    }
                }
                //update_squares();
                //init_guns();
                // init_attackers();
                //init_attackers();
                update_guns();
                //init_attackers();
                //game.board.correctPaths();
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
}
