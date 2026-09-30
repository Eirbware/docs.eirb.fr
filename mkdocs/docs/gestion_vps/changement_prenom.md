# Changement de prénom

Lorsqu'un⋅e étudiant⋅e change de prénom d'usage, son adresse mail sera mise à jour. Pour lui permettre de continuer à se connecter, l'admin keycloak doit manuellement mettre à jour plusieurs champs.

## Accès à l'interface

Connectez-vous au compte d'Eirbware dans l'interface web de keycloak. Ensuite, sous "Manage", cliquez sur "Users". Utilisez la fonction "Search user" pour trouver l'étudiant⋅e en fonction de son CAS.

## Infos utilisateur

Bien que pas complètement nécessaire, il est préférable de changer ces champs dans l'onglet "Details":

- `Email`: Nouvelle adresse mail par défaut attribuée par l'établissement
- `First name`: Prénom d'usage de l'étudiant⋅e

!!!warning

    Ne pas changer le CAS associé si l'établissement ne le fait pas. À l'heure de la rédaction de cette doc, l'établissement refuse de changer le CAS des étudiant⋅e⋅s. On va éviter les problèmes.

!!!info

    Vous pouvez cependant changer le champ `First name` même avant le changement côté établissement, cela n'a pas d'impact sur le flux d'authentification. Le changement sera répercuté sur certains site, par exemple tind'eirb.

## Compte lié

Pour permettre aux étudiant⋅e⋅s de s'authentifier via le CAS, on utilise la fédération via SAML-Shibboleth. Ce protocole est configuré de sorte que l'étudiant⋅e est identifié⋅e par son adresse mail académique. Lors du changement, le CAS va renvoyer la nouvelle adresse, mais keycloak attendra toujours l'ancienne. Voyant que l'email est inconnue, keycloak va tenter de créer un nouveau compte, puis planter car il existe déjà un compte avec le même `user_id` (UUID invisible dans l'interface web).

Pour mettre à jour l'adresse mail:

- Aller dans l'onglet "Identity provider links"
- Faire attention à quel champ contient des caractères en majuscule. Actuellement, le champ `User ID` a l'adresse avec une majuscule au prénom et au nom, et le champ `Username` a la même adresse sans majuscule.
- Sur la ligne "Saml-shibboleth", cliquer sur "Unlink account"
- Plus bas, sous "Available identity providers", retrouver la ligne "Saml-shibboleth", puis cliquer sur "Link account"
- Remplir les champs respectant le schéma de lettres majuscules/minuscules que avant de supprimer le lien. Par exemple:
    - `User ID`: `Prenom.Nom@bordeaux-inp.fr`
    - `Username`: `prenom.nom@bordeaux-inp.fr`
- Valider

## Annexe: wiki

Sur le wiki, les utilisateurices sont nommés par leur CAS, mais cela n'a pas d'impact sur l'authentification. Ainsi, il est tout à fait possible de renommer un compte wiki pour correspondre au prénom d'usage.

Nous allons utiliser comme exemple "Alex Dupont" (adupont) → "Sam Dupont". Sam a déjà utilisé le wiki et son nom d'utilisateurice est "Adupont". Nous allons le changer en "Sdupont1".

!!!warning
    On va attribuer un nom d'utilisateurice basé sur identifiant unique. Or, nous ne pouvons pas réserver cet identifiant auprès de l'établissement, il est donc tout à fait possible que l'identifiant désiré (`Sdupont`) existe déjà, ou soit attribué plus tard tard à un⋅e autre personne. Pour éviter les conflits, nous allons ajouter un chiffre à la fin du nouvel identifiant. L'établissement ajoute toujours 3 chiffres (par exemple `Sdupont001` si `Sdupont` existe déjà), donc en utilisant un seul chiffre (`Sdupont1`), on minimise les risques.

- Sur le VPS, connectez vous au compte wiki: `sudo su www-wiki -`
- Ouvrez une session bash dans le conteneur mediawiki: `docker exec -it mediawiki bash`
- Aller dans le dossier des scripts: `cd maintenance`
- Changer le nom d'utilisateurice: `php run.php renameUser.php Adupont Sdupont1`
