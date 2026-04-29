import Quickshell
import QtQuick
import Quickshell.Hyprland
import "../"

Rectangle {
    id: tab
	visible: true
	radius: Style.radiusGrooteM
	width: row_workspace.width + 20
	color: Style.achtergrondKleur
	border {
		color: Style.borderKleur
		width: Style.barBorderSize
	}
	Row {
		id: row_workspace
		spacing: 10
		anchors.centerIn: parent

		Repeater {
			model: 9
			delegate: Text {
				property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
				property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
				font.pixelSize: Style.iconGrooteM
				text: {
					if (isActive) return "⍟" //⍟ | 🞊
					if (ws) return "⬤"
					return "⭘"
				}

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