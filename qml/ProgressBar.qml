import VPlayApps 1.0
import QtQuick 2.0

Item {
    id: progressBar
    property int score: 0
    property real value: 0
    property alias scoreText: scoreText
    property color color: "#66bcb7"
    property int duration: 500

    Rectangle {
        color: "transparent"
        width: 54
        height: 54

        Text {
            id: scoreText
            anchors.centerIn: parent
            text: score
            font.pixelSize: 20
            color: "white"
        }

        Row{
            id: circle

            property color circleColor: "transparent"
            property color borderColor: color
            property int borderWidth: 3
            anchors.centerIn: parent
            width: parent.width-10
            height: width

            Item{
                width: parent.width/2
                height: parent.height
                clip: true

                Item{
                    id: part1
                    width: parent.width
                    height: parent.height
                    clip: true
                    rotation: value > 0.5 ? -360 : -180 - 360*value
                    Behavior on rotation {
                        NumberAnimation {
                            id: part1Animation
                            duration: duration
                        }
                    }
                    transformOrigin: Item.Right

                    Rectangle{
                        width: circle.width-(circle.borderWidth*2)
                        height: circle.height-(circle.borderWidth*2)
                        radius: width/2
                        x:circle.borderWidth
                        y:circle.borderWidth
                        color: circle.circleColor
                        border.color: circle.borderColor
                        border.width: circle.borderWidth
                        smooth: true
                    }
                }
            }

            Item{
                width: parent.width/2
                height: parent.height
                clip: true

                Item{
                    id: part2
                    width: parent.width
                    height: parent.height
                    clip: true
                    rotation: value <= 0.5 ? -180 : -360*(value)
                    Behavior on rotation {
                        NumberAnimation {
                            id: part2Animation
                            duration: duration
                        }
                    }
                    transformOrigin: Item.Left

                    Rectangle{
                        width: circle.width-(circle.borderWidth*2)
                        height: circle.height-(circle.borderWidth*2)
                        radius: width/2
                        x: -width/2
                        y: circle.borderWidth
                        color: circle.circleColor
                        border.color: circle.borderColor
                        border.width: circle.borderWidth
                        smooth: true
                    }
                }
            }
        }
    }
}
