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
        id: line
        property real xStart: 0.25*parent.width
        property real yStart: 0.75*parent.height
        property real xEnd: isOn ? 0.25*parent.width : 0.75*parent.width
        property real yEnd: isOn ? 0.75*parent.height : 0.25*parent.height

        Behavior on xEnd {NumberAnimation {duration: 200; easing.type: Easing.InOutSine}}
        Behavior on yEnd {NumberAnimation {duration: 200; easing.type: Easing.InOutSine}}

        anchors.fill: parent
        color: fgColor
        lineWidth: dp(1.5)
        points: [
          {"x": xStart, "y": yStart},
          {"x": xEnd, "y": yEnd}
        ]
    }

    LineItem {
        property real offset: line.lineWidth/2
        property real xStart: 0.25*parent.width + offset
        property real yStart: 0.75*parent.height + offset
        property real xEnd: isOn ? 0.25*parent.width + offset : 0.75*parent.width + offset
        property real yEnd: isOn ? 0.75*parent.height + offset : 0.25*parent.height + offset

        Behavior on xEnd {NumberAnimation {duration: 200; easing.type: Easing.InOutSine}}
        Behavior on yEnd {NumberAnimation {duration: 200; easing.type: Easing.InOutSine}}

        anchors.fill: parent
        color: "black"
        lineWidth: line.lineWidth
        points: [
          {"x": xStart, "y": yStart},
          {"x": xEnd, "y": yEnd}
        ]
    }
}
