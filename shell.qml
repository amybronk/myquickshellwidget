import Quickshell
import QtQuick
import "."

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
		active: false // Het object bestaat nu nog NIET in het RAM
		source: "Klok_qml/KlokWidget.qml"
	}
}