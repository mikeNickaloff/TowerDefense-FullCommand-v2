import QtQuick 2.0
import com.towerdefense.fullcommand 2.0

Rectangle {
    id: hudRect

    color: "transparent"
    ScoreHUD {
        Row {
            Text {
                text: "Money: $" + game.money
                font.family: "Consolas"
                horizontalAlignment: Text.AlignHCenter
                style: Text.Raised
                font.pointSize: 12
                width: 200
                styleColor: "#0aec28"

                color: "#0aec28"
            }
            Text {
                text: "Level: " + game.level
                font.family: "Consolas"
                horizontalAlignment: Text.AlignHCenter
                style: Text.Raised
                font.pointSize: 12
                width: 200
                styleColor: "#0aec28"

                color: "#0aec28"
            }

        }
    }
}
