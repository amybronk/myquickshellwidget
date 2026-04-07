pragma Singleton
import QtQuick

QtObject {
    // grep "^Icon=" /usr/share/applications/blender.desktop | cut -d'=' -f2
    // "grep "^Icon=" /usr/share/applications/", fillenaam, " | cut -d'=' -f2"
    readonly property var apps: [
        "vivaldi-stable",                                           // default
        { desktop: "vivaldi-stable", action: "new-private-window" }, // private window
        "spotify",
        "discord",
        "org.freecad.FreeCAD",
        "org.kde.dolphin",
        "blender",
        "RapidRAW",
        "vscodium-wayland",
        "org.gnome.Nautilus",
        "code",
        "obsidian",
        "gimp",
        "vlc",
        { desktop: "steam", action: "Library" },                   // opens steam Library insted of default steam
        "thunderbird"
    ]
}