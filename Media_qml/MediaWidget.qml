// MediaWidget.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import "../"

PopupWindow {
    // --- style base window ---
    id: mediawindow
    visible: false
    color: "transparent"

    property real currentPositionMs: MprisService.activePlayer ? MprisService.activePlayer.position : 0

    implicitHeight: 340
    implicitWidth: 500

    anchor {
        window: barWindow
        rect: Qt.rect(
            barWindow.musicButtonX + barWindow.musicButtonWidth / 2 - implicitWidth / 2,
            barWindow.height,
            implicitWidth,
            implicitHeight
        )
    }

    // --- mouse detection ---
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
        onTriggered: mediawindow.visible = false
    }

    function stopSluiten() { closeTimer.stop() }
    function startSluiten() { closeTimer.start() }
    function toggle() { visible = !visible }

    // --- UI ---

    Rectangle {
        id: mediarectangle
        anchors {
            fill: parent
        }

        color: Style.popupAchtergrondKleur
        radius: Style.radiusGrooteM

        border {
            color: Style.borderKleur
            width: Style.borderSize
        }

        // --- player selector ---
        Row {
            id: playerSelecter
            width: mediawindow.width
            height: Style.barHoogte
            spacing: 2
            anchors {
                top: mediarectangle.top
                left: mediarectangle.left
                right: mediarectangle.right

                topMargin: Style.uiMarginsM
                leftMargin: Style.uiMarginsM
                rightMargin: Style.uiMarginsM
            }

            Repeater {
                model: MprisService.players

                Rectangle {
                    required property MprisPlayer modelData
                    required property int index

                    width: MprisService.players.length > 0
                        ? (playerSelecter.width - playerSelecter.leftPadding - playerSelecter.rightPadding - (MprisService.players.length - 1) * playerSelecter.spacing) / MprisService.players.length
                        : playerSelecter.width - playerSelecter.leftPadding - playerSelecter.rightPadding

                    height: parent.height

                    color: MprisService.activePlayer === modelData
                        ? Style.accentKleur
                        : "transparent"

                    border {
                        color: Style.borderKleur
                        width: Style.borderSize
                    }

                    radius: Style.radiusGrooteM

                    Text {
                        anchors.centerIn: parent
                        text: modelData.identity
                        color: Style.textKleur
                        font.pixelSize: Style.fontGrootteS
                        elide: Text.ElideRight
                        width: parent.width - 8
                        horizontalAlignment: Text.AlignHCenter
                    }

                    HoverHandler {
                        cursorShape: Qt.PointingHandCursor
                    }

                    TapHandler {
                        onTapped: MprisService.selectPlayer(index)
                    }
                }
            }
        }

        // --- art / thumbnail ---

        Column {
            spacing: 15
            anchors {
                top: playerSelecter.bottom
                bottom: progressBar.top
                topMargin: Style.uiMarginsL
                horizontalCenter: playerSelecter.horizontalCenter
            }

            ThumbnailArt {
                size: 180 // Lekker groot in de widget
                anchors.horizontalCenter: parent.horizontalCenter
                artUrl: MprisService.activePlayer?.metadata["mpris:artUrl"] ?? ""
            }

            // Hieronder komt je tekst (Titel/Artiest) en de ProgressBar
            Text {
                text: MprisService.activePlayer?.metadata["xesam:title"] ?? "Niets aan het spelen"
                color: Style.textKleur
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // --- progres bar --- 

        Timer {
            id: progressTimer
            interval: 500 // Update elke halve seconde
            running: MprisService.activePlayer && MprisService.activePlayer.playbackState === MprisPlaybackState.Playing
            repeat: true
            onTriggered: {
                // Haal de nieuwste positie op van de service
                currentPositionMs = MprisService.activePlayer.position;
            }
        }

        MediaProgressBar {
            id: progressBar
            anchors {
                left: mediarectangle.left
                right: mediarectangle.right
                bottom: controlRow.top

                rightMargin: Style.uiMarginsL
                leftMargin: Style.uiMarginsL
                bottomMargin: Style.uiMarginsM

            }

            // Koppel de properties aan je service
            position: currentPositionMs
            length: MprisService.activePlayer ? MprisService.activePlayer.length : 1
            isSeekable: MprisService.activePlayer ? MprisService.activePlayer.canSeek : false

            // Wat er moet gebeuren als de gebruiker in de balk klikt
            onSeekRequested: (newPos) => {
                if (MprisService.activePlayer) {
                    MprisService.activePlayer.position = newPos;
                    currentPositionMs = newPos; // Update visueel direct
                }
            }
        }

        // --- bestuur knoppen ---

        Row {
            id: controlRow
            
            // Deze anchors gelden voor de Row zélf, dat mag wel!
            anchors {
                bottom: mediarectangle.bottom
                horizontalCenter: parent.horizontalCenter
                leftMargin: Style.uiMarginsM
                rightMargin: Style.uiMarginsM
                bottomMargin: Style.uiMarginsM
            }

            height: Style.barHoogte
            spacing: Style.uiMarginsS

            Button_element {
                text: "⏮"
                onClicked: MprisService.previous()
            }

            Button_element {
                // Hier gebruiken we een binding voor de play/pause tekst
                text: MprisService.activePlayer?.playbackState === MprisPlaybackState.Playing ? "⏸" : "▶"
                onClicked: MprisService.playPause()
                baseColor: Style.accentKleur // Je kunt eventueel hier een andere kleur meegeven
            }

            Button_element {
                text: "⏭"
                onClicked: MprisService.next()
            }
        }
    }
}