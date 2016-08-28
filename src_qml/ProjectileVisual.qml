import QtQuick 2.0
import com.towerdefense.fullcommand 2.0


Item {
    property var origin_x;
    property var origin_y;
    property var ctx;
    property var cty;
    property var speed;
    property var max_dist;
    property var projectile_type;
    property var proximity_dist;
    property var splash_distance;
    property var max_damage;
    property var min_damage;



  /*  Rectangle {
        border.color: "black"
        border.width: 2
        color: "gray"
        width: parent.width
        height: parent.height
        id: rect

        anchors.centerIn: parent



    } */
    Image {
        source: "./images/projectiles/" + projectile_type + ".png"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

    }

}
