# ScriptWiki

## Introduction

Ce dépôt contient deux scripts pour déployer Wiki.js, un puissant logiciel de gestion de contenu, avec des mesures de sécurité supplémentaires. Vous pouvez utiliser ces scripts pour déployer Wiki.js sur un environnement Windows avec WSL (Windows Subsystem for Linux) ou sur un VPS Debian.

## Table des Matières

1. [Prérequis](#prérequis)
2. [Installation sur Windows avec WSL](#installation-sur-windows-avec-wsl)
3. [Installation sur un VPS Debian](#installation-sur-un-vps-debian)
4. [Sécurité et Maintenance](#sécurité-et-maintenance)
5. [Informations de Connexion](#informations-de-connexion)
6. [Résolution des Problèmes](#résolution-des-problèmes)
7. [Support](#support)

## Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants :
- Accès administrateur sur votre machine Windows ou VPS Debian.
- Connexion Internet stable.
- Connaissances de base en ligne de commande.

## Installation sur Windows avec WSL

### Étape 1: Télécharger le Script PowerShell

Téléchargez le script PowerShell depuis le dépôt GitHub :
"https://raw.githubusercontent.com/yankiifr/ScriptWiki/main/deploy_wiki_windows.ps1" -OutFile "deploy_wiki_windows.ps1"

### Étape 2: Exécuter le Script PowerShell
Ouvrez PowerShell en mode administrateur et exécutez le script :
  .\deploy_wiki_windows.ps1

Le script vous guidera à travers les étapes suivantes :
Activer WSL et la plateforme de machine virtuelle.
Redémarrer le système.
Mettre à jour le noyau WSL2.
Définir WSL2 comme version par défaut.
Créer et configurer un disque virtuel (VHDX).
Installer Debian via WSL.
Configurer Debian pour utiliser le disque virtuel.
Mettre à jour le système Debian.
Installer les outils supplémentaires.
Installer et configurer PostgreSQL.
Installer Node.js.
Cloner et configurer Wiki.js.
Démarrer Wiki.js.
Configurer SSH et sécurité.
Configurer les mises à jour automatiques.
Planifier des redémarrages réguliers.
Créer un fichier texte avec les informations de connexion.

## Installation sur un VPS Debian

### Étape 1: Télécharger le Script Bash

Téléchargez le script Bash depuis le dépôt GitHub :
bash
wget https://raw.githubusercontent.com/yankiifr/ScriptWiki/main/deploy_wiki_debian.sh -O deploy_wiki_debian.sh
chmod +x deploy_wiki_debian.sh

### Étape 2: Exécuter le Script Bash

Exécutez le script Bash :./deploy_wiki_debian.sh
Le script exécutera les étapes suivantes :
Mise à jour du système.
Installation des dépendances.
Installation de Node.js.
Clonage du dépôt Wiki.js.
Démarrage de Wiki.js.
Installation et configuration d'OpenVPN.
Configuration de la sécurité pour Wiki.js.
Installation et configuration de Nginx pour SSL.
Configuration de Nginx comme reverse proxy pour Wiki.js.
Installation et configuration de Fail2ban.
Configuration des mises à jour automatiques.
Planification des redémarrages réguliers.
Création d'un fichier texte avec les informations de connexion.
Sécurité et Maintenance
SSL Configuration : Utilisez Let's Encrypt pour obtenir des certificats SSL gratuits et sécuriser les connexions HTTPS.
Fail2ban : Protège contre les tentatives de connexion non autorisées.
Mises à Jour Automatiques : Utilisez unattended-upgrades pour appliquer automatiquement les mises à jour de sécurité.
Redémarrages Réguliers : Planifiez des redémarrages réguliers pour maintenir la stabilité du système.
Informations de Connexion
Les informations de connexion SSH sont enregistrées dans un fichier texte pour référence future. Assurez-vous de stocker ce fichier en lieu sûr.
Résolution des Problèmes
Problèmes de Connexion : Vérifiez les configurations de SSH et les règles de pare-feu.
Problèmes de Performance : Assurez-vous que le système est à jour et redémarrez régulièrement.

Support
Pour toute assistance supplémentaire, consultez la documentation officielle de Wiki.js ou contactez le support technique. En suivant ce manuel, vous pourrez déployer et sécuriser efficacement Wiki.js sur Windows avec WSL ou sur un VPS Debian.
