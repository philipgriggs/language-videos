import Felgo 3.0
import QtQuick 2.0

Item {
    id: item
    property string imgSrc
    property int frames
    property real frameIdx
    property var spriteDuration
    property var easingType
    Behavior on frameIdx {
        NumberAnimation {
            duration: spriteDuration
            easing.type: easingType
        }
    }
    clip: true

    Repeater {
        id: repeater
        model: frames

        Image {
            visible: Math.floor(frameIdx) == index
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: imgSrc + '/' + (index+1) + '.jpg'
        }
    }
}
