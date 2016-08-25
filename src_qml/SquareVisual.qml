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

}

