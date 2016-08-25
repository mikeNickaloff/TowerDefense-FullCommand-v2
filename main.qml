import QtQuick 2.6
import QtQuick.Window 2.2
import com.towerdefense.fullcommand 2.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    Item {
        id: background
        width: 640
        height: 480
        anchors.fill: parent
    }

    Game {
        id: game


        Component.onCompleted: {
            game.createBoard();
            //  init_squares();

        }
    }


    property var squareHash: new Array(10000);



    function init_squares() {
        var component;
        var bgch = background.children;
        for (var c=0; c<bgch.length; c++) {
            var obj = bgch[c];
            if (qmltypeof(obj, "SquareVisual")) {
                obj.destroy();
            }

        }
        for (var p=0; p<squareHash.length; p++) {
            squareHash[p] = null;
        }
        component = Qt.createComponent("src_qml/SquareVisual.qml");
        var rv =  "square count is: ";
        var tmp_sq = game.board.squares;
        rv += " " + tmp_sq.length;
        for (var u=0; u<tmp_sq.length; u++) {

            var squ = tmp_sq[u];

            if (component.status == Component.Ready) {
                var dynamicObject = component.createObject(background, { "square" : squ });
                dynamicObject.width = (background.width / game.board.colCount);
                dynamicObject.height = (background.height / game.board.rowCount);
                dynamicObject.x = (background.width / game.board.colCount) * squ.col;
                dynamicObject.y = (background.height / game.board.rowCount) * squ.row;
                squareHash[u] = dynamicObject;
            }

        }

    }
    function qmltypeof(obj, className) { // QtObject, string -> bool
      // className plus "(" is the class instance without modification
      // className plus "_QML" is the class instance with user-defined properties
      var str = obj.toString();
      return str.indexOf(className + "(") == 0 || str.indexOf(className + "_QML") == 0;
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
                    var xpos = mapToItem(obj, mx, my).x;
                    var ypos = mapToItem(obj, mx, my).y;
                    if ((xpos >= 0) && (xpos <= obj.width)) {
                        if ((ypos >= 0) && (ypos <= obj.height)) {
                            return " " + c + " " + obj + " " + mx + " " + my;
                        }
                    }
                }
                init_squares();
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