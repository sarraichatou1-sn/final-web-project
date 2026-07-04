-- =============================================
-- SCHEMA UFR STA — MySQL
-- =============================================

CREATE TABLE IF NOT EXISTS admins (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS departements (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    nom         VARCHAR(150) NOT NULL,
    description TEXT,
    responsable VARCHAR(150),
    contact     VARCHAR(150)
);

CREATE TABLE IF NOT EXISTS formations (
    id                   INT AUTO_INCREMENT PRIMARY KEY,
    nom                  VARCHAR(200) NOT NULL,
    niveau               VARCHAR(50)  NOT NULL,
    duree                VARCHAR(50),
    conditions_admission TEXT,
    debouches            TEXT,
    departement_id       INT,
    FOREIGN KEY (departement_id) REFERENCES departements(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS modules_formation (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    formation_id INT NOT NULL,
    semestre     INT NOT NULL,
    nom          VARCHAR(200) NOT NULL,
    ordre        INT DEFAULT 0,
    FOREIGN KEY (formation_id) REFERENCES formations(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS actualites (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    titre       VARCHAR(255) NOT NULL,
    date        DATE NOT NULL,
    description TEXT,
    photo       VARCHAR(255),
    categorie   VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS activites (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    titre        VARCHAR(255) NOT NULL,
    date         DATE NOT NULL,
    lieu         VARCHAR(200),
    organisateur VARCHAR(200),
    description  TEXT
);

CREATE TABLE IF NOT EXISTS albums (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    titre       VARCHAR(255) NOT NULL,
    description TEXT,
    date        DATE,
    annee       INT
);

CREATE TABLE IF NOT EXISTS galerie_photos (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    activite_id INT,
    album_id    INT,
    fichier     VARCHAR(255) NOT NULL,
    legende     VARCHAR(255),
    FOREIGN KEY (activite_id) REFERENCES activites(id) ON DELETE CASCADE,
    FOREIGN KEY (album_id)    REFERENCES albums(id)    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS enseignants (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    nom            VARCHAR(150) NOT NULL,
    grade          VARCHAR(100),
    email          VARCHAR(150),
    photo          VARCHAR(255),
    domaines       TEXT,
    departement_id INT,
    FOREIGN KEY (departement_id) REFERENCES departements(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS messages_contact (
    id      INT AUTO_INCREMENT PRIMARY KEY,
    nom     VARCHAR(150) NOT NULL,
    email   VARCHAR(150) NOT NULL,
    sujet   VARCHAR(255),
    message TEXT NOT NULL,
    date    DATE DEFAULT (CURRENT_DATE)
);

-- ── Données de départ ──

INSERT IGNORE INTO admins (username, password) VALUES ('admin', 'ufr_sta_2026');

INSERT IGNORE INTO departements (id, nom, description, responsable, contact) VALUES
(1, 'Informatique',  'Département des sciences informatiques',            'Dr. Diallo', 'info@ufr-sta.sn'),
(2, 'Mathématiques', 'Département des mathématiques pures et appliquées', 'Dr. Sow',    'maths@ufr-sta.sn'),
(3, 'Physique',      'Département des sciences physiques',                'Dr. Ndiaye', 'physique@ufr-sta.sn');

INSERT IGNORE INTO formations (id, nom, niveau, duree, conditions_admission, debouches, departement_id) VALUES
(1, 'Licence Informatique',  'Licence', '3 ans', 'Bac scientifique ou technique', 'Développeur, Analyste, Enseignant',  1),
(2, 'Master Informatique',   'Master',  '2 ans', 'Licence Informatique',          'Ingénieur logiciel, Chef de projet', 1),
(3, 'Licence Mathématiques', 'Licence', '3 ans', 'Bac scientifique',              'Enseignant, Actuaire, Statisticien', 2),
(4, 'Licence Physique',      'Licence', '3 ans', 'Bac scientifique',              'Ingénieur, Enseignant-chercheur',    3);

INSERT IGNORE INTO modules_formation (formation_id, semestre, nom, ordre) VALUES
(1, 1, 'Algorithmique',           1),
(1, 1, 'Python',                  2),
(1, 1, 'Logique',                 3),
(1, 1, 'Mathématiques',           4),
(1, 2, 'POO',                     1),
(1, 2, 'Base de données',         2),
(1, 2, 'Système d\'Exploitation', 3),
(1, 2, 'Cybersécurité',           4);