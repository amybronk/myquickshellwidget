import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Window
import "../"

PopupWindow {
    id: shutdownConfirm
    visible: true
    
    color: "transparent"

    implicitHeight: 80
    implicitWidth: 190

    anchor {
        rect.x: (screen.width - width) / 2
        rect.y: (screen.height - height) / 2
    }

    Process {
        id: shutdownProcess
        command: ["bash", "-c", "shutdown now"]
    }

    Rectangle {
        id: rootui

        anchors.fill: parent
        color: Style.popupAchtergrondKleur
        radius: Style.radiusGrooteM

        border {
            color: Style.borderKleur
            width: Style.borderSize
        }

        Rectangle {
            anchors {
                bottom: parent.bottom
                left: parent.left

                bottomMargin: Style.uiMarginsL
                leftMargin: Style.uiMarginsL
            }

            width: 80
            height: Style.barHoogte

            border {
                color: Style.borderKleur
                width: Style.borderSize
            }

            Text {
                anchors.centerIn:parent

                text: "yes"

                color: Style.textKleur2

                font {
                    pixelSize: Style.fontGrootteL
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    shutdownProcess.running = true
                }
            }
        }

        Rectangle {
            anchors {
                bottom: parent.bottom
                right: parent.right

                bottomMargin: Style.uiMarginsL
                rightMargin: Style.uiMarginsL
            }

            width: 80
            height: Style.barHoogte

            border {
                color: Style.borderKleur
                width: Style.borderSize
            }

            Text {
                anchors.centerIn:parent

                text: "no"

                color: Style.textKleur2

                font {
                    pixelSize: Style.fontGrootteL
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    shutdownConfirmWindow.active = false
                }
            }
        }
    }
}