import Quickshell
import QtQuick
import "."

//Shell.qml

ShellRoot {
    id: shellRoot

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
}