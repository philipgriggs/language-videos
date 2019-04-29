import Felgo 3.0
import QtQuick 2.5

Rectangle {
    property bool showAccents: false
    visible: showAccents
    color: grey
    width: accentText.width + dp(20)
    height: dp(40)
    radius: dp(2)
    Grid {
        id: accentText
        columns: currentAccent === -1 ? 0 : accents[language][currentAccent].chars.length
        anchors.horizontalCenter: parent.horizontalCenter
        columnSpacing: dp(10)
        Repeater {
            model: currentAccent === -1 ? [] : accents[language][currentAccent].chars
            AppText {
                text: currentAccent === "" ? [] : accents[language][currentAccent].chars[index]
                font.pointSize: dp(15)
            }
        }
        Repeater {
            model: currentAccent === -1 ? [] : accents[language][currentAccent].chars
            AppText {
                text: index + 1
                color: "#777777"
                font.pointSize: dp(15)
            }
        }
    }

    PolygonItem {
        id: triangle
        anchors.top: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: grey
        fill: true
        vertices: [
            Qt.point(0, 0),
            Qt.point(20, 0),
            Qt.point(10, 10)
        ]
    }
}
