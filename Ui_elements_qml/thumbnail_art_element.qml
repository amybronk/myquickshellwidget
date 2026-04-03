import QtQuick
import "../"

// writen by claud sonnet 4.6

Item {
    id: root
    property url artUrl: ""
    property real size: 40

    width: size
    height: size

    Rectangle {
        anchors.fill: parent
        radius: Style.radiusGrooteM
        color: "#22ffffff"
        clip: true
        
        border {
            color: Style.borderKleur
            width: Style.borderSize
        }

        Image {
            id: albumImage
            anchors.fill: parent
            source: root.artUrl != "" ? root.artUrl : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            opacity: status === Image.Ready ? 1 : 0

            Behavior on opacity { NumberAnimation { duration: 300 } }
        }

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