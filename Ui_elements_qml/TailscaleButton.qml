import Quickshell
import Quickshell.Io
import QtQuick
import "../"

Rectangle {
    id: tailscaleButton

    radius: Style.radiusGrooteM
    width: tailscaleAanwezig ? root.height : 0
    visible: tailscaleAanwezig
    color: tailscaleActief ? "#5e81ac" : Style.achtergrondKleur

    border {
        color: Style.borderKleur
        width: Style.borderSize
    }

    property bool tailscaleActief: false
    property bool tailscaleAanwezig: false
    property string buffer: ""

    // Check of tailscale geïnstalleerd is
    Process {
        id: checkInstalled
        command: ["which", "tailscale"]

        onExited: (code) => {
            tailscaleButton.tailscaleAanwezig = (code === 0)
            if (tailscaleButton.tailscaleAanwezig) {
                statusCheck.running = true
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: tailscaleButton.tailscaleActief ? "🔒" : "🔓"
        font.pixelSize: parent.height * 0.5
        visible: tailscaleButton.tailscaleAanwezig
    }

    Process {
        id: statusCheck
        command: ["sudo", "tailscale", "status", "--json"]

        stdout: SplitParser {
            onRead: data => {
                tailscaleButton.buffer += data
            }
        }

        onExited: {
            try {
                const json = JSON.parse(tailscaleButton.buffer)
                tailscaleButton.tailscaleActief = json.BackendState === "Running"
            } catch (e) {}
            tailscaleButton.buffer = ""
            statusCheck.running = false
        }
    }

    Process {
        id: tailscaleUp
        command: ["sudo", "tailscale", "up"]
        onExited: {
            tailscaleButton.buffer = ""
            statusCheck.running = false
            statusCheck.running = true
        }
    }

    Process {
        id: tailscaleDown
        command: ["sudo", "tailscale", "down"]
        onExited: {
            tailscaleButton.buffer = ""
            statusCheck.running = false
            statusCheck.running = true
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (tailscaleButton.tailscaleActief) {
                tailscaleDown.running = true
            } else {
                tailscaleUp.running = true
            }
        }
    }

    Timer {
        interval: 10000
        running: tailscaleButton.tailscaleAanwezig
        repeat: true
        onTriggered: statusCheck.running = true
    }

    Component.onCompleted: checkInstalled.running = true
}