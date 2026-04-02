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
    visible: false
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

	Rectangle {
		anchors.fill: parent
		
		color: Style.popupAchtergrondKleur
		radius: Style.radiusGrooteM
            Text {
                anchors.centerIn: parent
                text: "test"
                color: Style.textKleur
                font.pixelSize: Style.fontGrootteL
            }
	}

	MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: klokwidget.stopSluiten()
        onExited: klokwidget.startSluiten()

        Timer {
            id: closeTimer
            interval: Style.exitTimer
            onTriggered: klokwidget.visible = false
        }
    }

    function stopSluiten() {
        closeTimer.stop()
    }

    function startSluiten() {
        closeTimer.start()
    }
	
	function toggle() {
		visible = !visible
	}
	
}
