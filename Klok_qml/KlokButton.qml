import Quickshell
import QtQuick
import "../"

Rectangle {
    id: klokButton 

	visible: true
	radius: Style.radiusGrooteM
	width: klok_column.width + 20
	color: Style.achtergrondKleur
	border {
		color: Style.borderKleur
		width: Style.barBorderSize
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: {
			klokwidget.active = true
		}

		onEntered: {
			if (klokwidget.item) {
				klokwidget.item.stopSluiten()
			}
		}
			
		onExited: {
			if (klokwidget.active && klokwidget.item) {
				klokwidget.item.startSluiten()
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
			font.pixelSize: Style.fontKlokgrote
			text: Qt.formatDateTime(new Date(), "HH:mm:ss")
		}

		Text {
			id: date_text
			color: Style.textKleur
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Style.fontKlokgrote
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