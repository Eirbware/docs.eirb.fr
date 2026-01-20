# La CI/CD à Eirbware

Afin de faciliter la maintenance ainsi que le déploiement des services proposés par Eirbware ainsi que les sites internets des clubs/assos, nous avons mis en place des méthodes de déploiement automatique.

Ces méthodes reposent sur des github actions, qui permettent à chaque push/merge dans la branche principale d'un repo d'exécuter des commandes.

Celles dont nous nous servont sont définies dans [ce dépôt](https://github.com/Eirbware/.github/), comme des actions réutilisables (dans le dossier `.github/workflows`).

Ainsi, pour utiliser une de nos actions, on peut définir un job ayant cette forme:
```yaml
  build-and-push:
    permissions:
      id-token: write 
    uses: Eirbware/.github/.github/workflows/build-and-publish.yml@master
    with:
      file: "./Dockerfile"
      image_name: ${{ github.repository }}
    secrets: 
      registry_username: ${{ secrets.registry_username }}
      registry_api_key: ${{ secrets.registry_api_key }}
```

Il y 2 types d'entrées à ces jobs:

- Les paramètres, sous l'option `with`
- Les secrets, sous l'option `secrets`, qui contient les données sensibles dont le job a besoin

!!!warning 
    Il est vivement conseillé d'utiliser les jobs de cette façon pour déployer sur notre serveur, ainsi si un changement survient il n'y aura pas de modification à faire sur les dépôts utilsant l'action.

!!!info 
    Pour définir les secrets et les utiliser comme vu au dessus, il faut aller dans les options du dépôt, dans secrets and variables et dans actions

!!!info 
    Pour les services étant sous l'organisation github d'Eirbware, on peut aussi utiliser `secrets: inherit`
