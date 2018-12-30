import VPlayApps 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: main

    property string filename
    property string fgFilename
    property string text
    signal imgClickSignal

    Item {
        clip: true
        anchors.fill: parent

        Image {
            id: thumbnail
            source: filename
            height: parent.height
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
            height: parent.height
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

        OpacityMask {
            visible: false
            anchors.fill: parent
            source: thumbnail
            maskSource: mask
        }

        LinearGradient {
            id: gradient
            anchors.fill: parent
            opacity: 0
            start: Qt.point(0, 0.5*parent.height)
            end: Qt.point(0, parent.height)
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
                    easing.type: Easing.OutSine
                }
            }
        }

        AppText {
            id: appText
            text: main.text
            color: "white"
            opacity: 0
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: dp(5)
            horizontalAlignment: Text.AlignHCenter
            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }
            Behavior on anchors.bottomMargin {
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
            hoverEnabled: true
            onEntered: {
                thumbnail.height = parent.height * 1.05
                thumbnailFg.height = parent.height * 1.12
                appText.opacity = 1
                gradient.opacity = 1
            }
            onExited: {
                thumbnail.height = parent.height
                thumbnailFg.height = parent.height
                appText.opacity = 0
                gradient.opacity = 0
            }
            onClicked: imgClickSignal()
        }
    }
}
