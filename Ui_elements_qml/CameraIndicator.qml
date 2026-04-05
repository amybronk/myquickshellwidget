import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../"

Rectangle {
    id: cameraIndicator

    property bool cameraActive: false

    radius: Style.radiusGrooteM
    color: Style.achtergrondKleur

    // Gebruik alleen opacity, niet visible + opacity tegelijk
    width: cameraActive ? root.height : 0
    visible: opacity > 0
    opacity: cameraActive ? 1 : 0

    border {
        color: Style.borderKleur
        width: Style.borderSize
    }

    Behavior on opacity {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: cameraCheck.running = true
    }

    Process {
        id: cameraCheck
        command: ["bash", "-c", "find /proc/*/fd -lname '/dev/video*' 2>/dev/null | wc -l"]

        stdout: SplitParser {
            onRead: function(data) {
                cameraIndicator.cameraActive = parseInt(data.trim()) > 0
            }
        }

        onRunningChanged: {
            if (!running) {
            }
        }
    }

    Rectangle {
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        width: 12
        height: 12
        radius: width / 2
        color: "#ff0000"

        SequentialAnimation on opacity {
            running: cameraIndicator.cameraActive
            loops: Animation.Infinite
            NumberAnimation { to: 0.2; duration: 800; easing.type: Easing.InOutSine }
            NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutSine }
        }
    }
  
}