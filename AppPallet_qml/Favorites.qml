pragma Singleton
import QtQuick

QtObject {
    // Vul hier je favoriete app-IDs in (uit /usr/share/applications/*.desktop)
    readonly property var apps: [
        "firefox",
        "org.gnome.Nautilus",
        "code",
        "discord",
        "spotify",
        "kitty",
        "obsidian",
        "gimp",
        "vlc",
        "steam",
        "thunderbird",
        "libreoffice-writer",
        "org.kde.dolphin",
        "blender",
        "inkscape",
        "pavucontrol"
    ]
}