import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.0

Scene {
    id: menuScene

    signal sceneChange(string scene)
    signal loadVideo(string movFileName, string subsFileName)

    property var dispName: ['La La Land', 'Belle et La Bete', 'Johnny English']
    property var movFiles: ['La La Land 1.m4v', 'Belle et La Bete.mp4', 'Johnny English - Contre attaque.mp4']
    property var subsFiles: ['LaLaLand.json', 'BelleEtLaBete.json', 'JohnnyEnglish.json']
    property var thumbnailFiles: ['LaLaLand.png', 'BelleEtLaBete.png', 'JohnnyEnglish.png']
    property var thumbnailFgFiles: ['LaLaLandFg.png', 'BelleEtLaBeteFg.png', 'JohnnyEnglishFg.png']
    property int btnWidth: dp(200)

    Page {
        id: mainPage

        Row {
            anchors.centerIn: parent
            spacing: 0.5*btnWidth

            Repeater {
                id: repeater
                model: movFiles

                // text to show the current count and button to push the second page
                ThumbnailButton {
                    filename: "../assets/thumbnails/" + thumbnailFiles[index]
                    fgFilename: "../assets/thumbnails/" + thumbnailFgFiles[index]
                    width: btnWidth
                    height: btnWidth
                    text: dispName[index]
                    onImgClickSignal: loadVideo(movFiles[index], subsFiles[index])
                }
            }
        }
    }
}
