import QtQuick 2.0
import com.towerdefense.fullcommand 2.0


Item {

    property Gun gun
    property AttackerVisual target
  /*  Rectangle {
        border.color: "black"
        border.width: 2
        color: "gray"
        width: parent.width
        height: parent.height
        id: rect

        anchors.centerIn: parent



    } */
    property var availableTargetSquares: new Array
    Image {
        source: "./images/guns/" + gun.gunType + ".png"
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

    }
    property var next_fire : 1;

}
