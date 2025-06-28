# Challenge DevOps - IciFormation

## Présentation

Ce projet est une réponse au challenge DevOps demandé par ICIFORMATION.  
Il illustre la construction d’une application web simple, sa conteneurisation, son orchestration avec Docker Compose, puis son automatisation avec Terraform (IaC).

---

## 📁 Arborescence du projet

TEST DEVOPS/
- Partie1/
    - p1_flask.py
    - requirements.txt
- Partie2/
    - docker-compose.yml
    - Dockerfile
    - nginx.conf
    - p1_flask.py
    - requirements.txt
- Partie3/
    - main.tf
    - pgdata/
    - terraform.tfstate
    - .terraform.lock.hcl
    - terraform.tfstate.backup
    - .terraform/

---

# 🚩 Partie 1 : Application web basique

- Application Python (Flask) avec :
  - `/` : Page d’accueil (“Hello, DevOps!”)
  - `/health` : Status + usage CPU/RAM
  - `/metrics` : Exposition Prometheus
- Code : `Partie1/p1_flask.py`

## Lancer l’application localement

1. Installer les dépendances :
    ```bash
    pip install -r Partie1/requirements.txt
    ```
2. Lancer le serveur :
    ```bash
    python Partie1/p1_flask.py
    ```
3. Accéder à :
    - [http://localhost:5000/](http://localhost:5000/) (Accueil)
    - [http://localhost:5000/health](http://localhost:5000/health)
    - [http://localhost:5000/metrics](http://localhost:5000/metrics)

---

# 🚩 Partie 2 : Conteneurisation (Docker & Docker Compose)

- Conteneurisation de l’app web, ajout d’une base PostgreSQL, reverse proxy Nginx.
- Fichiers :
  - `Partie2/Dockerfile` (image Flask)
  - `Partie2/docker-compose.yml`
  - `Partie2/nginx.conf`
  - `Partie2/p1_flask.py`, `requirements.txt`

## Lancer toute la stack avec Docker Compose

1. Dossier `Partie2`
    ```bash
    cd Partie2
    ```
2. Lancer la stack :
    ```bash
    docker-compose up -d
    ```
3. Accéder à l’application (via le reverse proxy Nginx) :
    - [http://localhost/](http://localhost/) (Accueil)
    - [http://localhost/health](http://localhost/health)
    - [http://localhost/metrics](http://localhost/metrics)
4. **Base de données** (PostgreSQL) :
    - Host : `localhost`
    - Port : `5432`
    - User : `user`
    - Password : `pass`
    - Database : `iciformationdb`
    Connexion utilisée : DBeaver

5. **Arrêter la stack**
    ```bash
    docker-compose down
    ```

---

# 🚩 Partie 3 : Infrastructure as Code (Terraform)

- **Objectif** : Automatiser le déploiement de la stack avec Terraform + provider Docker.
- Fichier principal : `Partie3/main.tf`
- Tout est automatisé : réseau, images, containers, volumes, reverse proxy.

## Déploiement

1. Dossier `Partie3`
    ```bash
    cd Partie3
    ```
2. Initialiser Terraform :
    ```bash
    terraform init
    ```
3. Appliquer le plan :
    ```bash
    terraform apply
    ```

4. **Tester l’application** :
    - [http://localhost/](http://localhost/)
    - [http://localhost/health](http://localhost/health)
    - [http://localhost/metrics](http://localhost/metrics)

5. **Tester la base de données** :
    - Host : `localhost`
    - Port : `5432`
    - User : `user`
    - Password : `pass`
    - Database : `iciformationdb`

6. **Détruire toute l’infrastructure** (nettoyage complet) :
    ```bash
    terraform destroy
    ```

---

# ✍️ Notes

- Le reverse proxy Nginx permet d’exposer uniquement un point d’entrée sécurisé.
- Les conteneurs communiquent via un réseau Docker dédié (`iciformation_net`), comme on ferait en entreprise.
- La base de données est persistée via un volume (dossier `pgdata`).
- Les chemins des volumes et configs sont gérés pour être compatibles Windows & Linux.
