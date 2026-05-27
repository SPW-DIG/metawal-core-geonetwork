# Cronjobs

## Description

Chaque CronJob a pour objectif d'ingérer des statistiques (indicateurs) dans un index dédié. 
L'ingestion régulière dans un index dédié permet de créer des dashboards Kibana offrant une vue sur l'évolution dans le temps des indicateurs sélectionnés.

## Installation

1.  Télécharger le script bash sur le serveur dans le répertoire /sources
2.  Générer le dossier des logs (s’il n’existe pas déjà, vérifier le chemin dans la commande crontab)
3.  Enregistrer la tâche cron en utilisant la commande crontab stockée dans le fichier crontab
4.  Exécuter les requêtes de configuration dans la console Elastic Dev Tools (afin de générer les index et les templates de recherche)
5.  Créer les tableaux de bord dans Kibana sur base de l’index créé.


## Améliorations futures
Il serait intéressant d'améliorer les scripts bash afin de s'intégrer avec Prometheus/Grafana et pouvoir envoyer des alertes en cas d'erreur ou non execution des cronjobs.
