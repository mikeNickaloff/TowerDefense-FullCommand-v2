import QtQuick 2.6
import QtQuick.Window 2.2
import com.towerdefense.fullcommand 2.0
import QtQuick.Particles 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2

TowerChooser {
    id: towerChooser
    z: 105
    height: background.height
    width: background.width * 0.2
    visible: false
    enabled: false
    anchors.right: background.right
    property bool builtFirstTower: false
    property Square square: null
    ListModel {
        id:  gunShopModel
        ListElement {
            gunType: 1
            gunLabel: "Turret"
            gunDamage: 10
            gunRange: 200
            gunRangeHighAccuracy: 0.75
            gunDamageHighAccuracy: 1.25
            gunMaxOffsetHighAccuracy: 5

            gunRangeLowAccuracy: 1.25
            gunDamageLowAccuracy: 0.75
            gunMaxOffsetLowAccuracy: 30

            gunFireDelay: 700

            gunProjectileSpeed: 18
            // double turnRate;

            gunAttacksAir: true
            gunAttacksGround: true
            //bool slowOnHit;

            //double slowPct;
            //int slowTime;

            gunSplashRadius: 30
            gunProximityDistance: 20

            gunUpgradeRangeAmountMultiplier: 1.12
            gunUpgradeRangeCostMultiplier: 4
            gunUpgradeRangeCost: 5


            gunUpgradeDamageAmountMultiplier: 1.87
            gunUpgradeDamageCostMultiplier: 4
            gunUpgradeDamageCost: 5


            //  double upgradeProjectileSpeedAmount;
            //        double upgradeProjectileSpeedCost;

            gunMaxUpgradeLevel: 10

            gunRangeLevel: 1
            gunDamageLevel: 1
            gunCost: 20
        }
        ListElement {
            gunType: 2
            gunLabel: "MachineGun"
            gunDamage: 3
            gunRange: 150
            gunRangeHighAccuracy: 0.95
            gunDamageHighAccuracy: 1.45
            gunMaxOffsetHighAccuracy: 1

            gunRangeLowAccuracy: 1.35
            gunDamageLowAccuracy: 0.85
            gunMaxOffsetLowAccuracy: 10

            gunFireDelay: 150

            gunProjectileSpeed: 54
            // double turnRate;

            gunAttacksAir: true
            gunAttacksGround: true
            //bool slowOnHit;

            //double slowPct;
            //int slowTime;

            gunSplashRadius: 5
            gunProximityDistance: 5

            gunUpgradeRangeAmountMultiplier: 1.04
            gunUpgradeRangeCostMultiplier: 8
            gunUpgradeRangeCost: 2


            gunUpgradeDamageAmountMultiplier: 1.9
            gunUpgradeDamageCostMultiplier: 4
            gunUpgradeDamageCost: 2


            //  double upgradeProjectileSpeedAmount;
            //        double upgradeProjectileSpeedCost;

            gunMaxUpgradeLevel: 10

            gunRangeLevel: 1
            gunDamageLevel: 1
            gunCost: 10
        }
    }



    Component {
        id: gunShopDelegate
        Rectangle {
            height: background.height * 0.3
            z: 200
            width: background.width * 0.17
            anchors.margins: 12
             border.width: 1
             border.color: "black"
            color: "gray"
            Column {


                Image {
                    id: gunShopImage

                    source: "./images/guns/" + gunType + ".png"

                    width: background.width * 0.1
                    height: background.height * 0.1



                }
                Text {
                    id: textGunLabel
                    //anchors.top: gunShopImage.bottom
                    text: gunLabel;

                }
                Text {
                    id: textGunDamageLabel
                    //anchors.top: textGunLabel.bottom
                    text: "Damage: " + gunDamage

                }
                Text {
                    id: textGunRangeLabel
                    //anchors.top: textGunDamageLabel.bottom
                    text: "Range:  " + gunRange
                }
            }

            MouseArea {

                width: parent.width
                height: parent.height
                id:mouse_area
                onClicked: {

                    console.log(gunShopModel.get(index).gunType + " " + towerChooser.square);
                    var obj = towerChooser.square.squareVisual;
                    var mt = gunShopModel.get(index);


                    //game.board.placeGun(obj.square.row, obj.square.col, gunShopModel.get(index).gunType);
                    game.board.placeGun2(obj.square.row, obj.square.col, mt.gunType, mt.gunDamage, mt.gunRange, mt.gunRangeHighAccuracy, mt.gunDamageHighAccuracy, mt.gunMaxOffsetHighAccuracy, mt.gunRangeLowAccuracy, mt.gunDamageLowAccuracy, mt.gunMaxOffsetLowAccuracy, mt.gunFireDelay, mt.gunProjectileSpeed, mt.gunAttacksAir, mt.gunAttacksGround, mt.gunSplashRadius, mt.gunProximityDistance, mt.gunUpgradeRangeAmountMultiplier, mt.gunUpgradeRangeCostMultiplier, mt.gunUpgradeRangeCost, mt.gunUpgradeDamageAmountMultiplier, mt.gunUpgradeDamageCostMultiplier, mt.gunUpgradeDamageCost, mt.gunMaxUpgradeLevel, mt.gunRangeLevel, mt.gunDamageLevel, mt.gunCost);
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
                            towerChooser.visible = false;
                            towerChooser.enabled = false;
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
                            towerChooser.visible = false;
                            towerChooser.enabled = false;
                        } else {



                        }

                    }
                    if (towerChooser.builtFirstTower == false) {
                        //timerSpawn.running = true;
                        timerCreateEnemy.running = true;
                        towerChooser.builtFirstTower = true;
                    }


                }
            }

        }

    }
    Rectangle {
        color: "white"
        width: background.width
        height: background.height

        z: 100


        ListView {
            width: background.width
            height: background.height
            z: 105


            anchors.centerIn: parent
            id: gunShopView
            model: gunShopModel
            delegate: gunShopDelegate


        }
        Button {
            id: closeButton
            anchors.top: gunShopView.bottom
            onClicked:  {
                towerChooser.enabled = false;
                towerChooser.visible = false;
            }
            text: "Close"
        }
    }
}
