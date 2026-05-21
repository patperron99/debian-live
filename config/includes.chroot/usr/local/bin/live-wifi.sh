#!/bin/bash
set -e

echo "══════════════════════════════════════════"
echo "  Connexion WiFi"
echo "══════════════════════════════════════════"
echo

echo "Recherche des réseaux disponibles..."
nmcli device wifi list

echo
read -rp "Nom du réseau (SSID) : " SSID
read -rsp "Mot de passe : " PASS
echo

echo
echo "Connexion à « $SSID »..."
if ! nmcli device wifi connect "$SSID" password "$PASS"; then
    echo "Erreur : impossible de se connecter à « $SSID »." >&2
    exit 1
fi

echo "Vérification de la connectivité..."
if ! ping -c1 -W3 8.8.8.8 &>/dev/null; then
    echo "Erreur : connexion établie mais pas d'accès Internet." >&2
    exit 1
fi

echo "Connexion réussie."
exit 0
