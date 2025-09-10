# Accès au `VPN`

Certains outils d'administration sont installés sur le serveur, pour des
raisons de **sécurité**, ces outils **ne sont pas accessibles par internet**.

Parmi ces outils, **seul Portainer** vous concerne.

!!! warning "Accès à `*.vpn.eirb.fr`"

    L'accès à ces noms de domaines se fait **uniquement via le `VPN`**, et vous
    devrez utiliser le `DNS` qui est sur ce `VPN`, vérifiez que le
    [`DoH`](https://en.wikipedia.org/wiki/DNS_over_HTTPS) n'est pas activé sur
    votre navigateur.

## Demander un accès

De la même façon que pour l'accès `SFTP`, il vous faut contacter un membre
d'Eirbware, voici quelques techniques :

* Le contacter directement sur Telegram si vous en connaissez un
* Envoyer un message sur le groupe [Discussion d'Eirbware](https://telegram.eirb.fr) sur Telegram
* Envoyer un mail à [eirbware@enseirb-matmeca.fr](mailto:eirbware@enseirb-matmeca.fr)

On vous transmettra à l'issue de cette demande un fichier `wg_eirb.conf` qui
est un fichier de configuration pour `wireguard`.

## Installer un logiciel pour se connecter

!!! note "Sous Linux"

    Il est conseillé d'utiliser `NetworkManager` pour gérer la connexion VPN
    sous Linux, le script servant de client officiel de `wireguard` sous Linux
    est `wg-quick`, cependant, il [peut y avoir des conflits entre ce script et `NetworkManager`](https://bbs.archlinux.org/viewtopic.php?id=281344).

Allez sur la [page de téléchargement des clients pour `wireguard`](https://www.wireguard.com/install/), et installez celui pour votre système d'exploitation

### Se connecter sous linux

Dans un terminal, exécutez la commande suivante afin d'importer la
configuration `wireguard` dans `NetworkManager` :

```sh title="Commande pour importer la configuration wireguard dans NetworkManager"
nmcli connection import type wireguard file "<CHEMIN VERS LE FICHIER wg_eirb.conf>"
```

Puis, exécutez les commande suivante :

```sh title="Commande pour désactiver la connexion automatique au VPN"
nmcli connection modify wg_eirb connection.autoconnect no
nmcli connection down wg_eirb
```

À partir de là, vous pouvez vous connecter en exécutant :

```sh title="Commande pour se connecter au VPN"
nmcli connection up wg_eirb
```

et pour vous déconnecter :

```sh title="Commande pour se déconnecter du VPN"
nmcli connection down wg_eirb
```

### Se connecter sous Windows

jsp comment faire mdr
