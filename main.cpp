#include <QtCore/qglobal.h>
#if QT_VERSION >= 0x050000
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>

#else
#endif

#include <QQmlContext>
#include <QObject>
#include <QCoreApplication>
#include <QtQml/qqml.h>
#include "src_game/game.h"
#include "src_elements/board.h"
#include "src_game/map.h"
#include "src_elements/square.h"
#include "src_elements/wall.h"
#include "src_elements/start.h"
#include "src_elements/end.h"
#include "src_elements/gun.h"
#include "src_elements/attacker.h"
#include "src_elements/projectile.h"
#include "src_ui/towerchooser.h"
#include "src_ui/towerinfo.h"

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    //m_game->createBoard();
    QQmlApplicationEngine engine;
    qmlRegisterType<Game>("com.towerdefense.fullcommand", 2, 0, "Game");
    qmlRegisterType<Board>("com.towerdefense.fullcommand", 2, 0, "Board");
    qmlRegisterType<Square>("com.towerdefense.fullcommand", 2, 0, "Square");
    qmlRegisterType<Gun>("com.towerdefense.fullcommand", 2, 0, "Gun");
    qmlRegisterType<Attacker>("com.towerdefense.fullcommand", 2, 0, "Attacker");
    qmlRegisterType<Projectile>("com.towerdefense.fullcommand", 2, 0, "Projectile");
    qmlRegisterType<TowerChooser>("com.towerdefense.fullcommand", 2, 0, "TowerChooser");
    qmlRegisterType<TowerInfo>("com.towerdefense.fullcommand", 2, 0, "TowerInfo");
   // Game* m_game = new Game(0, engine.rootContext());

  //  engine.rootContext()->setContextProperty("game", m_game);
    //m_game->createBoard();
   // engine.rootContext()->setContextProperty("gameboard", m_game->m_board);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

//    QtQuickControlsApplication app(argc, argv);

        //QQmlApplicationEngine engine(QUrl("qrc:/qml/main.qml"));
        //if (engine.rootObjects().isEmpty())
         //   return -1;
        //return app.exec();

    return app.exec();
}
