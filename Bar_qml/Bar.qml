import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../"



PanelWindow {
	id: root

	property alias musicButtonX: musicButton.x
	property alias musicButtonWidth: musicButton.width

	property alias klokX: klok.x
	property alias klokWidth: klok.width
	
	anchors {
		top: true
		right: true
		left: true
	}

	implicitHeight: Style.barHoogte
	visible: true 
	color: '#00000000'

	Rectangle {
		id: apppallet

		anchors {
			top: parent.top
			left: parent.left
			bottom: parent.bottom

			topMargin: 1
			leftMargin: 5
			rightMargin: 5
			bottomMargin: 1
		}

		visible: true
		radius: Style.radiusGrooteM
		width: root.height
		color: Style.achtergrondKleur

		border {
			color: Style.borderKleur
			width: Style.borderSize
		}

		MouseArea {
			anchors.fill: parent
			cursorShape: Qt.PointingHandCursor
//			onClicked: app pallet
		}
	}

	Rectangle {
		id: musicButton

		anchors {
			top: parent.top
			left: apppallet.right
			bottom: parent.bottom

			topMargin: 1
			leftMargin: 5
			rightMargin: 5
			bottomMargin: 1
		}

		width: root.height
		radius: Style.radiusGrooteM
		color: Style.achtergrondKleur

		// --- DE MAGIE VOOR AFGERONDE CLIPPING ---
		layer.enabled: true
		layer.effect: OpacityMask {
			maskSource: Rectangle {
				width: musicButton.width
				height: musicButton.height
				radius: musicButton.radius // Dit dwingt de clipping in deze vorm
			}
		}

		// Je ThumbnailArt vult nu de knop en wordt netjes afgerond
		ThumbnailArt {
			anchors.fill: parent
			artUrl: MprisService.activePlayer?.metadata["mpris:artUrl"] ?? ""
		}

		// BELANGRIJK: De border moet op een aparte laag BOVENOP de clipping liggen
		// anders wordt de border zelf ook half weggeclipt of wazig.
		Rectangle {
			anchors.fill: parent
			color: "transparent"
			radius: parent.radius
			border {
				color: Style.borderKleur
				width: Style.borderSize
			}
		}

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			cursorShape: Qt.PointingHandCursor
			onClicked: {
				musiccontrol.visible = !musiccontrol.visible
				musiccontrol.stopSluiten()
			}
			onEntered: musiccontrol.stopSluiten()
			onExited: {
				if (musiccontrol.visible) {
					musiccontrol.startSluiten()
				}
			}
		}
	}

	Rectangle {
		id: tab
		anchors {
			top: parent.top
			horizontalCenter: parent.horizontalCenter
			bottom: parent.bottom

			topMargin: 1
			leftMargin: 5
			rightMargin: 5
			bottomMargin: 1
		}

		visible: true
		radius: Style.radiusGrooteM
		width: row_workspace.width + 20
		color: Style.achtergrondKleur
		border {
			color: Style.borderKleur
			width: Style.borderSize
		}
		Row {
			id: row_workspace
			spacing: 10
			anchors.centerIn: parent

			Repeater {
				model: 9
				delegate: Text {
					// Logica voor workspace status
					property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
					property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
					font.pixelSize: Style.iconGrooteM
					text: {
						if (isActive) return "⍟" //⍟ | 🞊
						if (ws) return "⬤"
						return "⭘"
					}
					// Kleur logica: actief vs bestaand vs leeg
					color: {
						if (isActive) return Style.actiefWerkbaldKleur
						if (ws) return Style.volleWerkbaldKleur
						return Style.legeWerkbaldKleur
					}

					MouseArea {
						anchors.fill: parent
						cursorShape: Qt.PointingHandCursor
						onClicked: Hyprland.dispatch("workspace " + (index + 1))
					}
				}
			}
		}
	}
	
	Rectangle {
		id: klok
		anchors {
			top: parent.top
			right: parent.right
			bottom: parent.bottom

			topMargin: 1
			leftMargin: 5
			rightMargin: 5
			bottomMargin: 1
		}

		visible: true
		radius: Style.radiusGrooteM
		width: klok_column.width + 20
		color: Style.achtergrondKleur
		border {
			color: Style.borderKleur
			width: Style.borderSize
		}

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			cursorShape: Qt.PointingHandCursor
			onClicked: {
				klokwidget.visible = !klokwidget.visible
				klokwidget.stopSluiten() // Zorg dat hij niet direct sluit bij klik
			}

			// DIT IS DE KEY:
			// Als we de knop binnengaan, mag de widget niet sluiten
			onEntered: {
				 klokwidget.stopSluiten()
				 klokwidget.visible = true
			}
			
			// Als we de knop verlaten, moet de widget gaan aftellen
			onExited: {
				if (klokwidget.visible) {
					klokwidget.startSluiten()
				}
			}
		}

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
					// Update both separate labels using their specific IDs
					klok_text.text = Qt.formatDateTime(date, "HH:mm:ss")
					date_text.text = Qt.formatDateTime(date, "dddd, dd MMMM yyyy")
				}
			}
			
		}
	}
}
