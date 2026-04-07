pragma Singleton
import QtQuick

// you can find the list of Favorited apps in Favorites.qml at ~/.config/quickshell/AppPallet_qml/Favorites.qml

// A path to all filles with short explanations for what thay do can be found at ~/.config/quickshell/notes/dir.md

Item {
    // Kleuren
    readonly property color achtergrondKleur: '#5d2b2b2b'
    readonly property color popupAchtergrondKleur: '#eb2b2b2b'
    readonly property color borderKleur: '#daaa00a4'
    readonly property color accentKleur: '#520050'
    readonly property color textKleur: '#ffffffff'
    readonly property color negatiefTextKleur: '#ff000000'

    readonly property color actiefWerkbaldKleur: '#ff0000'
    readonly property color volleWerkbaldKleur: '#3d0000'
    readonly property color legeWerkbaldKleur: '#ffffff'

    
    // Afmetingen
    readonly property int barHoogte: 40
    readonly property int borderSize: 2

    readonly property int uiMarginsS: 2
    readonly property int uiMarginsM: 5
    readonly property int uiMarginsL: 10
    readonly property int uiMarginsG: 15

    readonly property int fontGrootteS: 8
    readonly property int fontGrootteM: 10
    readonly property int fontGrootteL: 14
    readonly property int fontGrootteG: 22

    //readonly property int iconGrooteS: 12
    readonly property int iconGrooteM: 18
    //readonly property int iconGrooteL: 22

    readonly property int radiusGrooteS: 4
    readonly property int radiusGrooteM: 10
    //readonly property int radiusGrooteL: 14
    readonly property int exitTimer: 350

    readonly property int fastRepeatTimer: 500
    readonly property int slowRepeatTimer: 2000

    readonly property int sliderThickness: 8

    readonly property int appletAppAmount: 2
    readonly property int appletDrawrAmount: 2
}