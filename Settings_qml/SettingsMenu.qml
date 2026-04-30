import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../"

Window {
    id: settingsWin
    title: "Shell Settings"
    width: 450
    height: 600
    color: Style.achtergrondKleur
    visible: true

    property var _keepAlive: settingsWin

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: "Shell Configuratie"
            color: Style.textKleur
            font.pixelSize: Style.fontGrootteG
            font.bold: true
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                id: listContainer
                width: settingsWin.width - 60
                spacing: 10

                // Debug tekst: als je dit ziet, is de lijst in Style.qml leeg
                Text {
                    text: "Geen instellingen gevonden in Style.editableKeys"
                    color: "red"
                    visible: mainRepeater.count === 0
                }

                Repeater {
                    id: mainRepeater
                    // We wijzen het model expliciet toe aan de lijst in Style
                    model: Style.editableKeys

                    delegate: RowLayout {
                        width: listContainer.width
                        spacing: 10
                        
                        Text {
                            // modelData is de naam van de property (bijv. "achtergrondKleur")
                            text: modelData 
                            color: Style.textKleur2
                            Layout.fillWidth: true
                            font.pixelSize: Style.fontGrootteL
                        }

                        TextField {
                            // We halen de huidige waarde op uit Style via de naam
                            text: String(Style[modelData])
                            color: Style.textKleur
                            selectByMouse: true
                            
                            Layout.preferredWidth: 150

                            background: Rectangle {
                                color: Style.popupAchtergrondKleur
                                border.color: Style.accentKleur
                                border.width: 1
                                radius: 4
                            }

                            // Wanneer je op Enter drukt of ergens anders klikt
                            onEditingFinished: {
                                console.log("Aanpassen van " + modelData + " naar: " + text)
                                Style.setSetting(modelData, text)
                            }
                        }
                    }
                }
            }
        }

        Button {
            text: "Sluiten"
            Layout.alignment: Qt.AlignRight
            onClicked: settingsWin.close()
        }
    }
}