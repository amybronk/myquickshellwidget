pragma Singleton
import QtCore
import QtQuick

Item {
    id: root

    readonly property string rootConfigDir: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0].toString().replace("file://", "") + "/.config/quickshell/"

    Settings {
        id: styleSettings
        category: "Theme"
        // ~/.config/UserConfig/Quickshell.conf
    }

    property var settingsWinInstance: null

    function openSettings() {
        // 1. Check of hij al bestaat
        if (settingsWinInstance !== null && typeof settingsWinInstance !== "undefined" && settingsWinInstance.toString() !== "null") {
            try {
                settingsWinInstance.raise()
                settingsWinInstance.requestActivate()
                return // Stop hier, we zijn klaar
            } catch (e) {
                settingsWinInstance = null // Object was corrupt, reset en ga door naar aanmaken
            }
        }

        // 2. Probeer het component te laden
        // Gebruik het volledige pad vanaf de root om fouten te voorkomen
        let component = Qt.createComponent(Qt.resolvedUrl("Settings_qml/SettingsMenu.qml"))
        
        if (component.status === Component.Ready) {
            let obj = component.createObject(null)
            
            if (obj !== null) {
                settingsWinInstance = obj
                // Gebruik de veilige manier van verbinden
                settingsWinInstance.destroyed.connect(function() {
                    settingsWinInstance = null
                })
            } else {
                // DIT IS BELANGRIJK: Dit vertelt ons waarom createObject faalt
                console.error("Fout: SettingsMenu kon niet worden aangemaakt. Error:", component.errorString())
            }
        } else if (component.status === Component.Error) {
            console.error("Fout bij laden SettingsMenu component:", component.errorString())
        }
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