#!/bin/bash

# ═══════════════════════════════════════════════════════════════
#  QuickShell installatie script
#  repo: https://github.com/amybronk/myquickshellwidget.git
# ═══════════════════════════════════════════════════════════════

set -e  # stop bij een fout

REPO_URL="https://github.com/amybronk/myquickshellwidget.git"
CONFIG_DIR="$HOME/.config/quickshell"
TEMP_DIR="/tmp/quickshell-install"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   QuickShell installatie             ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── 1. packages installeren ──────────────────────────────────────
echo ">>> Packages installeren..."

# detecteer package manager
if command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm \
        hyprland \
        quickshell \
        qt5-graphicaleffects \
        qt6-declarative \
        git \
        libnotify
    echo "✓ Packages geïnstalleerd via pacman"
else
    echo "✗ Geen ondersteunde package manager gevonden (alleen pacman ondersteund)"
    exit 1
fi

# ── 2. repo clonen ───────────────────────────────────────────────
echo ""
echo ">>> Repo clonen..."

# verwijder oude temp als die er nog is
rm -rf "$TEMP_DIR"
git clone "$REPO_URL" "$TEMP_DIR"
echo "✓ Repo gecloned"

# ── 3. config map aanmaken ───────────────────────────────────────
echo ""
echo ">>> Bestanden kopiëren..."

mkdir -p "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR/Bar_qml"
mkdir -p "$CONFIG_DIR/Media_qml"
mkdir -p "$CONFIG_DIR/Klok_qml"
mkdir -p "$CONFIG_DIR/Ui_elements_qml"
mkdir -p "$CONFIG_DIR/AppPallet_qml"
mkdir -p "$CONFIG_DIR/powerwidgit_qml"
mkdir -p "$CONFIG_DIR/scripts"
mkdir -p "$CONFIG_DIR/SaveStates_txt"

# kopieer alles van de repo naar de config map
cp -r "$TEMP_DIR"/. "$CONFIG_DIR/"

echo "✓ Bestanden gekopieerd naar $CONFIG_DIR"

# ── 4. scripts uitvoerbaar maken ────────────────────────────────
echo ""
echo ">>> Scripts uitvoerbaar maken..."

# maak alle .sh bestanden uitvoerbaar
find "$CONFIG_DIR/scripts" -name "*.sh" -exec chmod +x {} \;
echo "✓ Scripts uitvoerbaar gemaakt"

# ── 5. sudoers regel voor shutdown ──────────────────────────────
echo ""
echo ">>> Sudoers instellen voor shutdown..."

SUDOERS_BESTAND="/etc/sudoers.d/quickshell-shutdown"

if [ ! -f "$SUDOERS_BESTAND" ]; then
    echo "$USER ALL=(ALL) NOPASSWD: /usr/sbin/shutdown" \
        | sudo tee "$SUDOERS_BESTAND" > /dev/null
    sudo chmod 440 "$SUDOERS_BESTAND"
    echo "✓ Sudoers regel toegevoegd"
else
    echo "✓ Sudoers regel bestaat al"
fi

# ── 6. init systeem detecteren ───────────────────────────────────
echo ""
echo ">>> Init systeem detecteren..."

if [ "$(cat /proc/1/comm)" = "systemd" ]; then
    INIT="systemd"
elif [ -f /run/openrc/softlevel ]; then
    INIT="openrc"
elif command -v runit &>/dev/null && [ -d /run/runit ]; then
    INIT="runit"
elif command -v s6-rc &>/dev/null && [ -d /run/s6 ]; then
    INIT="s6"
elif [ "$(cat /proc/1/comm)" = "dinit" ]; then
    INIT="dinit"
else
    INIT="sysvinit"
fi

# detecteer of loginctl beschikbaar is (ongeacht init systeem)
if command -v loginctl &>/dev/null; then
    HEEFT_LOGINCTL="true"
else
    HEEFT_LOGINCTL="false"
fi

echo "$INIT" > "$CONFIG_DIR/init-system"
echo "$HEEFT_LOGINCTL" > "$CONFIG_DIR/heeft-loginctl"
echo "✓ Init systeem gedetecteerd: $INIT"
echo "✓ loginctl beschikbaar: $HEEFT_LOGINCTL"

# ── 7. opruimen ──────────────────────────────────────────────────
echo ""
echo ">>> Opruimen..."
rm -rf "$TEMP_DIR"
echo "✓ Temp bestanden verwijderd"

# ── 8. klaar ─────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════╗"
echo "║   Installatie klaar!                 ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Start QuickShell met:"
echo "  qs"
echo ""
echo "Of voeg dit toe aan je Hyprland config:"
echo "  exec-once = qs"
echo ""