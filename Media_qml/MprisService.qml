pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    property var players: Mpris.players.values ?? []
    property MprisPlayer activePlayer: _resolveActive()
    property int manualIndex: -1

    Connections {
        target: Mpris.players
        function onObjectInsertedPost() {
            root.players = Mpris.players.values
            activePlayer = _resolveActive()
        }
        function onObjectRemovedPost() {
            root.players = Mpris.players.values
            if (manualIndex >= root.players.length) manualIndex = -1
            activePlayer = _resolveActive()
        }
        function onValuesChanged() {
            root.players = Mpris.players.values
            activePlayer = _resolveActive()
        }
    }

    function _resolveActive(): MprisPlayer {
        const list = root.players
        if (!list || list.length === 0) return null
        if (manualIndex >= 0 && manualIndex < list.length) {
            return list[manualIndex]
        }
        for (let i = 0; i < list.length; i++) {
            if (list[i].playbackState === MprisPlaybackState.Playing) {
                return list[i]
            }
        }
        return list[0]
    }

    function selectPlayer(index: int) {
        manualIndex = index
        activePlayer = _resolveActive()
    }

    function cyclePlayer() {
        if (players.length === 0) return
        const currentIdx = players.indexOf(activePlayer)
        manualIndex = (currentIdx + 1) % players.length
        activePlayer = _resolveActive()
    }

    function playPause() {
        if (activePlayer) activePlayer.togglePlaying()
    }

    function next() {
        if (activePlayer && activePlayer.canGoNext) activePlayer.next()
    }

    function previous() {
        if (activePlayer && activePlayer.canGoPrevious) activePlayer.previous()
    }

    function seekTo(positionMs: real) {
        if (activePlayer && activePlayer.canSeek) {
            activePlayer.position = positionMs
        }
    }
}