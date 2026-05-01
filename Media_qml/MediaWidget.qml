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
    visible: true
    color: "transparent"

    property real currentPositionMs: MprisService.activePlayer ? MprisService.activePlayer.position : 0

    implicitHeight: 800
    implicitWidth: 800

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
        onTriggered: musiccontrol.active = false
    }

    function stopSluiten() { closeTimer.stop() }
    function startSluiten() { closeTimer.start() }

    // --- UI ---
    Rectangle {
        id: root
        anchors.fill: parent
        radius: Style.radiusGrooteM
        color: "transparent"

        // --- Hoofdvenster voor media ---
        Rectangle {
            id: mainSubWindow
            width: 350
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
            
            color: "transparent"
            radius: Style.radiusGrooteM
            border {
                color: Style.borderKleur
                width: Style.mediaBorderSize
            }

            // 1. Speler Selectie
            Row {
                id: mediaSelector
                width: parent.width
                height: Style.barHoogte
                spacing: 2
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
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
                            ? (mediaSelector.width - mediaSelector.leftPadding - mediaSelector.rightPadding - (MprisService.players.length - 1) * mediaSelector.spacing) / MprisService.players.length
                            : mediaSelector.width - mediaSelector.leftPadding - mediaSelector.rightPadding

                        height: parent.height

                        color: MprisService.activePlayer === modelData ? Style.accentKleur : Style.popupAchtergrondKleur
                        radius: Style.radiusGrooteM
                        border {
                            color: Style.borderKleur
                            width: Style.borderSize
                        }

                        Text {
                            anchors.centerIn: parent
                            text: modelData.identity
                            color: Style.textKleur
                            font.pixelSize: Style.fontGrootteS
                            elide: Text.ElideRight
                            width: parent.width - 8
                            horizontalAlignment: Text.AlignHCenter
                        }

                        HoverHandler { cursorShape: Qt.PointingHandCursor }
                        TapHandler { onTapped: MprisService.selectPlayer(index) }
                    }
                }
            }

            // 2. Album Art / Thumbnail
            ThumbnailArt {
                id: thumbnail
                size: Style.mediaWidth
                anchors {
                    top: mediaSelector.bottom
                    topMargin: Style.uiMarginsL
                    horizontalCenter: parent.horizontalCenter
                }
                artUrl: MprisService.activePlayer?.metadata["mpris:artUrl"] ?? ""
            }

            // 3. Titel Tekst
            Rectangle {
                id: titelContainer
                color: Style.popupAchtergrondKleur // Behouden als container, maar transparant
                anchors {
                    top: thumbnail.bottom
                    horizontalCenter: parent.horizontalCenter

                    topMargin: 15
                }

                border {
                    color: Style.borderKleur
                    width: Style.borderSize
                }

                height: titelText.implicitHeight + 15
                width: Style.mediaWidth

                Text {
                    id: titelText
                    text: MprisService.activePlayer?.metadata["xesam:title"] ?? "Niets aan het spelen"
                    color: Style.textKleur
                    font.bold: true
                    anchors { 
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                }
            }

            // 4. Status Bar (Voortgang)
            Timer {
                id: progressTimer
                interval: Style.fastRepeatTimer 
                running: MprisService.activePlayer && MprisService.activePlayer.playbackState === MprisPlaybackState.Playing
                repeat: true
                onTriggered: {
                    currentPositionMs = MprisService.activePlayer.position;
                }
            }

            Rectangle {
                id: uielementStatusBar

                anchors {
                    top: titelContainer.bottom
                    horizontalCenter: parent.horizontalCenter

                    bottomMargin: Style.uiMarginsM
                }

                border {
                    color: Style.borderKleur
                    width: Style.borderSize
                }

                height: Style.barHoogte
                width: Style.mediaWidth
                color: Style.popupAchtergrondKleur

                Item {
                    id: statusBar

                    anchors {
                        fill: parent

                        topMargin: Style.uiMarginsM
                        rightMargin: Style.uiMarginsL
                        leftMargin: Style.uiMarginsL
                        bottomMargin: Style.uiMarginsM
                    }
                    height: progressBar.implicitHeight || 20 // Gebruik de hoogte van je balk

                    MediaProgressBar {
                        id: progressBar
                        anchors.fill: parent
                        position: currentPositionMs
                        length: MprisService.activePlayer ? MprisService.activePlayer.length : 1
                        isSeekable: MprisService.activePlayer ? MprisService.activePlayer.canSeek : false

                        onSeekRequested: (newPos) => {
                            if (MprisService.activePlayer) {
                                MprisService.activePlayer.position = newPos;
                                currentPositionMs = newPos;
                            }
                        }
                    }
                }
            }

            // 5. Media Knoppen (Vorige, Pauze, Volgende)
            Row {
                id: mediaControls
                anchors {
                    top: uielementStatusBar.bottom
                    horizontalCenter: parent.horizontalCenter
                    topMargin: Style.uiMarginsM
                }
                height: Style.barHoogte
                spacing: Style.uiMarginsS

                Button_element {
                    id: previousButton
                    text: "⏮"
                    onClicked: MprisService.previous()
                }

                Button_element {
                    id: pauseButton
                    text: MprisService.activePlayer?.playbackState === MprisPlaybackState.Playing ? "⏸" : "▶"
                    onClicked: MprisService.playPause()
                    baseColor: Style.accentKleur
                }

                Button_element {
                    id: nextButton
                    text: "⏭"
                    onClicked: MprisService.next()
                }
            }
        }

        // --- Volume venster ---
        Rectangle {
            id: volumeSubWindow
            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
                left: mainSubWindow.right
                leftMargin: Style.uiMarginsM
            }
            
            color: Style.popupAchtergrondKleur
            radius: Style.radiusGrooteM
            border {
                color: Style.borderKleur
                width: Style.borderSize
            }

            Volume_element {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    bottom: mutebutton.top
                    topMargin: Style.uiMarginsL
                    bottomMargin: Style.uiMarginsL
                }
            }

            MuteButton {
                id: mutebutton
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: Style.uiMarginsL
                }
            }
        }
    }
}
//     Rectangle {
//         id: rootui

