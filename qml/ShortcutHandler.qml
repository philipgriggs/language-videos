import Felgo 3.0
import QtQuick 2.5

Item {
    id: shortcutHandler

    Shortcut {
        sequence: 'Escape'
        context: Qt.ApplicationShortcut
        onActivated: {
            showAccents = false
            currentAccent = ""
        }
    }

    Shortcut {
        sequence: 'Meta+A'
        context: Qt.ApplicationShortcut
        onActivated: {
            showAccents = true
            currentAccent = "a"
        }
    }

    Shortcut {
        sequence: 'Meta+E'
        context: Qt.ApplicationShortcut
        onActivated: {
            showAccents = true
            currentAccent = "e"
        }
    }

    Shortcut {
        sequence: 'Meta+I'
        context: Qt.ApplicationShortcut
        onActivated: {
            showAccents = true
            currentAccent = "i"
        }
    }

    Shortcut {
        sequence: 'Meta+U'
        context: Qt.ApplicationShortcut
        onActivated: {
            showAccents = true
            currentAccent = "u"
        }
    }

    Shortcut {
        sequence: 'Meta+C'
        context: Qt.ApplicationShortcut
        onActivated: {
            showAccents = true
            currentAccent = "c"
        }
    }

    Shortcut {
        sequence: 'Meta+1'
        context: Qt.ApplicationShortcut
        onActivated: {
            var cursorIdx = textEdit.cursorPosition
            textEdit.text = insertAtCursor(cursorIdx, textEdit.text, accents[currentAccent][0], false)
            textEdit.cursorPosition = cursorIdx+1
            showAccents = false
            currentAccent = ""
        }
    }

    Shortcut {
        sequence: 'Meta+2'
        context: Qt.ApplicationShortcut
        onActivated: {
            var cursorIdx = textEdit.cursorPosition
            textEdit.text = insertAtCursor(cursorIdx, textEdit.text, accents[currentAccent][0], false)
            textEdit.cursorPosition = cursorIdx+1
            showAccents = false
            currentAccent = ""
        }
    }

    Shortcut {
        sequence: 'Meta+3'
        context: Qt.ApplicationShortcut
        onActivated: {
            var cursorIdx = textEdit.cursorPosition
            textEdit.text = insertAtCursor(cursorIdx, textEdit.text, accents[currentAccent][0], false)
            textEdit.cursorPosition = cursorIdx+1
            showAccents = false
            currentAccent = ""
        }
    }
}
