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

	
	anchors {
		top: true
		right: true
		left: true
	}

	implicitHeight: Style.barHoogte
	visible: true 
	color: '#00000000'

	PowerButtonElement {
		id: powermanegerwindow

		anchors {
			top: parent.top
			left: parent.left
			bottom: parent.bottom

			topMargin: Style.topBarMargins
			leftMargin: Style.uiMarginsM
			bottomMargin: Style.bottomBarMargins
		}
		
	}

	AppPalletButton {
		id: apppalletButton

		anchors {
			top: parent.top
			left: powermanegerwindow.right
			bottom: parent.bottom

			topMargin: Style.topBarMargins
			leftMargin: Style.uiMarginsM
			rightMargin: Style.uiMarginsM
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

	SettingsButtonElement {
		id: settingsB

		anchors {
			top: parent.top
			right: cameraindication.left
			bottom: parent.bottom
			
			topMargin: Style.topBarMargins
			rightMargin: Style.uiMarginsS
			bottomMargin: Style.bottomBarMargins
		}

		border {
			color: Style.borderKleur
			width: Style.barBorderSize
		}

		radius: Style.radiusGrooteM
		width: Style.barbuttonlengt
		color: Style.achtergrondKleur

		Text {
			anchors.centerIn: parent
			text: "⚙"
			color: Style.colourSettingsButton
			font { pixelSize: parent.height * 0.7 }
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
