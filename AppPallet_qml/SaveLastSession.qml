import Quickshell
import Quickshell.Io
import QtQuick
import "../"

Item {
    id: root

    signal saved()

    function save() {
        proc.running = false
        proc.running = true
    }

    Process {
        id: proc
        command: ["bash", "-c",
            "mkdir -p $HOME/.config/quickshell && " +
            "hyprctl clients -j | jq -r '[.[].class] | unique | .[]' " +
            "> $HOME/.config/quickshell/last_session.txt && echo ok"
        ]
        stdout: SplitParser {
            onRead: data => { if (data.trim() === "ok") root.saved() }
        }
    }
}