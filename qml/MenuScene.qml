import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.5
import QtGraphicalEffects 1.0

Scene {
    id: menuScene

    signal sceneChange(string scene)
    signal loadVideo(string movFileName, string subsFileName, string language, bool widescreen)

    property var dispName: ['La La Land', 'Belle et La Bete', 'Johnny English', 'Johnny English', 'Vice Versa', 'Vice Versa (2)', 'Là-haut', 'Le Bossu de Notre Dame', 'Buscando a Nemo', 'Harry Potter', 'Harry Potter (2)', 'Monsters Inc']
    property var movFiles: ['La La Land 1.m4v', 'Belle et La Bete.mp4', 'Johnny English - Contre attaque.mp4', 'Johnny English - Contre attaque.mp4', 'Vice Versa 1.mp4', 'Vice Versa 2.mp4', 'Up.mp4', 'Le Bossu de Notre Dame 2.mp4', 'Finding Nemo.mp4', 'Harry Potter.mp4', 'Harry Potter 2.mp4', 'Monsters Inc.mp4']
    property var subsFiles: ['LaLaLand.json', 'BelleEtLaBete.json', 'JohnnyEnglish.json', 'JohnnyEnglish.json', 'ViceVersa.json', 'ViceVersa2.json', 'Up.json', 'LeBossuDeNotreDame2.json', 'FindingNemo.json', 'HarryPotter.json', 'HarryPotter2.json', 'MonstersInc.json']
    property var thumbnailFiles: ['LaLaLandSprite/12.jpg', 'BelleEtLaBeteSprite/13.jpg', 'JohnnyEnglishSprite/12.jpg', 'JohnnyEnglishSprite2/12.jpg', 'ViceVersaSprite/12.jpg', 'ViceVersaSprite2/10.jpg', 'UpSprite/12.jpg', 'HunchbackOfNotreDameSprite/14.jpg', 'FindingNemoSprite/12.jpg', 'HarryPotterSprite/12.jpg', 'HarryPotterSprite2/12.jpg', 'MonstersIncSprite/12.jpg']
    property var thumbnailFgFiles: ['', '', '', '', '', '', 'UpFg.png', '', 'FindingNemoFg.png', '', '', '']
    property var thumbnailSpriteFiles: ['LaLaLandSprite', 'BelleEtLaBeteSprite', 'JohnnyEnglishSprite', 'JohnnyEnglishSprite2', 'ViceVersaSprite', 'ViceVersaSprite2', 'UpSprite', 'HunchbackOfNotreDameSprite', 'FindingNemoSprite', 'HarryPotterSprite', 'HarryPotterSprite2', 'MonstersIncSprite']
    property var thumbnailSpriteFrames: [12, 13, 12, 12, 12, 10, 12, 14, 12, 12, 12, 12]
    property var language: ['french', 'french', 'french', 'french', 'french', 'french', 'french', 'french', 'spanish', 'spanish', 'spanish', 'spanish']
    property var widescreen: [true, true, true, true, false, false, false, false, false, true, true, false]

    function alignMiddle() {
        listView.positionViewAtIndex(listView.model * 0.5 - (listView.numberOfItems > 2 ? 1 : 0), ListView.SnapPosition)
    }

    // needed because 'onCompleted' isn't firing correctly
    Timer {
        running: true
        repeat: false
        interval: 50
        onTriggered: alignMiddle()
    }

    Page {
        id: mainPage

        LinearGradient {
            id: gradient
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(0, parent.height)
            gradient: Gradient {
                GradientStop {position: 0.0; color: "#867f94"}
                GradientStop {position: 1.0; color: "black"}
            }
        }

        Rectangle {
            id: moviePicker
            anchors.centerIn: parent
            width: parent.width
            height: parent.height / 2
            color: "#00000000"
            property int numberOfItems: 7
            ListView {
                id: listView
                x: -parent.width * 0.5
                width: parent.width * 2
                y: 0
                height: parent.height
                property int delegateWidth: width / moviePicker.numberOfItems
                orientation: Qt.Horizontal
                model: movFiles.length * 1
                spacing: 0
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: (width - delegateWidth) / 2
                preferredHighlightEnd: (width + delegateWidth) / 2
                delegate: Item {
                            id: contentItem
                            width: listView.delegateWidth < parent.height ? listView.delegateWidth : parent.height
                            height: listView.delegateWidth < parent.height ? listView.delegateWidth : parent.height
                            ThumbnailButton {
                                filename: menuScene.thumbnailFiles[index % movFiles.length]
                                fgFilename: menuScene.thumbnailFgFiles[index % movFiles.length]
                                spriteFilename: menuScene.thumbnailSpriteFiles[index % movFiles.length]
                                spriteFrames: menuScene.thumbnailSpriteFrames[index % movFiles.length]
                                anchors.fill: parent
                                text: menuScene.dispName[index % movFiles.length]
                                zoomFactor: {
                                    // show the film name only when the item is in the center
                                    var posn = (contentItem.x - contentItem.ListView.view.contentX + contentItem.width * 0.5) / contentItem.ListView.view.width * 2
                                    if (posn > 0.95 && posn < 1.05) return 1
                                    return 0
                                }
                                zoomCenter: [0.5*contentItem.width, 0.5*contentItem.height]
                                visible: (contentItem.x - contentItem.ListView.view.contentX + contentItem.width * 0.5) / contentItem.ListView.view.width * 2 > 0
                                onImgClickSignal: {
                                    if(index === listView.currentIndex) {
                                        loadVideo(movFiles[index % movFiles.length], subsFiles[index % movFiles.length], menuScene.language[index % movFiles.length], widescreen[index % movFiles.length])
                                    } else {
                                        for(var i=index-listView.currentIndex; i>0; i--) {
                                            listView.incrementCurrentIndex()
                                        }
                                        for(i=listView.currentIndex-index; i>0; i--) {
                                            listView.decrementCurrentIndex()
                                        }
                                    }
                                }
                                clipper.transform: [
                                    Rotation {
                                        origin.x: contentItem.width / 2
                                        origin.y: contentItem.height / 2
                                        axis { x: 0; y: 1; z: 0 }
                                        angle: {
                                            var middle = contentItem.ListView.view.contentX - contentItem.x + contentItem.ListView.view.width / 2
                                            var calculated = (middle - contentItem.width / 2) / contentItem.width * 40
                                            if (calculated < -90)
                                                return -90
                                            else if (calculated > 90)
                                                return 90
                                            else
                                                return calculated
                                        }
                                    },
                                    Scale {
                                        origin.x: contentItem.width / 2
                                        origin.y: contentItem.height / 2
                                        xScale: {
                                            // scaled 1 in middle position -> 0 when reaching edges
                                            var scaled = (contentItem.x - contentItem.ListView.view.contentX + contentItem.width * 0.5) / contentItem.ListView.view.width * 2
                                            if (scaled > 1) scaled = 2 - scaled
                                            return Math.max(0, scaled)
                                        }
                                        yScale: xScale
                                    },
                                    Translate {
                                        x: {
                                            var scaled = (contentItem.x - contentItem.ListView.view.contentX + contentItem.width * 0.5) / contentItem.ListView.view.width * 2
                                            scaled = Math.max(0, scaled)
                                            scaled = 1 - scaled
                                            return scaled * scaled * scaled * contentItem.width * 3
                                        }
                                    }
                                ]
                                reflection.transform: [
                                    Rotation {
                                        origin.x: contentItem.width / 2
                                        origin.y: -contentItem.height / 2
                                        axis { x: 0; y: 1; z: 0 }
                                        angle: {
                                            var middle = contentItem.ListView.view.contentX - contentItem.x + contentItem.ListView.view.width / 2
                                            var calculated = (middle - contentItem.width / 2) / contentItem.width * 40
                                            if (calculated < -90)
                                                return -90
                                            else if (calculated > 90)
                                                return 90
                                            else
                                                return calculated
                                        }
                                    },
                                    Scale {
                                        origin.x: contentItem.width / 2
                                        origin.y: contentItem.height / 2
                                        xScale: {
                                            // scaled 1 in middle position -> 0 when reaching edges
                                            var scaled = (contentItem.x - contentItem.ListView.view.contentX + contentItem.width * 0.5) / contentItem.ListView.view.width * 2
                                            if (scaled > 1) scaled = 2 - scaled
                                            return Math.max(0, scaled)
                                        }
                                        yScale: xScale
                                    },
                                    Translate {
                                        x: {
                                            var scaled = (contentItem.x - contentItem.ListView.view.contentX + contentItem.width * 0.5) / contentItem.ListView.view.width * 2
                                            scaled = Math.max(0, scaled)
                                            scaled = 1 - scaled
                                            return scaled * scaled * scaled * contentItem.width * 3
                                        }
                                        y: {
                                            // scaled 1 in middle position -> 0 when reaching edges
                                            var scaled = (contentItem.x - contentItem.ListView.view.contentX + contentItem.width * 0.5) / contentItem.ListView.view.width * 2
                                            if (scaled > 1) scaled = 2 - scaled
                                            return -(1 - Math.max(0, scaled)) * contentItem.height
                                        }
                                    }
                                ]
                            }
                }
                Component.onCompleted: {
                    // Scrolls to middle of list
                    alignMiddle()
                }
            }
        }
    }
}
