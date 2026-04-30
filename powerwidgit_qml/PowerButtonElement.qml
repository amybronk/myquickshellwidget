import Quickshell
import QtQuick
import "../"

Rectangle { 
    id: powerButton

    visible: true
	radius: Style.radiusGrooteM
	width: Style.barHoogte
	color: Style.achtergrondKleur

	border {
		color: Style.borderKleur
		width: Style.barBorderSize
	}

	Text {
		anchors {
			centerIn: parent
			verticalCenterOffset: -powerButton.height * 0.00
			horizontalCenterOffset: -powerButton.width * 0.02
		}

		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		text: "⏻"
		color: Style.colourPowerButton


		font{ 
			pixelSize: powerButton.height * 0.85
		}
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor

		onClicked: {
			powerwindow.active = true
		}

		onEntered: {
			if (powerwindow.item) {
				powerwindow.item.stopSluiten()
			}
		}

		onExited: {
			if (powerwindow.active && powerwindow.item) {
				powerwindow.item.startSluiten()
			}
		}
	}
}