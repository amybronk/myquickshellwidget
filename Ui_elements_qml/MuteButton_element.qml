import QtQuick
import Quickshell.Io
import "../"

Rectangle {
    id: root
    implicitWidth: 40
    implicitHeight: 40
    radius: Style.radiusGrooteS
    color: mouseArea.containsMouse ? Qt.rgba(255,255,255,0.1) : "transparent"

    property bool isMuted: false

    // Lees mute status
    Process {
        id: statusCheck
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                root.isMuted = data.includes("[MUTED]")
            }
        }
    }

    // Toggle mute
    Process {
        id: muteToggle
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]

        onExited: statusCheck.running = true
    }

    // Hercheck elke 2 seconden
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: statusCheck.running = true
    }

    Text {
        anchors.centerIn: parent
        text: root.isMuted ? "󰝟" : "󰕾"
        font.pixelSize: 22
        color: root.isMuted ? "#ff5555" : Style.textKleur
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: muteToggle.running = true
    }
}