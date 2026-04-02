import QtQuick
import "../" // Voor toegang tot Style

Item {
    id: root
    property url artUrl: ""
    property real size: 40 // Standaard grootte

    width: size
    height: size

    Rectangle {
        anchors.fill: parent
        radius: Style.radiusGrooteM
        color: "#22ffffff" // Donkere achtergrond als er geen plaatje is
        clip: true
        
        border {
            color: Style.borderKleur
            width: Style.borderSize
        }

        // De daadwerkelijke Album Art
        Image {
            id: albumImage
            anchors.fill: parent
            source: root.artUrl != "" ? root.artUrl : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true // Voorkomt dat je UI bevriest bij grote plaatjes
            opacity: status === Image.Ready ? 1 : 0

            Behavior on opacity { NumberAnimation { duration: 300 } }
        }

        // Fallback icoon (muzieknoot) als er geen plaatje is
        Text {
            anchors.centerIn: parent
            text: "♪"
            font.pixelSize: root.size * 0.5
            color: Style.textKleur
            visible: albumImage.status !== Image.Ready
            opacity: 0.5
        }
    }
}