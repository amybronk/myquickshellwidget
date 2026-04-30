import Quickshell
import QtQuick
import "../"

Rectangle {
    id: settings
    visible: true
	radius: Style.radiusGrooteM
	width: Style.barbuttonlengt
	color: Style.achtergrondKleur
	border {
		color: Style.borderKleur
		width: Style.barBorderSize
	}

	Text {
		anchors.centerIn: parent
		text: "⚙"
		color: Style.colourSettingsButton
		// We gebruiken de hoogte van de parent (Rectangle) voor de font-grootte
		font.pixelSize: parent.height * 0.7
	}

	MouseArea {
       	anchors.fill: parent
       	cursorShape: Qt.PointingHandCursor

   	    onClicked: {
			// Check of de instance bestaat EN of hij niet stiekem al vernietigd is
			if (winInstance === null || typeof winInstance === "undefined" || winInstance.toString() === "null") {
				let component = Qt.createComponent(Qt.resolvedUrl("../Settings_qml/SettingsMenu.qml"))
				
				if (component.status === Component.Ready) {
					let obj = component.createObject(null)
					
					if (obj) {
						winInstance = obj

						// Veilig verbinden: we gebruiken de 'destroyed' signaal handler
						winInstance.destroyed.connect(function() {
							winInstance = null
						})
					}
				} else {
					console.error("Fout bij laden:", component.errorString())
				}
			} else {
				// Probeer het venster naar voren te halen, maar vang fouten op
				try {
					winInstance.raise()
					winInstance.requestActivate() // Zorgt dat hij echt de focus krijgt
				} catch (e) {
					// Als raise() faalt, is het object dood. Zet op null en probeer opnieuw.
					winInstance = null
    				// Roep de functie recursief nog een keer aan om het venster nu wel te openen
					onClicked(mouse)
				}
			}
		}
    }
}