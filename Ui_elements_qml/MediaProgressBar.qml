import QtQuick
import "../"

// writen by claud sonnet 4.6

Rectangle {
    id: root

    property real position: 0
    property real length: 1 
    property bool isSeekable: false

    signal seekRequested(real newPosition)

    height: Style.sliderThickness
    radius: Style.radiusGrooteS
    color: Qt.darker(Style.borderKleur, 1.2)

    Rectangle {
        id: fill
        height: parent.height
        radius: parent.radius
        color: Style.accentKleur

        width: root.length > 0 ? (root.position / root.length) * root.width : 0

        Behavior on width {
            NumberAnimation { duration: Style.fastRepeatTimer; easing.type: Easing.OutQuad }
        }
    }

    TapHandler {
        enabled: root.isSeekable
        onTapped: (eventPoint) => {
            if (root.length > 0) {
                let clickPercentage = eventPoint.position.x / root.width;
                root.seekRequested(clickPercentage * root.length);
            }
        }
    }
}