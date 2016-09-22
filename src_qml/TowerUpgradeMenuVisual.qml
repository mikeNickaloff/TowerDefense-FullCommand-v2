import QtQuick 2.6
import com.towerdefense.fullcommand 2.0
import QtQuick.Particles 2.0
import QtQuick.Layouts 1.3

TowerUpgradeMenu {
    id: towerUpgradeMenu
    width: background.width * 0.3
    height: background.height * 0.5
    anchors.right: background.right
    z: 100
    opacity: 0
    onVisibleChanged: {
        if (visible == true) {
            towerChooser.visible = false;
            towerChooser.enabled = false;
        }
    }

    property Gun gun
    signal upgradeRange(Gun i_gun)
    signal upgradeDamage(Gun i_gun)
    function set_next_levels(range_new_level, damage_new_level) {
        var gu = towerUpgradeMenu.gun;
        var rangeCost = gu.gunVisual.getRangeCost(gu.gunRangeLevel + 1);
        rangeButtonText.text = "Range -> [" + Math.round(range_new_level) + "] Cost: $" + Math.round(rangeCost);
        var damageCost = gu.gunVisual.getDamageCost(gu.gunDamageLevel + 1);
        damageButtonText.text = "Damage -> [" + Math.round(damage_new_level) + "] Cost: $" + Math.round(damageCost);

    }

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
                    var gu = towerUpgradeMenu.gun;
                    var rangeCost = gu.gunVisual.getRangeCost(1 + gu.gunRangeLevel);
                    if (game.money > rangeCost) {
                        towerUpgradeMenu.upgradeRange(towerUpgradeMenu.gun);
                        rangeButton.color = "gray";
                        fixUpgradeMenuColors.running = true;
                    } else {


                    }

                }
            }
            id: rangeButton
            color: "lightblue"; radius: 2.0
            width: background.width * 0.5; height: background.height * 0.2;

            Text { id: rangeButtonText; anchors.centerIn: parent
                font.pointSize: 16; text: "Range" } }

        Rectangle {

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var gu = towerUpgradeMenu.gun;
                    var damageCost = gu.gunVisual.getDamageCost(gu.gunDamageLevel + 1);
                    if (damageCost < game.money) {
                        towerUpgradeMenu.upgradeDamage(towerUpgradeMenu.gun);
                        damageButton.color = "gray";
                        fixUpgradeMenuColors.running = true;
                    }
                }
            }
            id: damageButton
            color: "darkgreen"; radius: 2.0
            width: background.width * 0.5; height: background.height * 0.2;
            Text { id:damageButtonText; anchors.centerIn: parent
                font.pointSize: 16; text: "Damage" } }
        Rectangle {
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    towerUpgradeMenu.enabled = false;
                    towerUpgradeMenu.opacity = 0;
                }
            }
            color: "lightgreen"; radius: 0
            width: background.width * 0.5; height: background.height * 0.2;
            Text { anchors.centerIn: parent
                font.pointSize: 16; text: "Close" } }



    }
}
