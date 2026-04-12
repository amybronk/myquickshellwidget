import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Hyprland

//OpenAppButton.qml

Item {
    id: openAppButton

    required property var client

    property string appClass: client.wm_class
    property string appTitle: client.title
    property string iconName: ""

    Process {
        running: appClass !== ""
        command: ["bash", "-c",
            "for dir in /usr/share/applications " +
            "/var/lib/flatpak/exports/share/applications " +
            "$HOME/.local/share/flatpak/exports/share/applications " +
            "$HOME/.local/share/applications; do " +
                "f=$(grep -ril 'StartupWMClass=" + appClass + "' \"$dir\" 2>/dev/null | head -1); " +
                "[ -z \"$f\" ] && f=\"$dir/" + appClass.toLowerCase() + ".desktop\"; " +
                "[ -f \"$f\" ] && grep '^Icon=' \"$f\" | head -1 | cut -d'=' -f2 && break; " +
            "done"
        ]
        stdout: SplitParser {
            onRead: data => { openAppButton.iconName = data.trim() }
        }
    }

    Rectangle {
        id: iconRect
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: Style.uiMarginsG
        }
        width: 50
        height: 50
        radius: Style.radiusGrooteS
        color: Style.accentKleur

        Rectangle {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: -6
            }
            width: parent.width * 0.4
            height: 3
            radius: 2
            color: Style.textKleur
            visible: Hyprland.focusedClient?.address === openAppButton.client.address
        }

        Image {
            id: iconImage
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: parent.height * 0.6
            source: iconName !== "" ? "image://icon/" + iconName : ""
            visible: status === Image.Ready
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
        }

        Image {
            id: fallbackImage
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: parent.height * 0.6
            source: iconImage.status === Image.Error && iconName !== ""
                ? "/usr/share/pixmaps/" + iconName + ".png"
                : ""
            visible: status === Image.Ready
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
        }

        Text {
            anchors.centerIn: parent
            text: appClass.charAt(0).toUpperCase()
            color: Style.textKleur
            font.pixelSize: Style.fontGrootteL
            visible: iconImage.status !== Image.Ready && fallbackImage.status !== Image.Ready
        }

        opacity: mouseArea.containsMouse ? 0.75 : 1.0
        Behavior on opacity { NumberAnimation { duration: 100 } }
    }

    Text {
        anchors {
            top: iconRect.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: Style.uiMarginsM
        }
        height: 12
        text: appTitle !== "" ? appTitle : appClass
        color: Style.textKleur
        font.pixelSize: Style.fontGrootteM
        elide: Text.ElideRight
        width: parent.width - Style.uiMarginsM * 2
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Hyprland.dispatch("workspace " + openAppButton.client.workspace.id)
            Hyprland.dispatch("focuswindow address:" + openAppButton.client.address)
        }
    }
}