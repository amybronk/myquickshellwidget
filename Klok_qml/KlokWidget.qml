import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../"

PopupWindow {
    id: klokwindow
    visible: true
    color: "transparent"

	implicitHeight: 300
    implicitWidth: 125

    anchor {
        window: barWindow
        rect: Qt.rect(
            barWindow.klokX + barWindow.klokWidth / 2 - implicitWidth / 2,
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
        onTriggered: klokwidget.active = false
    }
    
    function stopSluiten() { closeTimer.stop() }
    function startSluiten() { closeTimer.start() }

    // --- ui ---
	Rectangle {
		anchors.fill: parent
		
		color: Style.popupAchtergrondKleur
		radius: Style.radiusGrooteM

        border {
            width: Style.borderSize
            color: Style.borderKleur
        }

        // --- klok ---
        Rectangle {
            id: digitalklok
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right

                topMargin: Style.uiMarginsM
            }

            height: klok_column.height
            color: "transparent"

            Column {
                id: klok_column
                spacing: -2
                anchors.centerIn: parent

                Text {
                    id: klok_text
                    color: Style.textKleur
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Style.fontGrootteL
                    text: Qt.formatDateTime(new Date(), "HH:mm:ss")
                }

                Text {
                    id: date_text
                    color: Style.textKleur
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Style.fontGrootteL
                    text: Qt.formatDateTime(new Date(), "dddd, dd MMMM yyyy")
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {
                        var date = new Date()
                        klok_text.text = Qt.formatDateTime(date, "HH:mm:ss")
                        date_text.text = Qt.formatDateTime(date, "dddd, dd MMMM yyyy")
                    }
                }
            }
        }
        // --- todo more UI ---
	}
}
