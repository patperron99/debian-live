# debian-live

Image ISO live Debian Trixie minimale pour bootstrapper une installation Debian depuis un TTY.

## Dépendances

Hôte Debian ou Ubuntu requis :

```bash
sudo apt install live-build
```

## Build

```bash
bash build.sh
```

Produit `live-image-amd64.hybrid.iso` dans le répertoire courant.

## Flash USB

```bash
sudo dd if=live-image-amd64.hybrid.iso of=/dev/sdX bs=4M status=progress && sync
```

Remplacer `/dev/sdX` par le périphérique USB cible (vérifier avec `lsblk`).

## Au boot

- Login automatique en root
- Le motd affiche les deux commandes disponibles
- Lancer `live-install.sh` pour démarrer le bootstrap

## Personnalisation

Modifier `REPO_URL` dans `config/includes.chroot/usr/local/bin/live-install.sh` avant le build :

```bash
REPO_URL="https://github.com/VOTRE_USER/debian-setup.git"
```

## Structure

```
debian-live/
├── README.md
├── build.sh                          # wrapper: lb clean && lb build
├── auto/
│   └── config                        # lb config flags
└── config/
    ├── package-lists/
    │   └── base.list.chroot
    └── includes.chroot/
        ├── etc/
        │   └── motd
        └── usr/local/bin/
            ├── live-wifi.sh
            └── live-install.sh
```