//         anchors {
//             fill: parent
//         }

//         radius: Style.radiusGrooteM

//         color: "transparent"
        
//         // --- main window ---
//         Rectangle {
//             id: mediarectangle
//             anchors {
//                 top: parent.top
//                 left: parent.left
//                 bottom: parent.bottom
//             }
//             width:500

//             color: Style.popupAchtergrondKleur
//             radius: Style.radiusGrooteM

//             border {
//                 color: Style.borderKleur
//                 width: Style.borderSize
//             }

//             // --- player selector ---
//             Row {
//                 id: playerSelecter
//                 width: mediawindow.width
//                 height: Style.barHoogte
//                 spacing: 2
//                 anchors {
//                     top: mediarectangle.top
//                     left: mediarectangle.left
//                     right: mediarectangle.right

//                     topMargin: Style.uiMarginsM
//                     leftMargin: Style.uiMarginsM
//                     rightMargin: Style.uiMarginsM
//                 }

//                 Repeater {
//                     model: MprisService.players

//                     Rectangle {
//                         required property MprisPlayer modelData
//                         required property int index

//                         width: MprisService.players.length > 0
//                             ? (playerSelecter.width - playerSelecter.leftPadding - playerSelecter.rightPadding - (MprisService.players.length - 1) * playerSelecter.spacing) / MprisService.players.length
//                             : playerSelecter.width - playerSelecter.leftPadding - playerSelecter.rightPadding

//                         height: parent.height

//                         color: MprisService.activePlayer === modelData
//                             ? Style.accentKleur
//                             : "transparent"

//                         border {
//                             color: Style.borderKleur
//                             width: Style.borderSize
//                         }

//                         radius: Style.radiusGrooteM

//                         Text {
//                             anchors.centerIn: parent
//                             text: modelData.identity
//                             color: Style.textKleur
//                             font.pixelSize: Style.fontGrootteS
//                             elide: Text.ElideRight
//                             width: parent.width - 8
//                             horizontalAlignment: Text.AlignHCenter
//                         }

//                         HoverHandler {
//                             cursorShape: Qt.PointingHandCursor
//                         }

