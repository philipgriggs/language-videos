import VPlayApps 1.0
import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: subTextEntity
    entityType: "subtext"

    property var str: [""]
    property var ans: [""]
    property var video: null
    property int repeats: 1

    Row{
        anchors.centerIn: parent
        Repeater {
            id: repeater
            model: repeats

            Row {
                AppText {
                    id: text
                    width: dp(200)
                    color: "white"
                    text: str[index]
                    horizontalAlignment: Text.AlignRight
                }

                AppTextEdit {
                    id: textEdit
                    width: dp(200)
                    anchors.verticalCenter: text.verticalCenter
                    color: "white"
                    placeholderText: ans[index]
                    Keys.onReturnPressed: {
                        focus = false
                        video.play()
                        video.focus = true
                    }
                }
            }
        }
    }
}
