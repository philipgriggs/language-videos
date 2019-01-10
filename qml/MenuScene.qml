import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.5
import QtGraphicalEffects 1.0

Scene {
    id: menuScene

    signal sceneChange(string scene)
    signal loadVideo(string movFileName, string subsFileName)

    property var dispName: ['La La Land', 'Belle et La Bete', 'Johnny English', 'Vice Versa']
    property var movFiles: ['La La Land 1.m4v', 'Belle et La Bete.mp4', 'Johnny English - Contre attaque.mp4', 'Vice Versa 1.mp4']
    property var subsFiles: ['LaLaLand.json', 'BelleEtLaBete.json', 'JohnnyEnglish.json', 'ViceVersa.json']
    property var thumbnailFiles: ['LaLaLand.png', 'BelleEtLaBete.png', 'JohnnyEnglish.png', 'ViceVersa.png']
    property var thumbnailFgFiles: ['LaLaLandFg.png', 'BelleEtLaBeteFg.png', 'JohnnyEnglishFg.png', 'ViceVersaFg.png']
    property var zoomCentre: [[1/2.2, 1/2.5], [1/2, 1/2], [1/2.5, 1/1.85], [1/2, 1/1.85]]

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
            id: timePicker
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
                property int delegateWidth: width / timePicker.numberOfItems
                orientation: Qt.Horizontal
                model: movFiles.length * 10
                spacing: 0
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: (width - delegateWidth) / 2
                preferredHighlightEnd: (width + delegateWidth) / 2
                delegate: Item {
                            id: contentItem
                            width: listView.delegateWidth < parent.height ? listView.delegateWidth : parent.height
                            height: listView.delegateWidth < parent.height ? listView.delegateWidth : parent.height
                            ThumbnailButton {
                                filename: "../assets/thumbnails/" + menuScene.thumbnailFiles[index % movFiles.length]
                                fgFilename: "../assets/thumbnails/" + menuScene.thumbnailFgFiles[index % movFiles.length]
                                anchors.fill: parent
                                text: menuScene.dispName[index % movFiles.length]
                                zoomFactor: {
                                    // show the film name only when the item is in the center
                                    var posn = (contentItem.x - contentItem.ListView.view.contentX + contentItem.width * 0.5) / contentItem.ListView.view.width * 2
                                    if (posn > 0.95 && posn < 1.05) return 1
                                    return 0
                                }
                                zoomCenter: [menuScene.zoomCentre[index % movFiles.length][0]*contentItem.width, menuScene.zoomCentre[index % movFiles.length][1]*contentItem.height]
                                visible: (contentItem.x - contentItem.ListView.view.contentX + contentItem.width * 0.5) / contentItem.ListView.view.width * 2 > 0
                                onImgClickSignal: {
                                    if(index === listView.currentIndex) {
                                        loadVideo(movFiles[index % movFiles.length], subsFiles[index % movFiles.length])
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
