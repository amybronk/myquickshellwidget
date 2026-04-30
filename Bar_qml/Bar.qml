import Quickshell
import QtQuick
import "../"

//Bar.qml

PanelWindow {
	id: root

	property alias musicButtonX: musicButton.x
	property alias musicButtonWidth: musicButton.width

	property alias klokX: klok.x
	property alias klokWidth: klok.width

	property alias apppalletX: apppalletButton.x
	property alias apppalletWidth: apppalletButton.width

	property alias powermanegerX: powermanegerwindow.x
	property alias powermanegerWidth: powermanegerwindow.width

	property var winInstance: null
	
	anchors {
		top: true
		right: true
		left: true
	}

	implicitHeight: Style.barHoogte
	visible: true 
	color: '#00000000'

	AppPalletButton {
		id: apppalletButton

		anchors {
			top: parent.top
			left: parent.left
			bottom: parent.bottom

			topMargin: Style.topBarMargins
			leftMargin: 5
			rightMargin: 5
			bottomMargin: Style.bottomBarMargins
		}
	}

	MusicButtonElement {
		id: musicButton

		anchors {
			top: parent.top
			left: apppalletButton.right
			bottom: parent.bottom

			topMargin: Style.topBarMargins
			leftMargin: Style.uiMarginsG
			bottomMargin: Style.bottomBarMargins
		}
	}

	PowerButtonElement {
		id: powermanegerwindow

		anchors {
			top: parent.top
			left: musicButton.right
			bottom: parent.bottom

			topMargin: Style.topBarMargins
			leftMargin: Style.uiMarginsG
			bottomMargin: Style.bottomBarMargins
		}
	}

	WorkeSpaceIndicator {
		id: tab

		anchors {
			top: parent.top
			horizontalCenter: parent.horizontalCenter
			bottom: parent.bottom

			topMargin: Style.topBarMargins
			leftMargin: 5
			rightMargin: 5
			bottomMargin: Style.bottomBarMargins
		}
	}

	Rectangle {
		id: settings

		anchors {
			top: parent.top
			right: cameraindication.left
			bottom: parent.bottom
			
			topMargin: Style.topBarMargins
			rightMargin: Style.uiMarginsS
			bottomMargin: Style.bottomBarMargins
		}

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
				color: Style.colourPink
				// We gebruiken de hoogte van de parent (Rectangle) voor de font-grootte
				font.pixelSize: parent.height * 0.7
			}

			MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                // Als er al een venster is, niet nog een maken
                if (winInstance == null) {
                    let component = Qt.createComponent(Qt.resolvedUrl("../Settings_qml/SettingsMenu.qml"))
                    
                    if (component.status === Component.Ready) {
                        // Maak het object aan en sla het op in winInstance
                        winInstance = component.createObject(null)
                        
                        // Zorg dat als het venster vernietigd wordt, we winInstance op null zetten
                        winInstance.onDestroyed.connect(() => {
                            winInstance = null
                        })
                    } else {
                        console.error("Fout bij laden:", component.errorString())
                    }
                } else {
                    winInstance.raise() // Breng bestaand venster naar voren
                }
            }
        }
	}

	CameraIndicator {
		id: cameraindication

		anchors {
			top: parent.top
			right: tailscaleButton.left
			bottom: parent.bottom
			
			topMargin: Style.topBarMargins
			rightMargin: Style.uiMarginsS
			bottomMargin: Style.bottomBarMargins
		}
	}

	TailscaleButton {
		id: tailscaleButton

		anchors {
			top: parent.top
			right: klok.left
			bottom: parent.bottom

			topMargin: Style.topBarMargins
			rightMargin: Style.uiMarginsM
			bottomMargin: Style.bottomBarMargins
		}
	}
	
	KlokButton {
		id: klok

		anchors {
			top: parent.top
			right: parent.right
			bottom: parent.bottom

			topMargin: Style.topBarMargins
			rightMargin: Style.uiMarginsM
			bottomMargin: Style.bottomBarMargins
		}
	}
}
