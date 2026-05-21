#!/bin/bash
set -e

REPO_URL="https://github.com/patperron99/debian-install-scripts.git"
BRANCH="sway"
INSTALL_DIR="$(pwd)/debian-setup" #"/root/debian-setup"

echo "══════════════════════════════════════════"
echo "  Debian Install Live — Bootstrap"
echo "══════════════════════════════════════════"
echo

echo "Vérification de la connectivité réseau..."
if ! ping -c1 -W3 8.8.8.8 &>/dev/null; then
    echo "Pas d'accès Internet détecté."
    read -rp "Lancer live-wifi.sh pour se connecter ? [O/n] " WIFI_CHOICE
    if [[ "${WIFI_CHOICE,,}" != "n" ]]; then
        live-wifi.sh
    else
        echo "Erreur : connexion Internet requise." >&2
        exit 1
    fi
fi

echo "Réseau OK."
echo

if [[ -d "$INSTALL_DIR" ]]; then
    echo "Le répertoire $INSTALL_DIR existe déjà, clone ignoré."
else
    echo "Clonage du dépôt $REPO_URL..."
    git clone -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

if [[ ! -f install.conf ]]; then
    cp install.conf.example install.conf
fi

echo "──────────────────────────────────────────"
echo "  Configuration de l'installation"
echo "──────────────────────────────────────────"
echo

echo "Disques disponibles :"
lsblk -d -o NAME,SIZE,MODEL --noheadings | grep -v '^loop' | sed 's/^/  /'
echo
read -rp "Disque cible (ex: sda, nvme0n1) : " DISK
while [[ -z "$DISK" || ! -b "/dev/$DISK" ]]; do
    echo "  → /dev/$DISK introuvable, réessayez."
    read -rp "Disque cible (ex: sda, nvme0n1) : " DISK
done

echo
read -rp "Fuseau horaire   (ex: America/Montreal, Europe/Paris) : " TIMEZONE
TIMEZONE="${TIMEZONE:-America/Montreal}"

echo
read -rp "Locale           (ex: en_US.UTF-8, fr_CA.UTF-8)       : " LOCALE
LOCALE="${LOCALE:-en_US.UTF-8}"

sed -i "s|^INSTALL_DISK=.*|INSTALL_DISK=/dev/$DISK|" install.conf
sed -i "s|^INSTALL_TIMEZONE=.*|INSTALL_TIMEZONE=$TIMEZONE|" install.conf
sed -i "s|^INSTALL_LOCALE=.*|INSTALL_LOCALE=$LOCALE|" install.conf

echo
echo "──────────────────────────────────────────"
echo "  Résumé"
echo "──────────────────────────────────────────"
echo "  Disque    : /dev/$DISK"
echo "  Fuseau    : $TIMEZONE"
echo "  Locale    : $LOCALE"
echo "──────────────────────────────────────────"
echo

read -rp "Lancer debian-install-fresh.sh ? [O/n] " CONFIRM
if [[ "${CONFIRM,,}" == "n" ]]; then
    echo "Installation annulée."
    exit 0
fi

echo "Démarrage de l'installation..."
bash debian-install-fresh.sh
