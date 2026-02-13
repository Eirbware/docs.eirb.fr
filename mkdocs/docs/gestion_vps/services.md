# Gestion des services

Cette section se concentre sur :

* La création d'un nouveau service
* La désactivation d'un service
* L'archivage d'un service

!!!info "Comment supprimer un service ?"

    Volontairement, on **ne peut pas supprimer** un service, le but étant de ne
    pas perdre de données.

    Selon les contraintes de stockages actuelles, il n'y a pas de problème lié
    à ce système.

## Création d'un nouveau service

Afin de créer un service, il suffit d'utiliser la commande `new_site`, dont le fonctionnement est détaillé avec l'option `-h`

## Désactivation d'un service 

Pour pouvoir désactiver un service, il faut utiliser la commande `down_site` de la manière suivante: 

```title="Désactivation d'un site"
sudo down_site www-<nom_site>
```

Pour le réactiver, il suffit d'utiliser la même commande avec l'option `-r`

!!!info 
    Il existe aussi la commande `disable_site` qui elle rend le site inaccessible sans l'arrêter.

## Sites statiques 

Chaque service ayant son propre démon docker, qui consomme une quantité non négligeable de mémoire, la multiplication des sites (notamment ceux des listes) font que le serveur sera rapidement saturé en mémoire.

Pour éviter cela, un service spécial a été créé, qui permet de réunir les sites statiques sous un seul et même démon docker, tout en laissant la possibilités au respos web de pouvoir les modifier avec `sftp`.

La commande a utiliser pour mettre un service dans cette catégorie est:
```title="Conversion d'un site en site statique"
sudo make_site_static www-<nom-site>
```

Il est possible d'annuler l'opération avec l'option `-r`

!!!warning "Tous les services ne peuvent pas être statiques"
    Seuls les services respecant respectant la structure par défaut (celle crée par `new_site`) peuvent être convertis en sites statiques, exécuter la commande sur un service n'ayant pas cette structure le laissera dans un état non défini

Cette commande copie tous les dossiers du site statique donné dans un dossier spécial du service `www-listeold`, sauf le dossier `nginx/www` et le fichier `nginx/php/auth-config.php`, pour lesquels on créera un lien symbolique.

Ceci permet de lancer tous les conteneurs sur `www-listeold`, économisant beaucoup de démons docker tout en permettant aux mainteneurs des sites de modifier celui-ci.

Afin de s'assurer que l'utilisateur `www-listeold` puisse utiliser les fichiers, on change le propriétaire des dossiers copiés, et on s'assure qu'à tout moment les fichiers des dossiers liés puissent être lus par `www-listeold` avec le service `keep_authorisations_on_static_sites`.

## Obfuscation d'un service

Il peut arriver (notamment pour les sites de liste) qu'il faille donner accès à un site avant que sont nom de domaine soit public. 
Pour cela, il est possible d'obfusquer (ie remplacer l'url par une url aléatoire) un service avec la commande suivante:

```title="Obfuscation d'un site"
sudo obfuscate_site <nom-site>
```

Il est possible d'annuler l'opération avec l'option `-r`

De plus, il est possible de planifier la déobfuscation avec l'option `-t` suivi d'une date au format `YYYYMMddhhmm`, par exemple
```title="Exemple d'obfuscation"
sudo obfuscate_site -t 202509191235 www-pix
```
Permet d'obfusquer le site pix.eirb.fr jusqu'au 19 septembre 2025 à 12h35
