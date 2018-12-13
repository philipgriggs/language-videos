import VPlayApps 1.0
import QtQuick 2.5
import QtMultimedia 5.0

Item {

    id: nav

    Row {
        anchors.centerIn: parent
        property real minWidth: dp(30)

        AppButton {
            minimumWidth: minimumWidth
            minimumHeight: minimumWidth
            width: dp(40)
            height: dp(40)
            icon: IconType.angledoubleleft
            backgroundColor: "#555555"
            backgroundColorPressed: "#333333"
            onClicked: skipBack()
        }

        AppButton {
            minimumWidth: minimumWidth
            minimumHeight: minimumWidth
            width: dp(40)
            height: dp(40)
            icon: video.playbackState === MediaPlayer.PlayingState ? IconType.pause : IconType.play
            backgroundColor: "#555555"
            backgroundColorPressed: "#333333"
            onClicked: playPause()
        }

        AppButton {
            minimumWidth: minimumWidth
            minimumHeight: minimumWidth
            width: dp(40)
            height: dp(40)
            icon: IconType.angledoubleright
            backgroundColor: "#555555"
            backgroundColorPressed: "#333333"
            onClicked: skipBack()
        }

        Slider{
            width: dp(400)
        }
    }

}
