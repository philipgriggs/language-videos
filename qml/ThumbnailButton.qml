import VPlayApps 1.0
import QtQuick 2.10
import QtGraphicalEffects 1.0

Item {
    id: main

    property string filename
    property string fgFilename
    property string spriteFilename
    property int spriteFrames
    property string text
    property real zoomFactor
    property real zoomMax: 0.05
    property real zoomMaxFg: 0.12
    property var zoomCenter
    property alias clipper: clipper
    property alias reflection: reflection
    signal imgClickSignal

    onZoomFactorChanged: {
        if (zoomFactor === 1) {
            customSprite.frameIdx = spriteFrames - 1
        } else if (zoomFactor === 0) {
            customSprite.frameIdx = 0
        }
    }

    Item {
        id: clipper
        clip: true
        anchors.fill: parent
        // apply roundned corners
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }

        Rectangle {
            id: mask
            opacity: 0
            width: parent.width
            height: parent.height
            radius: 0.05*height
        }

        Image {
            id: thumbnail
            source: "../assets/thumbnails/" + filename
            height: parent.height * (1 + zoomFactor*zoomMax)
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            visible: true
            Behavior on height {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutSine
                }
            }
        }

        CustomSprite {
            id: customSprite
            visible: spriteFilename != ''
            anchors.centerIn: parent
            height: parent.height * (1 + zoomFactor*zoomMax)
            width: height
            imgSrc: "../assets/thumbnails/" + spriteFilename
            frames: spriteFrames
            spriteDuration: 500
            easingType: Easing.Linear
            Behavior on height {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.Linear
                }
            }
        }

        Image {
            id: thumbnailFg
            source: "../assets/thumbnails/" + fgFilename
            height: parent.height * (1 + zoomFactor*zoomMaxFg)
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: (height - parent.height)/parent.height * (parent.width/2 - main.zoomCenter[0])
            anchors.verticalCenterOffset: (height - parent.height)/parent.height * (parent.height/2 - main.zoomCenter[1])
            Behavior on height {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutSine
                }
            }
        }

        LinearGradient {
            id: gradient
            anchors.fill: parent
            opacity: zoomFactor
            start: Qt.point(0, 0.5*height)
            end: Qt.point(0, height)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00000000" }
                GradientStop { position: 1.0; color: "black" }
            }
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: mask
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutSine
                }
            }
        }

        AppText {
            id: appText
            text: main.text
            color: "white"
            opacity: zoomFactor
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: dp(5)
            horizontalAlignment: Text.AlignHCenter
            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutSine
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: imgClickSignal()
        }
    }

    Item {
        id: reflection
        width: parent.width
        height: parent.height
        anchors.top: parent.bottom
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: reflectionMask
        }

        Rectangle {
            id: reflectionMask
            visible: false
            width: parent.width
            height: parent.height
            radius: 0.05*height
        }

        LinearGradient {
            id: reflectionGradient
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(0, 2*height)
            visible: false
            gradient: Gradient {
                GradientStop { position: 1.0; color: "#44000000" }
                GradientStop { position: 0.0; color: "#00000000" }
            }
        }

        Image {
            id: thumbnailReflection
            source: "../assets/thumbnails/" + filename
            height: parent.height * (1 + zoomFactor*zoomMax)
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            visible: false
            Behavior on height {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutSine
                }
            }
        }

        OpacityMask {
            anchors.fill: thumbnailReflection
            source: thumbnailReflection
            maskSource: reflectionGradient
            visible: true
            transform: Rotation { origin.x: 0; origin.y: height/2; axis { x: 1; y: 0; z: 0 } angle: 180 }
        }
    }
}
