import VPlayApps 1.0
import VPlay 2.0
import QtQuick 2.5

EntityBase {
    id: subTextEntity
    entityType: "subtext"

    property var str: [""]
    property var blank: [""]
    property var ans: [""]
    property var rightAns: null
    property int rightAnsIdx: 0
    property int nRightAns: 0
    property int nAnsNeeded: 0
    property var video: null
    property int repeats: 1
    property alias repeater: repeater
    property var ccButton: null

    Row{
        anchors.centerIn: parent
        visible: ccButton.isOn
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

                Item {
                    width: textEditText.width
                    anchors.left: text.right
                    anchors.bottom: text.bottom

                    AppTextEdit {
                        property bool success: false
                        id: textEdit
                        width: textEditText.paintedWidth
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        color: success ? "green" : "white"
                        font.pointSize: text.font.pointSize
                        placeholderText: blank[index]
                        visible: rightAns[rightAnsIdx][index] === false
                        Keys.onReturnPressed: {
                            if(textEdit.text.toLowerCase() === ans[index].toLowerCase()) {
                                success = true
                                rightAns[rightAnsIdx][index] = true
    //                            subTextEntity.rightAnsChanged()

                                correct.play()

                                nRightAns += 1
                                if(nRightAns == nAnsNeeded) {
                                    focus = false
                                    video.focus = true
                                    // successRundown.start()
                                } else if (index + 1 < ans.length) {
                                    repeater.itemAt(index+1).txtObj[1].focus = true
                                }
                            } else {
                                textEdit.text = ""
                                incorrect.play()
                            }
                        }
                        Keys.onTabPressed: {
                            if (index + 1 < ans.length) {
                                repeater.itemAt(index+1).txtObj[1].focus = true
                            }
                        }
                    }

                    LineItem {
                        color: "white"
                        anchors.left: parent.left
                        points: [
                          {"x": 0, "y": 0},
                          {"x": textEditText.paintedWidth, "y": 0}
                        ]
                    }
                }

                AppText {
                    id: textEditText
                    width: 0
                    color: rightAns[rightAnsIdx][index] === true ? "#dddddd" : "#33dddddd"
                    text: ans[index]
                    horizontalAlignment: Text.AlignLeft
                    anchors.left: text.right
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
            dispCurrSub()
            skipBack()
        }
    }

    SoundEffectVPlay {
      id: correct
      source: "../assets/snd/correct.wav"
      volume: 0.2
    }

    SoundEffectVPlay {
      id: incorrect
      source: "../assets/snd/incorrect.wav"
      volume: 0.2
    }
}
