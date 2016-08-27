import QtQuick 2.6
import QtQuick.Window 2.2
import com.towerdefense.fullcommand 2.0

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
    }
    function update_squares() {
        var tmp_sq = game.board.squares;



        for (var u=0; u<tmp_sq.length; u++) {

            var squ = tmp_sq[u];
            var sqvis = squ.squareVisual;
            sqvis.width = (background.width / game.board.colCount);
            sqvis.height = (background.height / game.board.rowCount);
            sqvis.x = (background.width / game.board.colCount) * squ.col;
            sqvis.y = (background.height / game.board.rowCount) * squ.row;

        }
    }

    function init_guns() {
        clear_type_from_board("GunVisual");
        var component;
        component = Qt.createComponent("src_qml/GunVisual.qml");
        var tmp_sq = game.board.guns;
        for (var u=0; u<tmp_sq.length; u++) {
            var squ = tmp_sq[u];
            if (component.status == Component.Ready) {
                var dynamicObject = component.createObject(background, { "gun" : squ });
                dynamicObject.width = (background.width / game.board.colCount);
                dynamicObject.height = (background.height / game.board.rowCount);
                dynamicObject.x = (background.width / game.board.colCount) * squ.col;
                dynamicObject.y = (background.height / game.board.rowCount) * squ.row;
                squ.set_gunVisual(dynamicObject);
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

        }
    }

    function init_attackers() {

        clear_type_from_board("AttackerVisual");


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
    Timer {
        id:timerAttackers;
        interval: 150; running: true; repeat: true
        onTriggered: function() {



            for (var r=0; r<game.board.attackers.length; r++) {
                var attObj = game.board.attackers[r];
                var attviz = attObj.attackerVisual;

                if (attviz.waiting_for_waypoint) {
                    //   attacker.next_target();

                    attviz.startX = attviz.x;
                    attviz.startY = attviz.y;
                    attviz.endX = attObj.target.squareVisual.x;
                    attviz.endY = attObj.target.squareVisual.y;
                    var angle = Math.atan2(attviz.endY - attviz.y, attviz.endX - attviz.x);

                    attviz.ecdx = attObj.speed * Math.cos(angle);
                    attviz.ecdy = attObj.speed * Math.sin(angle);
                    attviz.waiting_for_waypoint = false;
                }


                attviz.step();
                if (attObj.speed == 0) {
                    // bgch[c].destroy();

                    game.board.removeAttacker(attObj);
                    //attObj.attackerVisual.destroy();
                    //attviz.destroy();


                    init_attackers();

                }



                // game.board.correctPaths();

                //}


            }
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
            interval: 10000; running:true; repeat: true;
            onTriggered: function() {



                game.board.placeAttacker(0,1, 1, 8.3);
                init_attackers();
                if (enemyCount == 0) { init_attackers(); } else {

                    create_atttacker(game.board.lastSpawnedAttacker);
                }
                enemyCount++;



            }
        }
        property int rotO: 0;
        Timer {
            id: timerRotateGuns;
            interval: 160;
            running: true;
            repeat: true;

            onTriggered: function() {

                for (var t=0; t<game.board.guns.length; t++) {

                    var gunP = game.board.guns[t];
                    var gunObj = gunP.gunVisual;

                    var gunx = gunObj.x
                    var guny = gunObj.y
                    var closest_att;
                    var closest_dist = 99999;
                    for (var a=0; a<game.board.attackers; a++) {

                        var attP = game.board.attackers[a];
                        var attObj = attP.attackerVisual;

                        var attx = attObj.x
                        var atty = attObj.y
                        var TL = truelength(gunx, guny, attx, atty);
                        if (TL < closest_dist) {
                            closest_att = attObj;
                            closest_dist = TL;
                        }


                    }
                    if (closest_dist <= gunP.rangeLowAccuracy) {
                        var tmpAngle = angleTo(gunx, guny, closest_att.x, closest_att.y);
                        gunObj.rotation = tmpAngle;
                    }

                }

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
                                    game.board.placeGun(obj.square.row, obj.square.col, 1);
                                   // obj.square.squareVisual.destroy();

                                    update_squares();
                                    init_guns();
                                    init_attackers();
                                    game.board.correctPaths();

                                    return " " + c + " " + obj + " " + mx + " " + my;
                                }
                            }
                        }
                    }
                    update_squares();
                    init_guns();
                    init_attackers();
                    //init_attackers();

                    //init_attackers();
                    game.board.correctPaths();
                    return "nothing";
                } else {
                    return "uninitialized.";
                }
            }



            Text {
                id: testBox
                text: qsTr("Hello World")
                anchors.centerIn: parent
            }
        }
    }
