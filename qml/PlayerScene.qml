import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.0

Scene {
    id: playerScene

    signal back()

    opacity: 0
    Behavior on opacity {NumberAnimation {duration: 250}}

    function loadVideo(movFileName, subsFileName) {
        loader.item.movFileName = "../assets/mov/" + movFileName
        loader.item.parseJson("../assets/subs/" + subsFileName)
        loader.item.video.focus = true
    }

    // load levels at runtime
    Loader {
        id: loader
        source: "Player.qml"
        onLoaded: {
            // since we did not define a width and height in the level item itself, we are doing it here
            item.width = parent.width
            item.height = parent.height
            item.backSignal = back
        }
    }
}
