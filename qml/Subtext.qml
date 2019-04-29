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
    property var scoreChange
    property string grey: "#eeeeee"
    property string language: "spanish"
    property int currentAccent: -1
    property var accents: {
        "french": [
                    {
                        "chr": "a",
                        "chars": ["à"],
                        "key": Qt.Key_A,
                    },
                    {
                        "chr": "e",
                        "chars": ["é", "è", "ê"],
                        "key": Qt.Key_E,
                    },
                    {
                        "chr": "i",
                        "chars": ["î"],
                        "key": Qt.Key_I,
                    },
                    {
                        "chr": "o",
                        "chars": ["ô"],
                        "key": Qt.Key_O,
                    },
                    {
                        "chr": "u",
                        "chars": ["û"],
                        "key": Qt.Key_U
                    },
                    {
                        "chr": "c",
                        "chars": ["ç"],
                        "key": Qt.Key_C,
                    },
                ],
                "spanish": [
                    {
                        "chr": "a",
                        "chars": ["á"],
                        "key": Qt.Key_A,
                    },
                    {
                        "chr": "e",
                        "chars": ["é"],
                        "key": Qt.Key_E,
                    },
                    {
                        "chr": "i",
                        "chars": ["í"],
                        "key": Qt.Key_I,
                    },
                    {
                        "chr": "o",
                        "chars": ["ó"],
                        "key": Qt.Key_O,
                    },
                    {
                        "chr": "u",
                        "chars": ["ú"],
                        "key": Qt.Key_U
                    },
                    {
                        "chr": "n",
                        "chars": ["ñ"],
                        "key": Qt.Key_N,
                    },
                ]
    }

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
                    property string partialMatch: ""

                    ShortcutHandler{}

                    AppTextEdit {
                        id: textEdit
                        property bool success: false
                        property bool fail: false
                        property int textEditIncorrect: incorrectTries[rightAnsIdx][index] !== undefined ? incorrectTries[rightAnsIdx][index] : 0
                        width: textEditText.paintedWidth
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        color: success ? "green" : fail ? "red" : "white"
                        font.pixelSize: text.font.pixelSize
                        placeholderText: blank[index]
                        visible: rightAns[rightAnsIdx][index] === false && incorrectTries[rightAnsIdx][index] < maxTries

                        Keys.onPressed: {
                            // ignore the control key
                            if(event.key == Qt.Key_Meta) {
                                event.accepted = true
                                return
                            }

                            // ignore repeats of accent keys: 'a', 'e', etc
                            if(event.isAutoRepeat) {
                                var accept = false
                                forEachAccent(function(idx, chr, key, list) {
                                    if(event.key == key) {
                                        accept = true
                                    }
                                })
                                event.accepted = accept
                                return
                            }

                            // if the accent pop up is showing, then intercept the number keys and replace the text with the accent
                            if(accentsBox.showAccents) {
                                var currAccent = accents[language][currentAccent]
                                if(currAccent.chr !== "" && event.key >= Qt.Key_1 && event.key <= Qt.Key_1 + currAccent.chars.length) {
                                    var cursorIdx = textEdit.cursorPosition
                                    textEdit.text = insertAtCursor(cursorIdx, textEdit.text, currAccent.chars[event.key-Qt.Key_1], true)
                                    textEdit.cursorPosition = cursorIdx

                                    accentsBox.showAccents = false
                                    currentAccent = -1
                                    event.accepted = true
                                    return
                                }
                            }

                            // check if the key press was an accent character and if so,
                            // start a timer to count how long it's held down for
                            currentAccent = -1
                            accentsBox.showAccents = false
                            forEachAccent(function(idx, chr, key, list) {
                                if(key == event.key) {
                                    currentAccent = idx
                                    autoRepeatThreshold.start()
                                    return
                                }
                            })
                        }

                        Keys.onReleased: {
                            autoRepeatThreshold.stop()
                            parent.partialMatch = getPartialMatch(textEdit.text, ans[index])
                            if(parent.partialMatch.length === ans[index].length) {
                                success = true
                                handleSuccess()
                            }
                        }

                        Keys.onReturnPressed: {
                            if (success === false) {
                                if(textEdit.text.toLowerCase() === ans[index].toLowerCase()) {
                                    handleSuccess()
                                } else {
                                    textEdit.text = ""
                                    incorrect.play()
                                    incorrectTries[rightAnsIdx][index]++
                                    textEdit.textEditIncorrect++
                                    if(incorrectTries[rightAnsIdx][index] >= maxTries) {
                                        fail = true
                                        visible = false
                                        scoreChange()
                                    }
                                }
                            }
                        }

                        Keys.onTabPressed: {
                            repeater.itemAt((index+1)%ans.length).txtObj[1].focus = true
                        }

                        AccentsPopup {
                            id: accentsBox
                            x: -width/2 + textEdit.cursorRectangle.x
                            anchors.bottom: parent.top
                            color: "#ffffff"
                        }

                        Timer {
                            id: autoRepeatThreshold
                            running: false
                            repeat: false
                            interval: 300
                            onTriggered: {
                                accentsBox.showAccents = true
                            }
                        }

                        function handleSuccess() {
                            incorrectLineAnim.duration = 200 * (maxTries - textEdit.textEditIncorrect)
                            success = true
                            rightAns[rightAnsIdx][index] = true
                            correct.play()
                            scoreChange()

                            nRightAns++
                            if(nRightAns === nAnsNeeded) {
                                focus = false
                                video.focus = true
                                //successRundown.start()
                            } else if (index + 1 < ans.length) {
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

                    AppText {
                        id: textEditTextGreen
                        anchors.left: textEditText.left
                        width: textEditText.paintedWidth
                        color: "green"
                        text: parent.partialMatch
                        horizontalAlignment: Text.AlignLeft
                    }
                }
            }
        }
    }

    function getPartialMatch(currAns, correctAns) {
        var endIdx = 1
        var match = ""
        while (endIdx <= correctAns.length && currAns.substring(0, endIdx).toLowerCase() === correctAns.substring(0, endIdx).toLowerCase()) {
            match = currAns.substring(0, endIdx)
            endIdx++
        }
        return match
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

    function forEachAccent(fn) {
        var idx = 0
        accents[language].forEach(function(item) {
            fn(idx, item.chr, item.key, item.list)
            idx++
        })
    }

    // insert the character at the given cursor index
    function insertAtCursor(cursorIdx, text, chr, deleteCurr) {
        var keepIdx = cursorIdx
        if(deleteCurr) {
            keepIdx = cursorIdx-1
        }
        return text.slice(0, keepIdx) + chr + text.slice(cursorIdx)
    }
}
