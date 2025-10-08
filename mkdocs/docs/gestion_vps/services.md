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

## Archivage d'un service

Chaque service ayant son propre démon docker, qui consomme une quantité non négligeable de mémoire, la multiplication des sites (notamment ceux des listes) font que le serveur sera rapidement saturé en mémoire.

Pour éviter cela, un service d'archive a été créé, dans lequel tous les sites qui n'ont pas vocation à être modifiés à l'avenir (tels que les sites des anciennes listes) sont hébergés.

La commande a utiliser pour archiver un site est 
```title="Archivage d'un site"
sudo archive_site www-<nom-site>
```

Il est possible de désarchiver un site avec l'option `-r`

!!!warning "Ne pas oublier d'archiver les sites de listes"
    
    Afin de préserver une consommation de mémoire raisonnable, il est très important une fois les campagnes passées d'archiver les sites de liste

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
