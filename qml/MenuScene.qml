import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.0

Scene {
    id: menuScene

    signal sceneChange(string scene)

    Page {
        id: mainPage

        Column {
            anchors.centerIn: parent

            // text to show the current count and button to push the second page
            AppButton {
                text: "Start"
                onClicked: sceneChange("player")
            }
        }
    }
}
