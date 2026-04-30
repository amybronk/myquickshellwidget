pragma Singleton
import QtCore
import QtQuick

Item {
    id: root

    // Deze map had je al gedefinieerd in je originele code!
    readonly property string rootConfigDir: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0].toString().replace("file://", "") + "/.config/quickshell/"

    // De Settings module slaat de waarden op de hardeschijf op
    Settings {
        id: styleSettings
        category: "Theme"
        // Geen fileName meer nodig, Qt kiest nu automatisch:
        // ~/.config/UserConfig/Quickshell.conf
    }

    function getSetting(key, defaultValue) {
        return styleSettings.value(key, defaultValue)
    }

    function setSetting(key, value) {
        root[key] = value
        styleSettings.setValue(key, value)
    }

    // --- COLOUR ---
    property color achtergrondKleur: getSetting("achtergrondKleur", '#d31f1f1f')
    property color popupAchtergrondKleur: getSetting("popupAchtergrondKleur", '#eb2b2b2b')
    property color borderKleur: getSetting("borderKleur", '#daaa00a4')
    property color accentKleur: getSetting("accentKleur", '#520050')

    property color textKleur: getSetting("textKleur", '#ffffffff')
    property color textColourLink: getSetting("textColourLink", '#ff00d0')
    property color negatiefTextKleur: getSetting("negatiefTextKleur", '#ff000000')

    property color actiefWerkbaldKleur: getSetting("actiefWerkbaldKleur", '#ff0000')
    property color volleWerkbaldKleur: getSetting("volleWerkbaldKleur", '#3d0000')
    property color legeWerkbaldKleur: getSetting("legeWerkbaldKleur", '#ffffff')

    property color colourPink: getSetting("colourPink", '#000000')

    property color colourPowerButton: getSetting("colourPowerButton", '#ff6cf5')
    property color colourAppPalet: getSetting("colourAppPalet", '#70e2ff')
    property color colourSettingsButton: getSetting("colourSettingsButton", '#86ffef')

    // --- INT ---
    property int barHoogte: getSetting("barHoogte", 35)
    property int barbuttonlengt: getSetting("barbuttonlengt", 60)
    property int barBorderSize: getSetting("barBorderSize", 0)
    property int borderSize: getSetting("borderSize", 2)
    property int topBarMargins: getSetting("topBarMargins", 2)
    property int bottomBarMargins: getSetting("bottomBarMargins", 4)

    property int uiMarginsS: getSetting("uiMarginsS", 2)
    property int uiMarginsM: getSetting("uiMarginsM", 5)
    property int uiMarginsL: getSetting("uiMarginsL", 10)
    property int uiMarginsG: getSetting("uiMarginsG", 15)

    property int fontGrootteS: getSetting("fontGrootteS", 8)
    property int fontGrootteM: getSetting("fontGrootteM", 10)
    property int fontGrootteL: getSetting("fontGrootteL", 14)
    property int fontGrootteG: getSetting("fontGrootteG", 22)
    property int fontKlokgrote: getSetting("fontKlokgrote", ((barHoogte - (topBarMargins + bottomBarMargins)) / 2))

    property int iconGrooteS: getSetting("iconGrooteS", 12)
    property int iconGrooteM: getSetting("iconGrooteM", 18)
    property int iconGrooteL: getSetting("iconGrooteL", 22)

    property int radiusGrooteS: getSetting("radiusGrooteS", 4)
    property int radiusGrooteM: getSetting("radiusGrooteM", 10)
    property int radiusGrooteL: getSetting("radiusGrooteL", 14)
    property int exitTimer: getSetting("exitTimer", 350)

    property int fastRepeatTimer: getSetting("fastRepeatTimer", 500)
    property int slowRepeatTimer: getSetting("slowRepeatTimer", 2000)

    property int sliderThickness: getSetting("sliderThickness", 8)

    property int appletAppAmount: getSetting("appletAppAmount", 2)
    property int appletDrawrAmount: getSetting("appletDrawrAmount", 2)

    // --- directorys ---
    readonly property string saveState: "$HOME/.config/quickshell/SaveStates_txt/"
    readonly property string quickshellDir: "$HOME/.config/quickshell/"
    readonly property string saveStatDir: "$HOME/.config/quickshell/SaveStates_txt/"

    readonly property var editableKeys: [
        // --- COLOUR ---
        "achtergrondKleur", "popupAchtergrondKleur", "borderKleur", "accentKleur", "textKleur", "textColourLink", 
        "negatiefTextKleur", "actiefWerkbaldKleur", "volleWerkbaldKleur", "legeWerkbaldKleur", "colourPink", 
        "colourPowerButton", "colourAppPalet", "colourSettingsButton", 

        // --- INT ---
        "barHoogte", "barbuttonlengt", "barBorderSize", "borderSize","topBarMargins", "bottomBarMargins", 
        "uiMarginsS", "uiMarginsM", "uiMarginsL", "uiMarginsG", "fontGrootteS", "fontGrootteM", "fontGrootteL", 
        "fontGrootteG", "iconGrooteS", "iconGrooteM", "iconGrooteL", "radiusGrooteS", "radiusGrooteM", 
        "radiusGrooteL", "exitTimer", "fastRepeatTimer", "slowRepeatTimer", "sliderThickness", "appletAppAmount", 
        "appletDrawrAmount"
    ]
} 