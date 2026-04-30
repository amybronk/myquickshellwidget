import Quickshell
import QtCore
import QtQuick
import "."

//Shell.qml

ShellRoot {
    id: shellRoot

	Component.onCompleted: {
        Qt.application.name = "Quickshell"
        Qt.application.organization = "UserConfig"
    }

    Bar { id: barWindow }

	Loader {
		id: musiccontrol
		active: false
		source: "Media_qml/MediaWidget.qml"
	}

	Loader {
		id: klokwidget
		active: false
		source: "Klok_qml/KlokWidget.qml"
	}

	Loader {
		id: applet
		active: false
		source: "AppPallet_qml/AppPallet.qml"
	}

	Loader {
		id: powerwindow
		active: false
		source: "powerwidgit_qml/PowerWidgit.qml"
	}

	Loader {
        id: shutdownConfirmWindow
        active: false
        source: "powerwidgit_qml/PowerOffConformation.qml"
    }
}