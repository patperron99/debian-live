#!/bin/bash
set -e

REPO_URL="https://github.com/PLACEHOLDER/debian-setup.git"
INSTALL_DIR="/root/debian-setup"

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
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

if [[ ! -f install.conf ]]; then
    echo "Création de install.conf depuis l'exemple..."
    cp install.conf.example install.conf
    sed -i 's/^INSTALL_TIMEZONE=.*/INSTALL_TIMEZONE=America\/Montreal/' install.conf
    sed -i 's/^INSTALL_LOCALE=.*/INSTALL_LOCALE=fr_CA.UTF-8/' install.conf
fi

echo
echo "Fichier de configuration : $INSTALL_DIR/install.conf"
echo "Veuillez le vérifier et l'adapter à votre environnement."
echo
read -rp "Ouvrir install.conf avec neovim maintenant ? [O/n] " EDIT_CHOICE
if [[ "${EDIT_CHOICE,,}" != "n" ]]; then
    nvim install.conf
fi

echo
read -rp "Lancer debian-install-fresh.sh ? [O/n] " CONFIRM
if [[ "${CONFIRM,,}" == "n" ]]; then
    echo "Installation annulée."
    exit 0
fi

echo "Démarrage de l'installation..."
bash debian-install-fresh.sh
