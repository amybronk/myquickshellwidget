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
			verticalCenterOffset: -powerButton.height * -0.04
			horizontalCenterOffset: -powerButton.width * 0.01
		}

		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		text: "⏻"
		color: Style.colourPowerButton


		font{
        	family: Style.globalFontFamily 
			pixelSize: powerButton.height * 0.99
			bold: true
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