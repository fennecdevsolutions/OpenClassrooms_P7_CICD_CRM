<p align="center">
   <img src="./front/src/favicon.png" width="192px" />
</p>

# MicroCRM - Orion

MicroCRM est une application interne simplifiée de gestion de la relation client (CRM) exploitée par les départements technique et commercial d'Orion. L'application utilise une architecture découplée avec une API back-end en Spring Boot et une interface front-end en Angular.

## Architecture du Projet

Ce dépôt est un monorepo structuré de la manière suivante :
- /back : Code source de l'API Backend (Java Spring Boot 3 / Gradle).
- /front : Code source de l'interface Frontend (Angular 17).
- Dockerfile : Fichier de configuration multi-stage pour la conteneurisation.
- docker-compose.yml : Orchestration de l'application (Services frontend et backend).
- docker-compose-elk.yml : Orchestration de la stack d'observabilité (Elasticsearch, Logstash, Kibana, APM Server).

---

## Prérequis

Pour exécuter ou déployer l'application, les outils suivants doivent être installés :
- Docker
- Optionnel (développement local sans conteneur) : OpenJDK 17+ et NodeJS

---

## Instructions de Déploiement

### 1. Démarrage de l'Application (Frontend & Backend)
Pour construire les images et lancer l'application CRM, exécutez la commande suivante à la racine du projet :
```shell
docker compose up --build -d
```
- Interface CRM (Frontend) : Disponible sur https://localhost .
- API (Backend) : Disponible sur http://localhost:8080.

### 2. Démarrage de la Stack d'Observabilité (Optionnel)
Pour activer la centralisation des logs et le suivi des performances via la stack ELK, exécutez :
```shell
docker compose -f docker-compose-elk.yml up -d
```
- Dashboard Kibana : Disponible sur http://localhost:5601.

### 3. Arrêt des Services
Pour arrêter l'ensemble des conteneurs en cours d'exécution :
```shell
docker compose down
docker compose -f docker-compose-elk.yml down
```
---

## Exécution des Tests en Local

### Backend (Java)
Pour rejouer les tests unitaires du serveur :
```shell
cd back
./gradlew test
```
### Frontend (Angular)
Pour rejouer les tests de l'interface cliente :
```shell
cd front
npm install
npm test
```
---

## Pipeline CI/CD (GitHub Actions)

L'industrialisation du projet repose sur deux workflows automatisés :
1. Intégration Continue (ci.yml) : Déclenché à chaque push ou Pull Request. Il valide le build, exécute les tests unitaires, lance un scan de sécurité et de qualité sur SonarQube Cloud, puis publie les images Docker de production sur le registre GitHub Packages (GHCR).
2. Livraison Automatisée (release.yml) : Déclenché lors de la création d'un tag de version (ex: v1.1.0). Il génère automatiquement les notes de version et publie officiellement les artefacts de production (fichiers .jar et .zip) sur GitHub.