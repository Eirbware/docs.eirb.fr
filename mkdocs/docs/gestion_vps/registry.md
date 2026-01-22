# Registry et CI

Afin de pouvoir faire fonctionner la [CI](../ci/ci.md) d'Eirbware, un registry d'images docker est hébergé sur le serveur, à l'adresse [https://registry.eirb.fr](https://registry.eirb.fr).

Cette section a pour but de documenter la manière d'ajouter de nouvelles images et de nouveaux utilisateurs à ce registry, dans le cadre de la procédure expliquée [ici](../ci/docker.md).

## Ajouter un utilisateur

Lorsqu'un nouveau club/asso a besoin d'utiliser la CI, il faut lui créer un compte et lui donner accès au registry.

Pour cela, il faut dans un premier temps créer un utilisateur représentant l'asso sur Keycloak, accessible via [le vpn](https://vpn.eirb.fr). 
Cela est fait en allant dans Users->Add user, à partir de là il faut préciser à minima le Username et l'email.

Ensuite, il faut ajouter l'accès à l'utilisateur dans le fichier de configuration du registry, qui se trouve dans son home.

