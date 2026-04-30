import Quickshell
import QtQuick
import "../"

Rectangle {
    id: apppallet

	visible: true
	radius: Style.radiusGrooteM
	width: root.height
	color: Style.achtergrondKleur

	border {
		color: Style.borderKleur
		width: Style.barBorderSize
	}

	Text {
		anchors {
			centerIn: parent
			verticalCenterOffset: -apppallet.height * 0.06
			horizontalCenterOffset: -apppallet.width * 0.02
		}

		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		text: "⌂"
		color: Style.colourAppPalet

		font{ 
			pixelSize: apppallet.height * 0.85
		}
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor

		onClicked: {
			applet.active = true
		}

		onEntered: {
			if (applet.item) {
				applet.item.stopSluiten()
			}
		}

		onExited: {
			if (applet.active && applet.item) {
				applet.item.startSluiten()
			}
		}
	}
}