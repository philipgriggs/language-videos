import VPlayApps 1.0
import QtQuick 2.5
import QtMultimedia 5.0

Item {

    id: nav
    property alias ccButton: ccButton

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 0
        property real minWidth: dp(30)
        property color bgColorPressed: "#999999"
        property color fgColor: "#cccccc"

        IconButton {
            width: row.minWidth
            height: row.minWidth
            icon: IconType.angledoubleleft
            color: row.fgColor
            selectedColor: row.bgColorPressed
            onClicked: skipBack()
        }

        IconButton {
            width: row.minWidth
            height: row.minWidth
            icon: video.playbackState === MediaPlayer.PlayingState ? IconType.pause : IconType.play
            color: row.fgColor
            selectedColor: row.bgColorPressed
            onClicked: playPause()
        }

        IconButton {
            width: row.minWidth
            height: row.minWidth
            icon: IconType.angledoubleright
            color: row.fgColor
            selectedColor: row.bgColorPressed
            onClicked: skipForward()
        }

        CcButton {
            id: ccButton
            width: row.minWidth
            height: row.minWidth
            bgColorPressed: bgColorPressed
            fgColor: fgColor
        }
    }

    Slider{
        id: slider
        width: 0.8 * screenWidth
        anchors.top: row.bottom
        anchors.topMargin: dp(10)
        anchors.horizontalCenter: parent.horizontalCenter
        value: video.position / video.duration
    }

}
