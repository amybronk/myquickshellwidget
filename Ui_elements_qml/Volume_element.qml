import QtQuick
import Quickshell.Io
import "../"

// writen by claud sonnet 4.6

Rectangle {
    id: root

    property real volume: 0.5
    
    implicitWidth: Style.sliderThickness
    implicitHeight: 200 
    
    radius: Style.radiusGrooteS
    color: Qt.darker(Style.borderKleur, 1.2)

    Process {
        id: volumeCheck
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                let match = data.match(/Volume:\s*([0-9.]+)/)
                if (match) root.volume = Math.min(parseFloat(match[1]), 1.0)
            }
        }
    }

    Process {
        id: volumeSet
        property real targetVolume: 0
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", targetVolume.toFixed(2)]
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: volumeCheck.running = true
    }

    Rectangle {
        id: fill
        width: parent.width
        radius: parent.radius
        color: Style.accentKleur
        anchors.bottom: parent.bottom
        
        height: root.volume * root.height

        Behavior on height {
            enabled: !mouseArea.pressed
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        
        function updateVolume(mouseY) {
            let restrictedY = Math.max(0, Math.min(mouseY, root.height))
            let newVol = 1.0 - (restrictedY / root.height)
            root.volume = newVol
            volumeSet.targetVolume = newVol
            volumeSet.running = true
        }

        onPressed: (mouse) => updateVolume(mouse.y)
        onPositionChanged: (mouse) => { if (pressed) updateVolume(mouse.y) }
    }
}