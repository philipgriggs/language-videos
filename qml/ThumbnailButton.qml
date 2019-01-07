import VPlayApps 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: main

    property string filename
    property string fgFilename
    property string text
    property real zoomFactor
    property real zoomMax: 0.05
    property real zoomMaxFg: 0.12
    property var zoomCenter
    property alias clipper: clipper
    property alias reflection: reflection
    signal imgClickSignal

    Item {
        id: clipper
        clip: true
        anchors.fill: parent

        Image {
            id: thumbnail
            source: filename
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

        Image {
            id: thumbnailFg
            source: fgFilename
            height: parent.height * (1 + zoomFactor*zoomMaxFg)
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: (height - parent.height)/parent.height * (parent.width/2 - main.zoomCenter[0])
            anchors.verticalCenterOffset: (height - parent.height)/parent.height * (parent.height/2 - main.zoomCenter[1])

            visible: true
            Behavior on height {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutSine
                }
            }
        }

        OpacityMask {
            visible: false
            anchors.fill: parent
            source: thumbnail
            maskSource: mask
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

        Rectangle {
            id: mask
            anchors.fill: parent
            radius: 0.05*height
            visible: false
        }

        MouseArea {
            anchors.fill: parent
            onClicked: imgClickSignal()
        }
    }

    Item {
        id: reflection
        clip: true
        width: parent.width
        height: parent.height
        anchors.top: parent.bottom

        Image {
            id: thumbnailReflection
            source: filename
            height: parent.height * (1 + zoomFactor*zoomMax)
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            visible: true
            opacity: 0.1
            Behavior on height {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutSine
                }
            }
            transform: Rotation { origin.x: 0; origin.y: height/2; axis { x: 1; y: 0; z: 0 } angle: 180 }
        }

        LinearGradient {
            visible: false
            id: reflectionMask
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(0, height/1.5)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#88000000" }
                GradientStop { position: 1.0; color: "#00000000" }
            }
        }

        OpacityMask {
            visible: false
            anchors.fill: parent
            source: thumbnailReflection
            maskSource: reflectionMask
        }
    }
}
