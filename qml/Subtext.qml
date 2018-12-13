import VPlayApps 1.0
import VPlay 2.0
import QtQuick 2.5

EntityBase {
    id: subTextEntity
    entityType: "subtext"

    property var str: [""]
    property var ans: [""]
    property var video: null
    property int repeats: 1
    property alias repeater: repeater

    Row{
        anchors.centerIn: parent
        Repeater {
            id: repeater
            model: repeats

            Row {
                property var txtObj: [text, textEdit, textEditText]
                AppText {
                    id: text
                    width: 0
                    color: "white"
                    text: str[index]
                    horizontalAlignment: Text.AlignLeft
                }

                AppTextEdit {
                    id: textEdit
                    width: 0
                    anchors.verticalCenter: text.verticalCenter
                    color: "white"
                    placeholderText: ans[index]
                    Keys.onReturnPressed: {
                        focus = false
                        video.play()
                        video.focus = true
                    }
                }

                AppText {
                    id: textEditText
                    width: 0
                    visible: false
                    color: "white"
                    text: ans[index]
                    horizontalAlignment: Text.AlignLeft
                }
            }
        }
    }
}
