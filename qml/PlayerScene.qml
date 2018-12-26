import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.0

Scene {
    id: playerScene

    opacity: 0

    Behavior on opacity {NumberAnimation {duration: 250}}

    // load levels at runtime
    Loader {
        id: loader
        source: "Player.qml"
        onLoaded: {
            // since we did not define a width and height in the level item itself, we are doing it here
            item.width = parent.width
            item.height = parent.height
        }
    }
}
