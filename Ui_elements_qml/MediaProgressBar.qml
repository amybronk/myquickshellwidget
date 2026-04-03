import QtQuick
import "../" // Importeer je qmldir voor Style

Rectangle {
    id: root

    // Custom properties die we van buitenaf gaan invullen
    property real position: 0
    property real length: 1 // Voorkom delen door nul
    property bool isSeekable: false

    // Signaal als de gebruiker in de balk klikt om door te spoelen
    signal seekRequested(real newPosition)

    height: Style.sliderThickness
    radius: Style.radiusGrooteS
    color: Qt.darker(Style.borderKleur, 1.2) // Donkere achtergrond voor de "goot"

    // De gekleurde balk die zich vult
    Rectangle {
        id: fill
        height: parent.height
        radius: parent.radius
        color: Style.accentKleur

        // Bereken de breedte op basis van het percentage
        width: root.length > 0 ? (root.position / root.length) * root.width : 0

        // Vloeiende animatie zodat de balk niet schokt bij updates
        Behavior on width {
            NumberAnimation { duration: Style.fastRepeatTimer; easing.type: Easing.OutQuad }
        }
    }

    // Klikken om door te spoelen
    TapHandler {
        enabled: root.isSeekable
        onTapped: (eventPoint) => {
            if (root.length > 0) {
                // Bereken op welk percentage van de balk is geklikt
                let clickPercentage = eventPoint.position.x / root.width;
                // Vuur het signaal af met de nieuwe tijd (in microseconden)
                root.seekRequested(clickPercentage * root.length);
            }
        }
    }
}