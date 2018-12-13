import QtQuick 2.1

 Rectangle {
     id: root
     color: "transparent"
     radius: dp(6)
     property alias value: grip.value
     property color fillColor: "#14aaff"
     property real gripSize: dp(10)
     property real increment: 0.1
     property bool enabled: true

     Rectangle {
         id: slider
         anchors {
             left: parent.left
             right: parent.right
             verticalCenter: parent.verticalCenter
         }
         height: dp(7)
         color: "transparent"

         // background
         Rectangle{
             id: background
             height: parent.height - dp(2)
             width: parent.width
             anchors.left: parent.left
             color: "#333333"
             radius: dp(6)
             border.width: 1
             border.color: Qt.darker(color, 1.3)
             opacity: 0.8
             MouseArea {
                 enabled: root.enabled
                 anchors.fill: parent
                 onClicked: {
                     value = mouseX / slider.width
                     video.seek(value * video.duration)
                 }
             }
         }

         // currentProgress
         Rectangle {
             id: currProgress
             height: parent.height - dp(2)
             anchors.left: parent.left
             anchors.right: grip.horizontalCenter
             color: "#555555"
             radius: dp(6)
             border.width: 1
             border.color: Qt.darker(color, 1.3)
             opacity: 0.8
             MouseArea {
                 enabled: root.enabled
                 anchors.fill: parent
                 onClicked: {
                     value = mouseX / slider.width
                     video.seek(value * video.duration)
                 }
             }
         }

         // `grip` circle
         Rectangle {
             id: grip
             property real value: 0
             x: (value * parent.width) - width/2
             anchors.verticalCenter: background.verticalCenter
             width: Math.max(dp(48), root.gripSize)
             height: width
             radius: width/2
             color: "transparent"

             Rectangle{
                 anchors.centerIn: parent
                 width: root.gripSize
                 height: root.gripSize
                 radius: root.gripSize / 2
                 color: "#666666"
                 border.width: 1
                 border.color: Qt.darker(color, 1.3)
             }

             MouseArea {
                 id: mouseArea
                 enabled: root.enabled
                 anchors.fill:  parent
                 drag {
                     target: grip
                     axis: Drag.XAxis
                     minimumX: -parent.width/2
                     maximumX: root.width - parent.width/2
                 }
                 onPositionChanged:  {
                     if (drag.active)
                         updatePosition()
                 }
                 onReleased: {
                     updatePosition()
                 }
                 function updatePosition() {
                     value = (grip.x + grip.width/2) / slider.width
                     video.seek(value * video.duration)
                 }
             }
         }

     }
 }
