import VPlayApps 1.0
import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: subTextEntity
    entityType: "subtext"

    property string str: ""
    property string ans: ""
    property var video: null

    Row{
        anchors.centerIn: parent
        AppText {
            id: text
            width: dp(200)
            color: "white"
            text: str
            horizontalAlignment: Text.AlignRight
        }

        AppTextEdit {
            id: textEdit
            width: dp(200)
            anchors.verticalCenter: text.verticalCenter
            color: "white"
            placeholderText: ans
            Keys.onReturnPressed: {
                focus = false
                video.play()
                video.focus = true
            }
        }
    }
}
