pragma Singleton
import QtQuick

//OpenApps.qml

QtObject {
    property var list: []

    function add(appData) {
        var key = typeof appData === "string" ? appData : appData.desktop + "|" + (appData.action || "")
        if (!list.some(a => (typeof a === "string" ? a : a.desktop + "|" + (a.action || "")) === key))
            list = [...list, appData]
    }
}