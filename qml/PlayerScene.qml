import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.0
import QtMultimedia 5.9

Scene {
    id: playerScene

    signal back()

    opacity: 0
    Behavior on opacity {NumberAnimation {duration: 250}}

    function loadVideo(movFileName, subsFileName, widescreen) {
        loader.item.movFileName = "../assets/mov/" + movFileName
        loader.item.parseJson("../assets/subs/" + subsFileName)
        loader.item.widescreen = widescreen
        loader.item.video.focus = true
    }

    Keys.onSpacePressed: {
        if (loader.item.video.playbackState === MediaPlayer.PlayingState) {
            loader.item.video.pause()
        } else {
            loader.item.dispCurrSub()
            loader.item.skipBack()
        }
    }
    Keys.onLeftPressed: loader.item.skipBack()
    Keys.onRightPressed: loader.item.skipForward()

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
