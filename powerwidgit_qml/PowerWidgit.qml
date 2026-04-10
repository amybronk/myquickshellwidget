import Quickshell
import Quickshell.Io
import QtQuick
import "../"

PopupWindow {
    id: powermaneger
    visible: true
    color: "transparent"

	implicitHeight: 390
    implicitWidth: 180


    anchor {
        window: barWindow
        rect: Qt.rect(
            barWindow.powermanegerX + barWindow.powermanegerWidth / 2 - implicitWidth / 2,
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
        onTriggered: powerwindow.active = false
    }

    function stopSluiten() { closeTimer.stop() }
    function startSluiten() { closeTimer.start() }

    Process {
        id: openerQmlDir
        command: ["bash", "-c", "xdg-open $HOME/.config/quickshell/"]
    }

    Process {
        id: openerSaveStates
        command: ["bash", "-c", "xdg-open $HOME/.config/quickshell/SaveStates_txt/"]
    }



    Rectangle {
        id: rootui
        anchors {
            fill: parent
        }

        color: Style.popupAchtergrondKleur
        radius: Style.radiusGrooteM

        border {
            color: Style.borderKleur
            width: Style.borderSize
        }

        // --- select your power profilles ---
        Rectangle {
            id: powerProfilleSlector

            border {
                color: Style.borderKleur
                width: Style.borderSize
            }

            height: Style.barHoogte
            color: "transparent"
            radius: Style.radiusGrooteM

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right

                topMargin: Style.uiMarginsL
                leftMargin: Style.uiMarginsL
                rightMargin: Style.uiMarginsL
            }
        }

        // --- set shutdown timer ---
        Rectangle {
            id: timeLengtSelector

            border {
                color: Style.borderKleur
                width: Style.borderSize
            }

            height: Style.barHoogte
            color: "transparent"
            radius: Style.radiusGrooteM

            anchors {
                top: powerProfilleSlector.bottom
                left: parent.left
                right: parent.right

                topMargin: Style.uiMarginsL
                leftMargin: Style.uiMarginsL
                rightMargin: Style.uiMarginsL
            }
        }

        // --- start shutdown timer ---
        Rectangle {
            id: powerDouwnTimerStart

            border {
                color: Style.borderKleur
                width: Style.borderSize
            }

            height: Style.barHoogte
            color: "transparent"
            radius: Style.radiusGrooteM

            anchors {
                top: timeLengtSelector.bottom
                left: parent.left
                right: parent.right

                topMargin: Style.uiMarginsL
                leftMargin: Style.uiMarginsL
                rightMargin: Style.uiMarginsL
            }
        }

        // --- sleep / log out button ---
        Rectangle {
            id: sleepLogOut

            border {
                color: Style.borderKleur
                width: Style.borderSize
            }

            height: Style.barHoogte
            color: "transparent"
            radius: Style.radiusGrooteM

            anchors {
                top: powerDouwnTimerStart.bottom
                left: parent.left
                right: parent.right

                topMargin: Style.uiMarginsL
                leftMargin: Style.uiMarginsL
                rightMargin: Style.uiMarginsL
            }
        }

        // --- save state selector ---
        Rectangle {
            id: saveStateSelector

            border {
                color: Style.borderKleur
                width: Style.borderSize
            }

            height: Style.barHoogte
            color: "transparent"
            radius: Style.radiusGrooteM

            anchors {
                top: sleepLogOut.bottom
                left: parent.left
                right: parent.right

                topMargin: Style.uiMarginsL
                leftMargin: Style.uiMarginsL
                rightMargin: Style.uiMarginsL
            }
        }

        // --- save / load button for save states ---
        Rectangle {
            id: saveLoadSaveState

            border {
                color: Style.borderKleur
                width: Style.borderSize
            }

            height: Style.barHoogte
            color: "transparent"
            radius: Style.radiusGrooteM

            anchors {
                top: saveStateSelector.bottom
                left: parent.left
                right: parent.right

                topMargin: Style.uiMarginsL
                leftMargin: Style.uiMarginsL
                rightMargin: Style.uiMarginsL
            }
        }

        // --- shutdown pc ---
        Rectangle {
            id: shutdown

            border {
                color: Style.borderKleur
                width: Style.borderSize
            }

            height: Style.barHoogte
            color: "transparent"
            radius: Style.radiusGrooteM

            anchors {
                top: saveLoadSaveState.bottom
                left: parent.left
                right: parent.right

                topMargin: Style.uiMarginsL
                leftMargin: Style.uiMarginsL
                rightMargin: Style.uiMarginsL
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    shutdownConfirmWindow.active = true
                }
            }
        }

        Text {
            id: saveStatDir

            text: "save state"

            color: Style.textKleur2

            font {
                pixelSize: Style.fontGrootteL
            }

            anchors {
                top: shutdown.bottom
                left: parent.left

                topMargin: Style.uiMarginsL
                leftMargin: Style.uiMarginsL
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    openerSaveStates.running = true
                }
            }
        }

        Text {
            id: qmlConfig

            text: "qml"

            color: Style.textKleur2

            font {
                pixelSize: Style.fontGrootteL
            }

            anchors {
                top: shutdown.bottom
                right: parent.right

                topMargin: Style.uiMarginsL
                rightMargin: Style.uiMarginsL
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    openerQmlDir.running = true
                }
            }
        }
    }
}