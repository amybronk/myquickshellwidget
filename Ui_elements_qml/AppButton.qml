import Quickshell
import Quickshell.Io
import QtQuick
import "../"

Item {
    id: appLauncherButton

    property var appData: ""
    property string desktopName: (typeof appData === "string" ? appData : appData.desktop) + ".desktop"
    property string action: typeof appData === "object" && appData.action !== undefined ? appData.action : ""

    property string iconName: ""
    property string applicationName: ""

    Process {
        id: iconProcess
        command: ["bash", "-c",
            "sed '/^\\[Desktop Action/,$ d' /usr/share/applications/" + desktopName +
            " | grep '^Icon=' | cut -d'=' -f2 | head -1"
        ]
        running: true
        stdout: SplitParser {
            onRead: data => { appLauncherButton.iconName = data.trim() }
        }
    }

    Process {
        id: nameProcess
        command: ["bash", "-c", action !== ""
            ? "sed -n '/^\\[Desktop Action " + action + "\\]/,/^\\[/p' /usr/share/applications/" + desktopName + " | grep '^Name=' | head -1 | cut -d'=' -f2"
            : "sed '/^\\[Desktop Action/,$ d' /usr/share/applications/" + desktopName + " | grep '^Name=' | head -1 | cut -d'=' -f2"
        ]
        running: true
        stdout: SplitParser {
            onRead: data => { appLauncherButton.applicationName = data.trim() }
        }
    }

    Process {
        id: launchProcess
        command: ["bash", "-c", action !== ""
            ? "sed -n '/^\\[Desktop Action " + action + "\\]/,/^\\[/p' /usr/share/applications/" + desktopName + " | grep '^Exec=' | head -1 | sed 's/^Exec=//' | sed 's/ %.*//' | bash"
            : "sed '/^\\[Desktop Action/,$ d' /usr/share/applications/" + desktopName + " | grep '^Exec=' | head -1 | sed 's/^Exec=//' | sed 's/ %.*//' | bash"
        ]
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
            text: applicationName.charAt(0).toUpperCase()
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
        text: applicationName
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
        onClicked: launchProcess.running = true
    }
}