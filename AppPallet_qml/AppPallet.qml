import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../"


PopupWindow {
    id: appletWindow
    visible: true
    color: "transparent"

    property var recentIds: []

    implicitHeight: 445
    implicitWidth: 575

    anchor {
        window: barWindow
        rect: Qt.rect(
            barWindow.apppalletX + barWindow.apppalletWidth / 2 - implicitWidth / 2,
            barWindow.height,
            implicitWidth,
            implicitHeight
        )
    }

    Component.onCompleted: {
        searchInput.forceActiveFocus()
    }

    HoverHandler {
        id: popupHover
        onHoveredChanged: {
            if (hovered) {
                closeTimer.stop()
            } else {
                closeTimer.start()
            }
        }
    }

    Timer {
        id: closeTimer
        interval: Style.exitTimer
        onTriggered: applet.active = false
    }

    function stopSluiten() { closeTimer.stop() }
    function startSluiten() { closeTimer.start() }

    // --- Recente apps bijhouden ---

    Connections {
        target: ToplevelManager

        function onToplevelCreated(toplevel) {
            var appId = toplevel.appId
            if (!appId || appId === "") return

            var list = appletWindow.recentIds.filter(id => id !== appId)
            list.unshift(appId)
            appletWindow.recentIds = list.slice(0, 16)
        }
    }

    

    // --- UI ---
    Rectangle {
        id: searchContainer
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        focus: true
        Component.onCompleted: searchInput.forceActiveFocus()

        MouseArea {
            anchors.fill: parent
            onPressed: (mouse) => {
                searchInput.forceActiveFocus()
                mouse.accepted = false
            }
        }

        height: 40
        color: Style.popupAchtergrondKleur
        radius: Style.radiusGrooteM

        border {
            color: searchInput.activeFocus ? Style.accentKleur : Style.borderKleur
            width: Style.borderSize
        }

        TextField {
            id: searchInput
            anchors.fill: parent
            anchors.margins: Style.uiMarginsS

            placeholderText: "Zoek apps..."
            placeholderTextColor: Qt.rgba(255, 255, 255, 0.4)
            color: "white"

            background: Item {}
            verticalAlignment: TextInput.AlignVCenter

            onTextChanged: {
                console.log("Zoeken naar: " + text)
            }
        }
    }

    // --- Bovenste vak: Open apps ---
    Rectangle {
        id: openApps
        anchors {
            top: searchContainer.bottom
            topMargin: Style.uiMarginsM
            left: parent.left
            right: parent.right
        }

        height: ((appletWindow.height - (searchContainer.height + Style.uiMarginsM)) - Style.uiMarginsM) / 2
        color: Style.popupAchtergrondKleur
        radius: Style.radiusGrooteM

        border {
            color: Style.borderKleur
            width: Style.borderSize
        }

        GridView {
            anchors.fill: parent
            anchors.margins: Style.uiMarginsS
            cellWidth: 70
            cellHeight: 90
            clip: true

            model: ToplevelManager.toplevels.values

            delegate: Item {
                width: 70
                height: 90

                required property var modelData

                Rectangle {
                    anchors.centerIn: parent
                    width: 50
                    height: 50
                    radius: Style.radiusGrooteS
                    color: Style.accentKleur

                    Image {
                        anchors.fill: parent
                        anchors.margins: 6
                        source: {
                            var entry = DesktopEntries.byId(modelData.appId)
                            return entry ? "image://icon/" + entry.icon : ""
                        }
                    }
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.title
                    color: "white"
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.activate()
                }
            }
        }
    }

    // --- Onderste vak: Recente apps ---
    Rectangle {
        id: appOpener

        anchors {
            top: openApps.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: Style.uiMarginsM
        }

        color: Style.popupAchtergrondKleur
        radius: Style.radiusGrooteM

        border {
            color: Style.borderKleur
            width: Style.borderSize
        }

        GridView {
            anchors.fill: parent
            anchors.margins: Style.uiMarginsS
            cellWidth: 70
            cellHeight: 90
            clip: true

            model: {
                var ids = appletWindow.recentIds.length > 0
                    ? appletWindow.recentIds
                    : ["firefox", "code", "kitty", "discord",
                    "spotify", "obsidian", "gimp", "vlc",
                    "steam", "thunderbird", "org.gnome.Nautilus",
                    "libreoffice-writer", "blender", "inkscape",
                    "pavucontrol", "org.kde.dolphin"]

                return ids
                    .map(id => DesktopEntries.byId(id))
                    .filter(e => e !== null)
            }


            delegate: Item {
                width: 70
                height: 90

                required property var modelData

                Rectangle {
                    anchors.centerIn: parent
                    width: 50
                    height: 50
                    radius: Style.radiusGrooteS
                    color: Style.accentKleur

                    Image {
                        anchors.fill: parent
                        anchors.margins: 6
                        source: "image://icon/" + modelData.icon
                    }
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.name
                    color: "white"
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.execute()
                }
            }
        }
    }
}