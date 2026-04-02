import QtQuick
import "../"

Rectangle {
    id: buttonRoot

    // Custom properties die je per knop kunt aanpassen
    property alias text: label.text
    property color baseColor: Style.accentKleur
    
    // Signaal dat we afvuren als er geklikt wordt
    signal clicked()

    radius: Style.radiusGrooteM
    height: parent.height
    width: parent.height // Vierkante knop
    color: hoverHandler.hovered ? Qt.lighter(baseColor, 1.2) : baseColor

    border {
        color: Style.borderKleur
        width: Style.borderSize
    }

    HoverHandler { id: hoverHandler }
    
    TapHandler { 
        onTapped: buttonRoot.clicked() 
    }

    Text {
        id: label
        anchors.centerIn: parent
        font.pixelSize: Style.fontGrootteM
        color: Style.textKleur
    }
}