import VPlayApps 1.0
import VPlay 2.0
import QtQuick 2.5

EntityBase {
    id: subTextEntity
    entityType: "subtext"

    property var str: [""]
    property var blank: [""]
    property var ans: [""]
    property var video: null
    property int repeats: 1
    property alias repeater: repeater
    property var rightAns: []
    property int nAnsNeeded: 0

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
                    property bool success: false
                    id: textEdit
                    width: 0
                    anchors.verticalCenter: text.verticalCenter
                    color: success ? "green" : "white"
                    font.pointSize: text.font.pointSize
                    placeholderText: blank[index]
                    Keys.onReturnPressed: {
                        if(textEdit.text.toLowerCase() === ans[index].toLowerCase()) {
                            success = true
                            rightAns[index] = 1
                            woop.play()

                            var nRightAns = 0
                            for(var i = 0; i < rightAns.length; i++) {
                                nRightAns += rightAns[i]
                            }

                            if(nRightAns == nAnsNeeded) {
                                focus = false
                                video.focus = true
                                successRundown.start()
                            }
                        } else {
                            textEdit.text = ""
                        }
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

    Timer {
        id: successRundown
        running: false
        repeat: false
        interval: 1000
        onTriggered: {
            video.play()
        }
    }

    SoundEffectVPlay {
      id: woop
      source: "../assets/Sonic Ring Sound Effect.wav"
      volume: 0.2
    }
}
