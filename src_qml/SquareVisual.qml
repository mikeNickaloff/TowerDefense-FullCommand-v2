import QtQuick 2.0
import com.towerdefense.fullcommand 2.0


Item {
    property Square square
    Rectangle {
        border.color: "black"
        border.width: 2
        color: "gray"
        width: parent.width
        height: parent.height
        id: rect


        anchors.centerIn: parent



    }


    function centerX() { return x + (width * 0.5); }
    function centerY() { return y + (height * 0.5); }

    property int distanceToEnd: 255;
    property var gunsInRange: new Array;
    property bool isActiveTarget: false
    signal becameActiveTarget(bool i_isActiveTarget, int row, int col, int i_distanceToEnd);
    signal lostActiveTarget(Square i_square);
    onIsActiveTargetChanged: function() {
        if (isActiveTarget == true) { becameActiveTarget(true, square.row, square.col, distanceToEnd); } else {
            lostActiveTarget(square);
        }
    }
    signal projectile_hit(var min_damage, var max_damage, var splash_distance, var projectile_type);

}

