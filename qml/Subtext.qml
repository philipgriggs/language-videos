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
    property var incorrectTries: null
    property int nRightAns: 0
    property int nAnsNeeded: 0
    property int maxTries: 0
    property int repeats: 1
    property alias repeater: repeater
    property var video: null
    property var ccButton: null

    Row {
        anchors.centerIn: parent
        visible: ccButton.isOn
        Repeater {
            id: repeater
            model: repeats

            Row {
                property var txtObj: [text, textEdit, textEditText]
                AppText {
                    id: text
                    width: text.paintedWidth
                    color: "white"
                    text: str[index]
                    horizontalAlignment: Text.AlignLeft
                }

                Item {
                    height: textEditText.paintedHeight
                    width: textEditText.width

                    AppTextEdit {
                        property bool success: false
                        property bool fail: false
                        property int textEditIncorrect: incorrectTries[rightAnsIdx][index] != undefined ? incorrectTries[rightAnsIdx][index] : 0
                        id: textEdit
                        width: textEditText.paintedWidth
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        color: success ? "green" : fail ? "red" : "white"
                        font.pointSize: text.font.pointSize
                        placeholderText: blank[index]
                        visible: rightAns[rightAnsIdx][index] === false && incorrectTries[rightAnsIdx][index] < maxTries
                        Keys.onReturnPressed: {
                            if (success === false) {
                                if(textEdit.text.toLowerCase() === ans[index].toLowerCase()) {
                                    incorrectLineAnim.duration = 200 * (maxTries - textEdit.textEditIncorrect)
                                    success = true
                                    rightAns[rightAnsIdx][index] = true
                                    correct.play()

                                    nRightAns++
                                    if(nRightAns === nAnsNeeded) {
                                        focus = false
                                        video.focus = true
                                        //successRundown.start()
                                    } else if (index + 1 < ans.length) {
                                        repeater.itemAt(index+1).txtObj[1].focus = true
                                    }
                                } else {
                                    textEdit.text = ""
                                    incorrect.play()
                                    incorrectTries[rightAnsIdx][index]++
                                    textEdit.textEditIncorrect++
                                    if(incorrectTries[rightAnsIdx][index] >= maxTries) {
                                        fail = true
                                        visible = false
                                    }
                                }
                            }
                        }
                        Keys.onTabPressed: {
                            if (index + 1 < ans.length) {
                                repeater.itemAt(index+1).txtObj[1].focus = true
                            }
                        }
                    }

                    LineItem {
                        id: blankLine
                        visible: !(rightAns[rightAnsIdx][index] === true || incorrectTries[rightAnsIdx][index] >= maxTries) && incorrectLine.opacity > 0
                        color: "white"
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        points: [
                            {"x": 0, "y": 0},
                            {"x": textEditText.paintedWidth, "y": 0}
                        ]
                    }

                    LineItem {
                        id: incorrectLine
                        property real wdth: !(rightAns[rightAnsIdx][index] === true || incorrectTries[rightAnsIdx][index] >= maxTries || textEdit.success) ? textEdit.textEditIncorrect/maxTries * textEditText.paintedWidth : textEditText.paintedWidth
                        opacity: wdth < textEditText.paintedWidth ? 1 : 0
                        color: textEdit.success ? "green" : "red"
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        points: [
                            {"x": 0, "y": 0},
                            {"x": wdth, "y": 0}
                        ]
                        Behavior on wdth {NumberAnimation {id: incorrectLineAnim; duration: 200; easing.type: Easing.InOutSine}}
                        Behavior on opacity {NumberAnimation {duration: 300}}
                    }

                    AppText {
                        id: textEditText
                        anchors.left: parent.left
                        width: textEditText.paintedWidth
                        color: (rightAns[rightAnsIdx][index] === true || incorrectTries[rightAnsIdx][index] >= maxTries || textEdit.fail === true) ? "#bbbbbb" : "#00dddddd"
                        text: ans[index]
                        horizontalAlignment: Text.AlignLeft
                    }
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
