Rectangle {
        id: openApps
        anchors {
            top: searchContainer.bottom
            topMargin: Style.uiMarginsM
            left: parent.left
            right: parent.right
        }
            
        height: 197.5
        color: Style.popupAchtergrondKleur
        radius: Style.radiusGrooteM

        border {
            color: Style.borderKleur
            width: Style.borderSize
        }

        GridView {
            anchors.fill: parent
            anchors.margins: Style.uiMarginsS
            cellWidth: 70
            cellHeight: 90
            clip: true

            model: ToplevelManager.toplevels.values

            delegate: Item {
                width: 70
                height: 90

                required property var modelData

                Rectangle {
                    anchors.centerIn: parent
                    width: 50
                    height: 50
                    radius: Style.radiusGrooteS
                    color: Style.accentKleur

                    Image {
                        anchors.fill: parent
                        anchors.margins: 6
                        source: {
                            var entry = DesktopEntries.byId(modelData.appId)
                            return entry ? "image://icon/" + entry.icon : ""
                        }
                    }
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.title
                    color: "white"
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.activate()
                }
            }
        }
    }

    // --- Onderste vak: Recente apps ---
    Rectangle {
        id: appOpener

        anchors {
            top: openApps.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: Style.uiMarginsM
        }

        height: 197.5
        color: Style.popupAchtergrondKleur
        radius: Style.radiusGrooteM

        border {
            color: Style.borderKleur
            width: Style.borderSize
        }

        GridView {
            anchors.fill: parent
            anchors.margins: Style.uiMarginsS
            cellWidth: 70
            cellHeight: 90
            clip: true

            model: {
                var ids = appletWindow.recentIds.length > 0
                    ? appletWindow.recentIds
                    : ["firefox", "code", "kitty", "discord",
                    "spotify", "obsidian", "gimp", "vlc",
                    "steam", "thunderbird", "org.gnome.Nautilus",
                    "libreoffice-writer", "blender", "inkscape",
                    "pavucontrol", "org.kde.dolphin"]

                return ids
                    .map(id => DesktopEntries.byId(id))
                    .filter(e => e !== null)
            }


            delegate: Item {
                width: 70
                height: 90

                required property var modelData

                Rectangle {
                    anchors.centerIn: parent
                    width: 50
                    height: 50
                    radius: Style.radiusGrooteS
                    color: Style.accentKleur

                    Image {
                        anchors.fill: parent
                        anchors.margins: 6
                        source: "image://icon/" + modelData.icon
                    }
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.name
                    color: "white"
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.execute()
                }
            }
        }
    }


                    Rectangle {
                    anchors.centerIn: parent
                    width: 60
                    height: 60
                    radius: Style.radiusGrooteS
                    color: "transparent"

                    Image {
                        anchors.fill: parent
                        anchors.margins: Style.uiMarginsS
                        source: "image://icon/" + modelData.icon
                    }
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: modelData.name
                    color: Style.textKleur
                    font.pixelSize: Style.fontGrootteM
                    elide: Text.ElideRight
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }