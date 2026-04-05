import QtQuick
import "../"

Rectangle {
    id: buttonRoot

    property alias text: label.text
    property color baseColor: Style.accentKleur
    
    signal clicked()

    radius: Style.radiusGrooteM
    height: parent.height
    width: parent.height
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
        font.pixelSize: Style.fontGrootteG
        color: Style.textKleur
    }
}