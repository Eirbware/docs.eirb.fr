# Comment implémenter Eirbconnect
## Introduction
Cette documentation a été écrite afin d'aider les développeurs à implémenter EirbConnect dans leurs productions.
Cette documentation explicitera : 
- L'utilisation de la librairie openid-client pour le protocole de communication, en JS.
- La gestion de la connexion.
- La gestion de la déconnexion.

## Prérequis
- La librairie *openid-client*.
- La librairie *dotenv* pour les variables d'environnement, afin de ne pas exposer les informations sensibles.
- Le CLIENT_SECRET et CLIENT_ID pour l'autorisation du protocole *OpenId*. Si vous ne les avez pas, contactez EirbWare.
- Un système de session. Celui-ci peut être implémenté de la manière que vous le souhaitez. Dans cette documentation, celle-ci sera faite à l'aide de *req.session*, supposée configurée au préalable. Pour tout autre fonctionnement, libre à vous de modifier ces lignes pour coller à votre projet.
- Un serveur local qui tourne sur le port 8080, ou un backend qui est sur la whitelist de EirbWare.

## Le fichier process.env
Votre fichier *process.env* doit au moins contenir les informations suivantes:

```
CLIENT_ID="VOTRE ID"
CLIENT_SECRET="VOTRE SECRET"
ISSUER="https://conncect.vpn.eirb.fr/realms/eirb"
PORT=8080
```

## Fonctionnement
Le protocole fonctionne en deux temps, une fonction *login*, qui fait une première requête au serveur de EirbWare. Une deuxième fonction *verifyLogin* qui permet de récupérer les informations de connexion que l'utilisateur a entrées.

## Le login 
Nous allons créer une route */login*, que le frontend doit rediriger lorsque besoin s'en sent (cela peut être après un fetch à un */api/me* afin de vérifier si l'utilisateur est loggué, à adapter en fonction de vos besoins).
```js
const { redirect_url, code_verifier, state} = await login(`https://VOTRE_BACKEND/auth/callback`);

    //Save in the session 
    req.session.code_verifier = code_verifier;
    req.session.state = state;

    //Redirection of the user 
    res.redirect(redirect_url);
```

Ici, le code va appeller notre fonction login, et cette fonction retourne *redirect_url*, *code_verifier*, *state*, des informations indispensables pour la suite du protocole.
On sauvegarde dans la session ces informations, on redirige l'utilisateur dans l'url retourné par la première étape du protocole du serveur de EirbWare. L'utilisateur va être redirigé vers la page de connexion.

La fonction *login* est ci-dessous, elle peut être mise dans un fichier service.
```js
export async function login(redirectUrl: string) {
  let server!: URL // Authorization Server's Issuer Identifier
  let clientId!: string // Client identifier at the Authorization Server
  let clientSecret!: string // Client Secret

  server = new URL(process.env.ISSUER);
  clientId = process.env.CLIENT_ID;
  clientSecret = process.env.CLIENT_SECRET

  let config: client.Configuration = await client.discovery(
    server,
    clientId,
    clientSecret,
    )

  let redirect_uri: string = redirectUrl;
  let scope: string = "openid profile email" // Scope of the access request


  let code_verifier: string = client.randomPKCECodeVerifier()
  let code_challenge: string = await client.calculatePKCECodeChallenge(code_verifier)
  let state: string = ""

  let parameters: Record<string, string> = {
    redirect_uri,
    scope,
    code_challenge,
    code_challenge_method: 'S256',
  }

  if (!config.serverMetadata().supportsPKCE()) {
    state = client.randomState()
    parameters.state = state
  }
  let redirectTo: URL = client.buildAuthorizationUrl(config, parameters)

  return {
    "redirectUrl": redirectTo.href,
    code_verifier,
    state
  }
}
```

## Le CallBack
Pour la deuxième étape du protocole, nous allons créer une route */auth/callback*, qui aura cette structure :

```js

    //get currentURL 
    const currentURL = new URL(`${req.protocol}://${req.get('host')}${req.originalUrl}`);

    //Get the session var
    const codeVerifier = req.session.code_verifier;
    const expectedState = req.session.state;

    //Verify Login with all
    const user = await verifyLogin(currentURL, codeVerifier, expectedState);
    delete req.session.code_verifier;
    delete req.session.state;

    const user_infos = {
      login: user.login,
      firstName: user.firstName,
      lastName: user.lastName,
    }
    req.session.user = user_infos; //We save the user in SESSION
    req.session.token_id = user.token_id; //and the token id for logout
    res.redirect("VOTRE FRONTEND");
```

Ici, on récupère l'URL actuel, et on appelle la fonction *verifyLogin*, qui renvoie un objet *user*.
Dans la suite du code, nous allons créer un objet *user_infos* qui récupère les informations renvoyées par *verifyLogin*.
Ici, nous les sauvegardons dans *req.session.user*. 
Notons que nous sauvegardons aussi le *token_id* afin de pouvoir se déconnecter des serveurs de EirbWare.

La fonction ci-dessous est le *verifyLogin*.
```JavaScript
export async function verifyLogin(currentUrl: URL, code_verifier: string, state: string){
  const issuerUrlString: string | undefined = process.env.ISSUER
  const clientID: string | undefined = process.env.CLIENT_ID
  const clientSecret: string | undefined = process.env.CLIENT_SECRET

  if (issuerUrlString == undefined || clientID == undefined || clientSecret == undefined){
   throw new APIError("OIDC/ENV_NOT_SET");
 }

 const issuer: URL = new URL(issuerUrlString);

 const config: Configuration = await client.discovery(
   issuer,
   clientID,
   clientSecret,
   )
 const tokens = await client.authorizationCodeGrant(
   config,
   currentUrl,
   {
    pkceCodeVerifier: code_verifier,
    expectedState: state == "" ? undefined : state, 
    idTokenExpected: true
  }
  )

 const claims = tokens.claims()!
 const userData = await client.fetchUserInfo(config, tokens.access_token, claims.sub)
    //We save the idToken for disconnection with eirbconnect
 return {
  login: userData.uid,
  firstName: userData.prenom,
  lastName: userData.nom,
  token_id: tokens.id_token,
  };
}
```

## Déconnexion 
Pour la déconnexion, nous n'allons pas détailler la route, sachez seulement que la fonction prend en entrée le *token_id*, sauvegardé dans notre documentation dans *req.session.token_id*. De plus, il faut rediriger l'utilisateur vers l'URL renvoyée par la fonction *disconnect*.
```js

export async function disconnect(token){
  let post_logout_redirect_uri = 'VOTRE_FRONTEND';

  let server!: URL // Authorization Server's Issuer Identifier
  let clientId!: string // Client identifier at the Authorization Server
  let clientSecret!: string // Client Secret

  server = new URL(process.env.ISSUER);
  clientId = process.env.CLIENT_ID;
  clientSecret = process.env.CLIENT_SECRET

  let config: client.Configuration = await client.discovery(
    server,
    clientId,
    clientSecret,
    )

  let redirectTo = client.buildEndSessionUrl(config, {
    post_logout_redirect_uri: post_logout_redirect_uri,
    id_token_hint: token,
  })

  return {
    "redirectUrl": redirectTo.href,
  }
}

```

## Post-Scriptum
Libre à vous de modifier les fonctions et ses paramètres. Cette documentation a été écrite minimale afin de paraître la plus compréhensible possible.
Si vous avez une quelconque question, libre à vous de contacter des membres d'EirbWare.
En espérant que cette documentation vous a été utile :) !

