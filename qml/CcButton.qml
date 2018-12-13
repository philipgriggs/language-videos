import VPlay 2.0
import QtQuick 2.5
import QtQuick.Controls.Styles 1.0

Item {
    property color bgColorPressed: "#999999"
    property color fgColor: "#cccccc"
    property bool isOn: true

    StyledButton {
        id: button
        anchors.centerIn: parent

        style: ButtonStyle {
            background: Rectangle {
                color: "#00000000"
            }

            label: Text {
                anchors.centerIn: parent
                font.pixelSize: dp(10)
                color: button.pressed ? bgColorPressed : fgColor
                text: "CC"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        onClicked: isOn = !isOn
    }

    LineItem {
        property real xStart: 0.2*width
        property real yStart: 0.8*height
        property real xEnd: isOn ? 0.2*width : 0.8*width
        property real yEnd: isOn ? 0.8*height : 0.2*height

        Behavior on xEnd {animation: transition}
        Behavior on yEnd {animation: transition}

        anchors.fill: parent
        color: fgColor
        points: [
          {"x": xStart, "y": yStart},
          {"x": xEnd, "y": yEnd}
        ]
    }

    NumberAnimation {
        id: transition
        easing {
            type: Easing.Linear
        }
    }
}
