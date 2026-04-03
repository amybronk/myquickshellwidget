pragma Singleton
import QtQuick

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
    property int barHoogte: 40
    property int borderSize: 2

    property int uiMarginsS: 2
    property int uiMarginsM: 5
    property int uiMarginsL: 10

    property int fontGrootteS: 8
    property int fontGrootteM: 10
    property int fontGrootteL: 14

    //property int iconGrooteS: 12
    property int iconGrooteM: 18
    //property int iconGrooteL: 22

    property int radiusGrooteS: 4
    property int radiusGrooteM: 10
    //property int radiusGrooteL: 14

    property int exitTimer: 350

    property int fastRepeatTimer: 500
    property int slowRepeatTimer: 2000

    property int sliderThickness: 8

}