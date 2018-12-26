import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.0

GameWindow {
    id: app

    // main page
    MenuScene {
        id: menuScene
        anchors.fill: parent
        onSceneChange: {
            app.state = "player"
        }
    }

    // inline-definition of a component, which is later pushed on the stack
    PlayerScene {
        id: playerScene
        width: parent.width
        height: parent.height
    }

    // menuScene is our first scene, so set the state to menu initially
    state: "menu"
    activeScene: menuScene

    // state machine, takes care reversing the PropertyChanges when changing the state, like changing the opacity back to 0
    states: [
        State {
            name: "menu"
            PropertyChanges {target: menuScene; opacity: 1}
            PropertyChanges {target: app; activeScene: menuScene}
        },
        State {
            name: "player"
            PropertyChanges {target: playerScene; opacity: 1}
            PropertyChanges {target: app; activeScene: playerScene}
        }
    ]
}
