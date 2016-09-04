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

        }
        property var grid;
        property var finder;
    }

    function get_shortest_path(c1, r1, c2, r2) {
        return Logic.get_shortest_path(c1, r1, c2, r2);
    }


    property var squareHash: new Array(10);
    property var squareObjHash : new Array(10);
    property var gunHash: new Array(10);
    property var attackerHash: new Array(10);


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
                                    sqEl.isActiveTargetChanged.connect(gu.gunVisual.find_target);
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




            var dynamicObject = component.createObject(background, { "attacker" : squ, "startX" : getX(squ.current.col), "x" : getX(squ.current.col), "y" : getY(squ.current.row),  "startY" : getY(squ.current.row), "endX" : getX(squ.target.col), "endY" : getY(squ.target.row), "speed" : squ.speed,  "ecdx" : 0, "ecdy" : 0 });
            dynamicObject.width = (background.width / game.board.colCount);
            dynamicObject.height = (background.height / game.board.rowCount);


            squ.set_attackerVisual(dynamicObject);
            squ.attackerVisual.attackerPathFinished.connect(handleAttackerReachedEnd);




        }
    }

    function handleAttackerReachedEnd(attackerObject) {
        attackerObject.target.squareVisual.isActiveTarget = false;
        attackerObject.current.squareVisual.isActiveTarget = false;

        attackerObject.attackerVisual.destroy();
        game.board.removeAttacker(attackerObject);

    }

    property var projectileHash: new Array(1005);
    property Component projectileComponent: Qt.createComponent("src_qml/ProjectileVisual.qml");



    function create_projectile(gunObj, target_x, target_y) {

        var component = projectileComponent;
        if (component.status == Component.Ready) {



            var newObj = component.createObject(background, { "origin_x" : gunObj.gunVisual.x , "origin_y" : gunObj.gunVisual.y, "ctx" : 0, "cty" : 0, "speed" : 25, "max_dist" : gunObj.rangeLowAccuracy, "projectile_type" : 1, "proximity_dist" : 20, "splash_distance" : 10, "max_damage" : 10, "min_damage" : 10, "possibleHitSquares" : gunObj.gunVisual.availableTargetSquares, "target_x" : target_x, "target_y" : target_y, "finito" : false, "opacity" : 0 } );
            newObj.width = (background.width / game.board.colCount) * 0.30;
            newObj.height = (background.height / game.board.rowCount) * 0.3;
            newObj.x = gunObj.gunVisual.x + (gunObj.gunVisual.width * 0.5);
            newObj.y = gunObj.gunVisual.y + (gunObj.gunVisual.height * 0.5);
            var o = 0;


            gunObj.gunVisual.add_ammo_round(newObj);

            newObj.arrivedAtTarget.connect(handleProjectileArrival);
            newObj.finitoChanged.connect(gunObj.gunVisual.check_projectiles);

        }
    }
    function handleProjectileArrival(i_target_x, i_target_y, i_min_damage, i_max_damage, i_splash_distance) {
        var attackerObjects = game.board.attackers;



        var myx = i_target_x;
        var myy = i_target_y;
        var hit_attacker = false;



        for (var c=0; c<attackerObjects.length; c++) {
            var obj = attackerObjects[c].attackerVisual;

            var apos = background.mapToItem(obj, myx, myy)
            var xpos = apos.x;
            var ypos = apos.y;
            if ((xpos >= 0) && (xpos <= obj.width)) {
                if ((ypos >= 0) && (ypos <= obj.height)) {
                    obj.attacker.health = obj.attacker.health - i_max_damage;
                    if (obj.attacker.health < 1) {
                        obj.attacker.current.squareVisual.isActiveTarget = false;
                        obj.attacker.target.squareVisual.isActiveTarget = false;
                        var attObj = obj.attacker;
                        obj.destroy();
                        game.board.removeAttacker(attObj);

                    }

                    c = attackerObjects.length;
                }

            }


        }

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
    property int numEnemiesPerWave: 10
    property int numWavesPerLevel: 5
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
        interval: 12000; running:false; repeat: true;
        onTriggered: function() {
            timerSpawn.stop();
            enemyCount = 0;

            timerCreateEnemy.start();



        }
    }
    Timer {
        id: timerCreateEnemy;
        interval: 1800;
        running: false;
        repeat: true;
        onTriggered: {




            game.board.placeAttacker(1,Math.round(game.board.colCount * 0.5),1, 9);
            enemyCount++;

            if (enemyCount == 0) { init_attackers(); } else {
                game.board.lastSpawnedAttacker.health = 30  * game.level;
                create_atttacker(game.board.lastSpawnedAttacker);



            }

            if (enemyCount > numEnemiesPerWave) {
                waveCount++;
                if (waveCount > numWavesPerLevel) { waveCount = 0; game.level = game.level + 1; console.log("Game level is now " + game.level); }
                timerCreateEnemy.stop();
                timerSpawn.start();


            }
        }
    }

    property int rotO: -1;
    property int stopO: 0;
    Timer {
        id: timerRotateGuns;
        interval: 75;
        running: true;
        repeat: true;

        onTriggered: function() {
            if (rotO == -1) { init_squares(); init_guns(); rotO = 0; stopO = rotO + 36; }
            if (stopO > game.board.guns.length) { stopO = game.board.guns.length; }

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

                            gunObj.next_fire = parseInt(Date.now() + 300);
                        }
                    }
                }
                // }


            }
            if (stopO == game.board.guns.length) {
                rotO = 0;
                stopO = 36;
            } else {
                rotO = stopO;
                stopO = rotO + 36;
            }

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
                                    }
                                }

                                timerSpawn.running = true;


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
}
