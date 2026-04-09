import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCore
import "../"

//AppPallet.qml


PopupWindow {
    id: appletWindow
    visible: true
    color: "transparent"

    property var recentIds: []

    implicitHeight: 663
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

    // --- top app box ---
    Rectangle {
        id: openApps
        anchors {
            top: searchContainer.bottom
            left: parent.left
            right: parent.right
            topMargin: Style.uiMarginsM
        }

        height: 197.5
        color: Style.popupAchtergrondKleur
        radius: Style.radiusGrooteM
        border { color: Style.borderKleur; width: Style.borderSize }

        GridView {
            anchors.fill: parent
            cellWidth: appletWindow.width / 8
            cellHeight: parent.height / Style.appletDrawrAmount
            clip: true

            model: Hyprland.clients

            delegate: OpenAppButton {
                required property var modelData
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight
                client: modelData
            }
        }
    }

    // --- center app box --- recente apps
    Rectangle {
        id: recentApps
        anchors {
            top: openApps.bottom
            left: parent.left
            right: parent.right
            topMargin: Style.uiMarginsM
        }

        height: 197.5
        color: Style.popupAchtergrondKleur
        radius: Style.radiusGrooteM
        border { color: Style.borderKleur; width: Style.borderSize }

        GridView {
            anchors.fill: parent
            cellWidth: appletWindow.width / 8
            cellHeight: parent.height / Style.appletDrawrAmount
            clip: true

            model: RecentApps.recentList   // ← was Hyprland.clients

            delegate: AppButton {          // ← was OpenAppButton
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight
                appData: modelData
            }
        }
    }

    // --- bottom app box --- favorieten (ongewijzigd)
    Rectangle {
        id: favoritApps
        anchors {
            top: recentApps.bottom
            left: parent.left
            right: parent.right
            topMargin: Style.uiMarginsM
        }

        height: 197.5
        color: Style.popupAchtergrondKleur
        radius: Style.radiusGrooteM
        border { color: Style.borderKleur; width: Style.borderSize }

        GridView {
            anchors.fill: parent
            cellWidth: appletWindow.width / 8
            cellHeight: parent.height / Style.appletDrawrAmount
            clip: true

            model: Favorites.apps

            delegate: AppButton {
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight
                appData: modelData
            }
        }
    }
}