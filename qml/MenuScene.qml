import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.0

Scene {
    id: menuScene

    signal sceneChange(string scene)
    signal loadVideo(string movFileName, string subsFileName)

    property var dispName: ['La La Land', 'Belle et La Bete']
    property var movFiles: ['La La Land 1.m4v', 'Belle et La Bete.mp4']
    property var subsFiles: ['LaLaLand.json', 'BelleEtLaBete.json']

    Page {
        id: mainPage

        Row {
            anchors.centerIn: parent

            Repeater {
                id: repeater
                model: movFiles

                // text to show the current count and button to push the second page
                AppButton {
                    text: dispName[index]
                    onClicked: {
                        loadVideo(movFiles[index], subsFiles[index])
                    }
                }
            }
        }
    }
}
