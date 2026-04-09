import Quickshell
import Quickshell.Io
import QtQuick
import "../"

Item {
    id: root
    implicitWidth: 50
    implicitHeight: 50

    signal launched()
    signal noSession()       // geen sessiebestand gevonden

    function launch() {
        launchProc.running = false
        launchProc.running = true
    }

    Process {
        id: launchProc
        // Zoekt per class eerst op StartupWMClass, dan op bestandsnaam
        command: ["bash", "-c", `
            FILE="$HOME/.config/quickshell/last_session.txt"
            [ ! -f "$FILE" ] && echo nosession && exit 0

            while IFS= read -r class; do
                [ -z "$class" ] && continue

                desktop=""

                # 1. Zoek op StartupWMClass=<class>
                for dir in /usr/share/applications \
                           /var/lib/flatpak/exports/share/applications \
                           "$HOME/.local/share/flatpak/exports/share/applications" \
                           "$HOME/.local/share/applications"; do
                    match=$(grep -ril "StartupWMClass=$class" "$dir" 2>/dev/null | head -1)
                    [ -n "$match" ] && desktop="$match" && break
                done

                # 2. Fallback: bestandsnaam (lower-case en origineel)
                if [ -z "$desktop" ]; then
                    lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')
                    for dir in /usr/share/applications \
                               /var/lib/flatpak/exports/share/applications \
                               "$HOME/.local/share/flatpak/exports/share/applications" \
                               "$HOME/.local/share/applications"; do
                        for name in "$lower" "$class"; do
                            f="$dir/$name.desktop"
                            [ -f "$f" ] && desktop="$f" && break 2
                        done
                    done
                fi

                [ -n "$desktop" ] && gtk-launch "$(basename "$desktop")" &

            done < "$FILE"
            echo ok
        `]
        stdout: SplitParser {
            onRead: data => {
                if (data.trim() === "ok")        root.launched()
                if (data.trim() === "nosession") root.noSession()
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Style.radiusGrooteS
        color: Style.popupAchtergrondKleur
        border { color: Style.borderKleur; width: Style.borderSize }

        Text {
            anchors.centerIn: parent
            text: "▶"
            color: Style.textKleur
            font.pixelSize: Style.fontGrootteL
        }

        opacity: ma.containsMouse ? 0.75 : 1.0
        Behavior on opacity { NumberAnimation { duration: 100 } }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.launch()
        }
    }
}