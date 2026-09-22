# Cronjobs

## Description

### Cronjob Elastic:
Chaque CronJob a pour objectif d'ingérer des statistiques (indicateurs) dans un index dédié. 
L'ingestion régulière dans un index dédié permet de créer des dashboards Kibana offrant une vue sur l'évolution dans le temps des indicateurs sélectionnés.

Liste des cronjobs concernant elastic:
- distributor-weekly-aggregation
- minister-weekly-aggregation
- theme-weekly-aggregation


### Cronjob base de données:
Chaque CronJob a pour but d'exécuter une requête SQL de façon répétée sur la base de données. 

Liste des cronjob concernant la base de données:
- disable-inactive-users

### Prérequis:

##### Installer la librairie client Postgresql :
```sh
sudo dnf install postgresql
```

#### Dans le dossier /home/sites/metawal/sources/

Créer un fichier "es-credentials", contenant les valeurs des propriétés suivantes:
```sh
ES_API_KEY="..."
```

Créer un fichier "database-credentials", contenant les valeurs des propriétés suivantes:
```sh
DB_HOST=...
DB_PORT=...
DB_NAME=...
DB_USER=...
DB_PASSWORD=...
```

## Installation (côté serveur)

1.  Télécharger le dossier contenant le script bash sur le serveur dans le répertoire /home/sites/metawal/sources/cronjobs/
2.  Enregistrer le cronjob en exécutant le script 'setup-cronjob.sh', ce script effectue les opérations suivantes automatiquement:
       - 2.1. Génère le dossier utilisé pour stocker logs (s’il n’existe pas déjà)
       - 2.2. Enregistre le cronjob en utilisant la commande crontab (ajout à la liste des cronjobs existants)

**Attention: exécuter 2 fois le script setup-cronjob enregistrera 2 cronjobs.**

## Installation (côté client)
Pour les cronjobs elastic (dont le dossier contient un fichier nommé 'setup-queris.txt'):
1. Exécuter les requêtes de configuration dans la console Elastic Dev Tools (afin de générer les index et les templates de recherche)
2. Créer les tableaux de bord dans Kibana sur base de l’index créé.


## Améliorations futures
Il serait intéressant d'améliorer les scripts bash afin de s'intégrer avec Prometheus/Grafana et pouvoir envoyer des alertes en cas d'erreur ou non execution des cronjobs.
Cela pourrait être fait en dehors des scripts, en regardant le contenu des logs générés par ce scripts. 
Cela permeeterait de remonter le statut d'exécution des cronjobs, sans complexifier les cronjobs existants. 
En séparant la logique de monitoring, celle-ci sera plus facilement modifiable.