//                         TapHandler {
//                             onTapped: MprisService.selectPlayer(index)
//                         }
//                     }
//                 }
//             }

//             // --- art / thumbnail ---

//             Column {
//                 spacing: 15
//                 anchors {
//                     top: playerSelecter.bottom
//                     bottom: progressBar.top
//                     topMargin: Style.uiMarginsL
//                     horizontalCenter: playerSelecter.horizontalCenter
//                 }

//                 ThumbnailArt {
//                     size: 180
//                     anchors.horizontalCenter: parent.horizontalCenter
//                     artUrl: MprisService.activePlayer?.metadata["mpris:artUrl"] ?? ""
//                 }

//                 // (Titel/Artiest)
//                 Text {
//                     text: MprisService.activePlayer?.metadata["xesam:title"] ?? "Niets aan het spelen"
//                     color: Style.textKleur
//                     font.bold: true
//                     anchors.horizontalCenter: parent.horizontalCenter
//                 }
//             }

//             // --- progres bar --- 
//             Timer {
//                 id: progressTimer
//                 interval: Style.fastRepeatTimer 
//                 running: MprisService.activePlayer && MprisService.activePlayer.playbackState === MprisPlaybackState.Playing
//                 repeat: true
//                 onTriggered: {
//                     currentPositionMs = MprisService.activePlayer.position;
//                 }
//             }

//             MediaProgressBar {
//                 id: progressBar
//                 anchors {
//                     left: mediarectangle.left
//                     right: mediarectangle.right
//                     bottom: controlRow.top

//                     rightMargin: Style.uiMarginsL
//                     leftMargin: Style.uiMarginsL
//                     bottomMargin: Style.uiMarginsM

//                 }

//                 position: currentPositionMs
//                 length: MprisService.activePlayer ? MprisService.activePlayer.length : 1
//                 isSeekable: MprisService.activePlayer ? MprisService.activePlayer.canSeek : false

//                 onSeekRequested: (newPos) => {
//                     if (MprisService.activePlayer) {
//                         MprisService.activePlayer.position = newPos;
//                         currentPositionMs = newPos;
//                     }
//                 }
//             }

//             // --- bestuur knoppen ---
//             Row {
//                 id: controlRow
                
//                 anchors {
//                     bottom: mediarectangle.bottom
//                     horizontalCenter: parent.horizontalCenter
//                     leftMargin: Style.uiMarginsM
//                     rightMargin: Style.uiMarginsM
//                     bottomMargin: Style.uiMarginsM
//                 }

//                 height: Style.barHoogte
//                 spacing: Style.uiMarginsS

//                 Button_element { //previous button
//                     text: "⏮"
//                     onClicked: MprisService.previous()
//                 }

//                 Button_element { //play button
//                     text: MprisService.activePlayer?.playbackState === MprisPlaybackState.Playing ? "⏸" : "▶"
//                     onClicked: MprisService.playPause()
//                     baseColor: Style.accentKleur
//                 }

//                 Button_element { //next button
//                     text: "⏭"
//                     onClicked: MprisService.next()
//                 }
//             }
//         }

//         // --- volume barre ---
//         Rectangle {
//             id: volumebar
//             anchors {
//                 top: parent.top
//                 right: parent.right
//                 bottom: parent.bottom
//                 left: mediarectangle.right
//                 leftMargin: Style.uiMarginsM
//             }
            
//             color: Style.popupAchtergrondKleur
//             radius: Style.radiusGrooteM

//             border {
//                 color: Style.borderKleur
//                 width: Style.borderSize
//             }

//             Volume_element {
//                 anchors {
//                     horizontalCenter: parent.horizontalCenter
//                     top: parent.top
//                     bottom: mutebutton.top
//                     topMargin: Style.uiMarginsL
//                     bottomMargin: Style.uiMarginsL
//                 }
//             }

//             MuteButton {
//                 id: mutebutton

//                 anchors {
//                     horizontalCenter: parent.horizontalCenter
//                     bottom: parent.bottom
//                     bottomMargin: Style.uiMarginsL
//                 }
//             }
//         }
//     }
// }