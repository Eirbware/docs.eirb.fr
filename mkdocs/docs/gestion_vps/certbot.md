# Certification et Certbot

Afin de pouvoir utiliser le protocole HTTPS, il faut générer et valider des certificats ssl de manière régulière. 
Ceci est géré par [certbot](https://certbot.eff.org/), qui fait ce travail pour nous.

## En cas de problèmes de certificats invalides

Si jamais le certificat devient invalide (ie certbot ne l'a pas renouvelé), on peut le renouveler manuellement avec la commande:
```title="renouveler le certificat" 
certbot renew --force-renewal
```
