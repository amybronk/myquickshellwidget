pragma Singleton
import QtQuick
import Quickshell.Io
import QtCore

QtObject {
    id: root

    property var recentList: []
    property var sessionList: []
    property int maxRecent: 16
    property string filePath: StandardPaths.writableLocation(StandardPaths.HomeLocation)
                              + "/.config/quickshell/recent_apps.json"

    Component.onCompleted: _readProc.running = true

    // ← property var, niet los
    property var _readProc: Process {
        running: false
        command: ["bash", "-c", "cat \"$1\" 2>/dev/null || echo '{}'", "--", root.filePath]
        stdout: SplitParser {
            onRead: data => {
                try {
                    var obj = JSON.parse(data.trim())
                    root.recentList  = obj.recent  || []
                    root.sessionList = obj.session || []
                } catch(e) {}
            }
        }
    }

    property var _writeProc: Process {
        running: false
    }

    function recordApp(appData) {
        var key = _key(appData)
        var lijst = recentList.filter(a => _key(a) !== key)
        lijst.unshift(appData)
        if (lijst.length > maxRecent) lijst = lijst.slice(0, maxRecent)
        recentList = lijst
        _save()
    }

    function saveSession(openApps) {
        sessionList = openApps
        _save()
    }

    function _key(appData) {
        return typeof appData === "string"
            ? appData
            : appData.desktop + "|" + (appData.action || "")
    }

    function _save() {
        var json = JSON.stringify({ recent: recentList, session: sessionList })
        _writeProc.command = ["bash", "-c",
            "mkdir -p \"$(dirname \"$2\")\" && printf '%s' \"$1\" > \"$2\"",
            "--", json, filePath
        ]
        _writeProc.running = false
        _writeProc.running = true
    }
}