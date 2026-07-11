-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : sam. 11 juil. 2026 à 16:20
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `ufr_sta`
--

-- --------------------------------------------------------

--
-- Structure de la table `activites`
--

CREATE TABLE `activites` (
  `id` int(11) NOT NULL,
  `titre` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `lieu` varchar(200) DEFAULT NULL,
  `organisateur` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `activites`
--

INSERT INTO `activites` (`id`, `titre`, `date`, `lieu`, `organisateur`, `description`) VALUES
(1, 'Journée de présentation des projets IoT', '2026-05-19', 'Bibliothèque/ODC', 'département informatique', '  Cette activité a permis de mettre en valeur les compétences acquises durant leur formation travers des solutions technologiques innovantes.');

-- --------------------------------------------------------

--
-- Structure de la table `actualites`
--

CREATE TABLE `actualites` (
  `id` int(11) NOT NULL,
  `titre` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `description` text DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `categorie` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `actualites`
--

INSERT INTO `actualites` (`id`, `titre`, `date`, `description`, `photo`, `categorie`) VALUES
(1, 'Séminaire IA et données massives', '2026-06-12', 'Conférence ouverte aux étudiants et enseignants-chercheurs sur les dernières avancées en intelligence artificielle.', NULL, 'Séminaire'),
(2, 'Résultats examens S2 — L3 Informatique', '2026-06-05', 'Consultez vos résultats sur le portail étudiant en ligne dès aujourd\'hui.', NULL, 'Résultats'),
(3, 'Soutenances de projets de fin d\'études', '2026-06-01', 'Planning des soutenances Master Informatique 2025-2026 disponible au secrétariat.', NULL, 'Soutenance');

-- --------------------------------------------------------

--
-- Structure de la table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `admins`
--

INSERT INTO `admins` (`id`, `username`, `password`) VALUES
(1, 'admin', 'ufr_sta_2026');

-- --------------------------------------------------------

--
-- Structure de la table `albums`
--

CREATE TABLE `albums` (
  `id` int(11) NOT NULL,
  `titre` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `date` date DEFAULT NULL,
  `annee` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `albums`
--

INSERT INTO `albums` (`id`, `titre`, `description`, `date`, `annee`) VALUES
(1, 'hackathon', 'première édition Hackathon', '2026-09-03', 2026);

-- --------------------------------------------------------

--
-- Structure de la table `departements`
--

CREATE TABLE `departements` (
  `id` int(11) NOT NULL,
  `nom` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `responsable` varchar(150) DEFAULT NULL,
  `contact` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `departements`
--

INSERT INTO `departements` (`id`, `nom`, `description`, `responsable`, `contact`) VALUES
(1, 'Informatique', 'Département des sciences informatiques', 'Dr. Gueye', 'info@ufr-sta.sn'),
(2, 'Mathématiques', 'Département des mathématiques pures et appliquées', 'Dr. Sow', 'maths@ufr-sta.sn'),
(3, 'Physique', 'Département des sciences physiques', 'Dr. Ndao', 'physique@ufr-sta.sn'),
(4, 'Science de la mer et du littoral', 'Cette filière a pour objectif d’offrir aux étudiants la possibilité d’acquérir une formation qui leur permette d’accéder au plus haut niveau des connaissances académiques tant en recherche que dans le domaine professionnel. Elle prépare les étudiants aux métiers de la protection et de l’aménagement des côtes, des ports, des plateformes offshores pétrolières et gazières (Génie côtier, Génie portuaire, Génie maritime), de la gestion des ressources marines et des écosystèmes côtiers et marins, de la biodiversité marine, de l’économie bleue et la résilience climatique et des territoires littoraux.', 'Dr.Ndao', 'Makha@uam.sn');

-- --------------------------------------------------------

--
-- Structure de la table `enseignants`
--

CREATE TABLE `enseignants` (
  `id` int(11) NOT NULL,
  `nom` varchar(150) NOT NULL,
  `grade` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `domaines` text DEFAULT NULL,
  `departement_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `formations`
--

CREATE TABLE `formations` (
  `id` int(11) NOT NULL,
  `nom` varchar(200) NOT NULL,
  `niveau` varchar(50) NOT NULL,
  `duree` varchar(50) DEFAULT NULL,
  `conditions_admission` text DEFAULT NULL,
  `debouches` text DEFAULT NULL,
  `departement_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `formations`
--

INSERT INTO `formations` (`id`, `nom`, `niveau`, `duree`, `conditions_admission`, `debouches`, `departement_id`) VALUES
(1, 'Licence Informatique', 'Licence', '3 ans', 'Bac scientifique ou technique', 'Développeur, Analyste, Enseignant', 1),
(2, 'Master Informatique', 'Master', '2 ans', 'Licence Informatique', 'Ingénieur logiciel, Chef de projet', 1),
(3, 'Licence Mathématiques', 'Licence', '3 ans', 'Bac scientifique', 'Enseignant, Actuaire, Statisticien', 2),
(4, 'Licence Physique', 'Licence', '3 ans', 'Bac scientifique', 'Ingénieur, Enseignant-chercheur', 3),
(5, 'Master Mathématiques', 'Master', '2 ans', 'Licence Mathematique', 'Les mathématiques sont fondamentales dans les domaines de la finance, de l\'assurance et de la gestion des risques. Cette filière offre donc des opportunités dans les métiers du secteur tertiaire, comme : les Banques et les assurances (actuariat, audit, analyste quantitatif, trader, gestionnaire de portefeuille, finance et ingénierie financière ; le Marketing, l’économie, la modélisation, la Recherche, l’enseignement, l’entrepreneuriat, etc).', 2),
(6, 'Master Physique', 'Master', '2 ans', 'Licence Physique', 'Enseignant, Ingénieur, Chercheur, Technicien de Laboratoire', 3);

-- --------------------------------------------------------

--
-- Structure de la table `galerie_photos`
--

CREATE TABLE `galerie_photos` (
  `id` int(11) NOT NULL,
  `activite_id` int(11) DEFAULT NULL,
  `album_id` int(11) DEFAULT NULL,
  `fichier` varchar(255) NOT NULL,
  `legende` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `galerie_photos`
--

INSERT INTO `galerie_photos` (`id`, `activite_id`, `album_id`, `fichier`, `legende`) VALUES
(1, NULL, 1, 'STA_image2.jpg', ''),
(2, NULL, 1, 'STA_image1.jpg', '');

-- --------------------------------------------------------

--
-- Structure de la table `messages_contact`
--

CREATE TABLE `messages_contact` (
  `id` int(11) NOT NULL,
  `nom` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `sujet` varchar(255) DEFAULT NULL,
  `message` text NOT NULL,
  `date` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `messages_contact`
--

INSERT INTO `messages_contact` (`id`, `nom`, `email`, `sujet`, `message`, `date`) VALUES
(1, 'Aichatou sarr', 'sarr.aichatou1@uam.edu.sn', 'test', 'je teste la page', '2026-06-30');

-- --------------------------------------------------------

--
-- Structure de la table `modules_formation`
--

CREATE TABLE `modules_formation` (
  `id` int(11) NOT NULL,
  `formation_id` int(11) NOT NULL,
  `semestre` int(11) NOT NULL,
  `nom` varchar(200) NOT NULL,
  `ordre` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `modules_formation`
--

INSERT INTO `modules_formation` (`id`, `formation_id`, `semestre`, `nom`, `ordre`) VALUES
(1, 1, 1, 'Algorithmique', 1),
(2, 1, 1, 'Python', 2),
(3, 1, 1, 'Logique', 3),
(4, 1, 1, 'Mathématiques', 4),
(5, 1, 2, 'POO', 1),
(6, 1, 2, 'Base de données', 2),
(7, 1, 2, 'Système d\'Exploitation', 3),
(8, 1, 2, 'Cybersécurité', 4),
(9, 3, 1, 'Analyse 1', 1),
(10, 3, 1, 'Algèbre 1', 2),
(11, 3, 1, 'Géométrie', 3),
(12, 3, 2, 'Analyse 2', 1),
(13, 3, 2, 'Algèbre 2', 2),
(14, 3, 2, 'Probabilités', 3),
(15, 3, 2, 'Statistiques', 4),
(16, 4, 1, 'Mécanique', 1),
(17, 4, 1, 'Électricité', 2),
(18, 4, 1, 'Thermodynamique', 3),
(19, 4, 1, 'Mathématiques', 4),
(20, 4, 2, 'Optique', 1),
(21, 4, 2, 'Magnetostatique', 2),
(22, 4, 2, 'Électromagnétisme', 3);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `activites`
--
ALTER TABLE `activites`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `actualites`
--
ALTER TABLE `actualites`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Index pour la table `albums`
--
ALTER TABLE `albums`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `departements`
--
ALTER TABLE `departements`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `enseignants`
--
ALTER TABLE `enseignants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `departement_id` (`departement_id`);

--
-- Index pour la table `formations`
--
ALTER TABLE `formations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `departement_id` (`departement_id`);

--
-- Index pour la table `galerie_photos`
--
ALTER TABLE `galerie_photos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activite_id` (`activite_id`),
  ADD KEY `album_id` (`album_id`);

--
-- Index pour la table `messages_contact`
--
ALTER TABLE `messages_contact`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `modules_formation`
--
ALTER TABLE `modules_formation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `formation_id` (`formation_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `activites`
--
ALTER TABLE `activites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `actualites`
--
ALTER TABLE `actualites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `albums`
--
ALTER TABLE `albums`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `departements`
--
ALTER TABLE `departements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `enseignants`
--
ALTER TABLE `enseignants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `formations`
--
ALTER TABLE `formations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `galerie_photos`
--
ALTER TABLE `galerie_photos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `messages_contact`
--
ALTER TABLE `messages_contact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `modules_formation`
--
ALTER TABLE `modules_formation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `enseignants`
--
ALTER TABLE `enseignants`
  ADD CONSTRAINT `enseignants_ibfk_1` FOREIGN KEY (`departement_id`) REFERENCES `departements` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `formations`
--
ALTER TABLE `formations`
  ADD CONSTRAINT `formations_ibfk_1` FOREIGN KEY (`departement_id`) REFERENCES `departements` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `galerie_photos`
--
ALTER TABLE `galerie_photos`
  ADD CONSTRAINT `galerie_photos_ibfk_1` FOREIGN KEY (`activite_id`) REFERENCES `activites` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `galerie_photos_ibfk_2` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `modules_formation`
--
ALTER TABLE `modules_formation`
  ADD CONSTRAINT `modules_formation_ibfk_1` FOREIGN KEY (`formation_id`) REFERENCES `formations` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
