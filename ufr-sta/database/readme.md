# Base de données — UFR STA

## Prérequis
- XAMPP installé avec MySQL actif

## Installation

1. Ouvre phpMyAdmin : http://localhost/phpmyadmin
2. Crée une base de données nommée : `ufr_sta`
3. Clique sur l'onglet **SQL**
4. mets le contenu et clique **Exécuter**

## Connexion dans app.py

```python
DB_CONFIG = {
    'host':     'localhost',
    'user':     'root',
    'password': '',       
    'database': 'ufr_sta'
}
```

## Tables créées
- `admins` — compte administrateur
- `departements` — les départements de l'UFR
- `formations` — les formations proposées
- `modules_formation` — les modules par semestre
- `actualites` — les actualités publiées
- `activites` — les activités de l'UFR
- `albums` — albums photos
- `galerie_photos` — photos des albums
- `enseignants` — les enseignants
- `messages_contact` — messages du formulaire contact

## Compte admin par défaut
- Login : `admin`
- Mot de passe : `ufr_sta_2026`