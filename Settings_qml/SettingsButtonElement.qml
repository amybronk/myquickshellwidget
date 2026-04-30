import Quickshell
import QtQuick
import "../"

Rectangle {
    id: settings

    visible: true
    // We hebben hier geen winInstance property meer nodig!

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            // Roep simpelweg de globale functie uit Style.qml aan
            Style.openSettings()
        }
    }
}