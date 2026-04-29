import Quickshell
import QtQuick
import Qt5Compat.GraphicalEffects
import "../"

Rectangle {
    id: musicButton

	width: Style.barbuttonlengt
	radius: Style.radiusGrooteM
	color: Style.achtergrondKleur

	layer.enabled: true
	layer.effect: OpacityMask {
		maskSource: Rectangle {
			width: musicButton.width
			height: musicButton.height
			radius: musicButton.radius
		}
	}


	ThumbnailArt {
		anchors.fill: parent
		artUrl: MprisService.activePlayer?.metadata["mpris:artUrl"] ?? ""
	}

	Rectangle {
		anchors.fill: parent
		color: "transparent"
		radius: parent.radius
		border {
			color: Style.borderKleur
			width: Style.barBorderSize
		}
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor

		onClicked: {
			musiccontrol.active = true
		}

		onEntered: {
			if (musiccontrol.item) {
				musiccontrol.item.stopSluiten()
			}
		}

		onExited: {
			if (musiccontrol.active && musiccontrol.item) {
				musiccontrol.item.startSluiten()
			}
		}
	}
}