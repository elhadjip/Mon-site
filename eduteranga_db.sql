-- =============================================================
-- SCHÉMA UNIFIÉ GESTION SCOLAIRE - EDU TERANGA
-- Correspond exactement au code PHP (modeles/*.php)
-- =============================================================

DROP DATABASE IF EXISTS eduteranga_db;
CREATE DATABASE IF NOT EXISTS eduteranga_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE eduteranga_db;

-- 1. Années scolaires
CREATE TABLE annees_scolaires (
    id_annee INT PRIMARY KEY AUTO_INCREMENT,
    libelle_annee VARCHAR(50) NOT NULL UNIQUE,
    date_debut_annee DATE NOT NULL,
    date_fin_annee DATE NOT NULL,
    est_active TINYINT(1) DEFAULT 0
) ENGINE=InnoDB;

-- 2. Utilisateurs (multi-rôles)
CREATE TABLE utilisateurs (
    id_user INT PRIMARY KEY AUTO_INCREMENT,
    nom_user VARCHAR(100) NOT NULL,
    prenom_user VARCHAR(100) NOT NULL,
    email_user VARCHAR(191) NOT NULL UNIQUE,
    mot_de_passe_user VARCHAR(255) NOT NULL,
    role_user ENUM('Administrateur général','Directeur / Surveillance générale','Secrétariat','Comptabilité','Professeur','Élève','Parent') NOT NULL,
    telephone_user VARCHAR(20),
    adresse_user TEXT,
    photo_user VARCHAR(255),
    statut_user TINYINT(1) DEFAULT 1,
    derniere_connexion DATETIME,
    date_creation_user TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. Parents
CREATE TABLE parents (
    id_parent INT PRIMARY KEY AUTO_INCREMENT,
    id_user_parent INT,
    nom_parent VARCHAR(100) NOT NULL,
    prenom_parent VARCHAR(100) NOT NULL,
    telephone_parent VARCHAR(20) NOT NULL,
    email_parent VARCHAR(100),
    adresse_parent TEXT,
    profession_parent VARCHAR(100),
    FOREIGN KEY (id_user_parent) REFERENCES utilisateurs(id_user) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. Enseignants
CREATE TABLE enseignants (
    id_ens INT PRIMARY KEY AUTO_INCREMENT,
    id_user_ens INT UNIQUE,
    matricule_ens VARCHAR(50) UNIQUE,
    nom_ens VARCHAR(100) NOT NULL,
    prenom_ens VARCHAR(100) NOT NULL,
    date_naissance_ens DATE,
    lieu_naissance_ens VARCHAR(100),
    sexe_ens ENUM('M','F'),
    telephone_ens VARCHAR(20),
    email_ens VARCHAR(100),
    adresse_ens TEXT,
    specialite_ens VARCHAR(100),
    date_embauche_ens DATE,
    photo_ens VARCHAR(255),
    statut_ens ENUM('Actif','Congé','Démissionné') DEFAULT 'Actif',
    FOREIGN KEY (id_user_ens) REFERENCES utilisateurs(id_user) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. Classes
CREATE TABLE classes (
    id_classe INT PRIMARY KEY AUTO_INCREMENT,
    id_annee_classe INT NOT NULL,
    nom_classe VARCHAR(100) NOT NULL,
    niveau_classe VARCHAR(50) NOT NULL,
    serie_classe ENUM('S','L','G','GT','S2','Aucune') DEFAULT 'Aucune',
    capacite_classe INT DEFAULT 30,
    id_ens_principal INT,
    FOREIGN KEY (id_annee_classe) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE,
    FOREIGN KEY (id_ens_principal) REFERENCES enseignants(id_ens) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 6. Matières
CREATE TABLE matieres (
    id_matiere INT PRIMARY KEY AUTO_INCREMENT,
    nom_matiere VARCHAR(100) NOT NULL,
    coefficient_matiere DECIMAL(3,1) DEFAULT 1.0,
    type_matiere ENUM('Scientifique','Litteraire','Generale') DEFAULT 'Generale',
    id_enseignant_matiere INT,
    description_matiere TEXT,
    FOREIGN KEY (id_enseignant_matiere) REFERENCES enseignants(id_ens) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 7. Élèves
CREATE TABLE eleves (
    id_eleve INT PRIMARY KEY AUTO_INCREMENT,
    id_user_eleve INT UNIQUE,
    matricule_eleve VARCHAR(50) NOT NULL UNIQUE,
    nom_eleve VARCHAR(100) NOT NULL,
    prenom_eleve VARCHAR(100) NOT NULL,
    date_naissance_eleve DATE NOT NULL,
    lieu_naissance_eleve VARCHAR(100),
    sexe_eleve ENUM('M','F') NOT NULL,
    adresse_eleve TEXT,
    telephone_eleve VARCHAR(20),
    photo_eleve VARCHAR(255),
    id_parent_eleve INT NOT NULL,
    FOREIGN KEY (id_user_eleve) REFERENCES utilisateurs(id_user) ON DELETE CASCADE,
    FOREIGN KEY (id_parent_eleve) REFERENCES parents(id_parent) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 8. Inscriptions
CREATE TABLE inscriptions (
    id_inscription INT PRIMARY KEY AUTO_INCREMENT,
    id_eleve_inscription INT NOT NULL,
    id_classe_inscription INT NOT NULL,
    id_annee_inscription INT NOT NULL,
    date_inscription DATE NOT NULL,
    frais_inscription DECIMAL(10,2) DEFAULT 50000.00,
    statut_inscription ENUM('En cours','Validée','Annulée') DEFAULT 'En cours',
    UNIQUE KEY unique_inscription (id_eleve_inscription, id_annee_inscription),
    FOREIGN KEY (id_eleve_inscription) REFERENCES eleves(id_eleve) ON DELETE CASCADE,
    FOREIGN KEY (id_classe_inscription) REFERENCES classes(id_classe) ON DELETE CASCADE,
    FOREIGN KEY (id_annee_inscription) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 9. Examens
CREATE TABLE examens (
    id_examen INT PRIMARY KEY AUTO_INCREMENT,
    id_annee_examen INT NOT NULL,
    nom_examen VARCHAR(100) NOT NULL,
    type_examen ENUM('Devoir','Examen','Composition') NOT NULL,
    date_examen DATE NOT NULL,
    id_matiere_examen INT NOT NULL,
    id_classe_examen INT NOT NULL,
    id_ens_examen INT NOT NULL,
    coefficient_examen INT DEFAULT 1,
    date_creation_examen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_annee_examen) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE,
    FOREIGN KEY (id_matiere_examen) REFERENCES matieres(id_matiere) ON DELETE CASCADE,
    FOREIGN KEY (id_classe_examen) REFERENCES classes(id_classe) ON DELETE CASCADE,
    FOREIGN KEY (id_ens_examen) REFERENCES enseignants(id_ens) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 10. Notes
CREATE TABLE notes (
    id_note INT PRIMARY KEY AUTO_INCREMENT,
    id_examen_note INT,
    id_eleve_note INT NOT NULL,
    id_matiere_note INT NOT NULL,
    id_annee_note INT NOT NULL,
    semestre_note ENUM('1','2') NOT NULL,
    type_note ENUM('Devoir','Composition','Interrogation','Examen') NOT NULL,
    note DECIMAL(4,2) NOT NULL CHECK (note >= 0 AND note <= 20),
    appreciation_note TEXT,
    date_note DATE NOT NULL,
    id_ens_note INT,
    FOREIGN KEY (id_examen_note) REFERENCES examens(id_examen) ON DELETE SET NULL,
    FOREIGN KEY (id_eleve_note) REFERENCES eleves(id_eleve) ON DELETE CASCADE,
    FOREIGN KEY (id_matiere_note) REFERENCES matieres(id_matiere) ON DELETE CASCADE,
    FOREIGN KEY (id_annee_note) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE,
    FOREIGN KEY (id_ens_note) REFERENCES enseignants(id_ens) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 11. Bulletins
CREATE TABLE bulletins (
    id_bulletin INT PRIMARY KEY AUTO_INCREMENT,
    id_eleve_bulletin INT NOT NULL,
    id_annee_bulletin INT NOT NULL,
    trimestre_bulletin ENUM('1','2','3') NOT NULL,
    moyenne_bulletin DECIMAL(4,2),
    rang_bulletin INT,
    appreciation_bulletin TEXT,
    date_generation_bulletin TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_bulletin (id_eleve_bulletin, id_annee_bulletin, trimestre_bulletin),
    FOREIGN KEY (id_eleve_bulletin) REFERENCES eleves(id_eleve) ON DELETE CASCADE,
    FOREIGN KEY (id_annee_bulletin) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 12. Absences
CREATE TABLE absences (
    id_absence INT PRIMARY KEY AUTO_INCREMENT,
    id_eleve_absence INT NOT NULL,
    id_annee_absence INT NOT NULL,
    date_absence DATE NOT NULL,
    heure_debut_absence TIME,
    heure_fin_absence TIME,
    motif_absence TEXT,
    justifiee_absence TINYINT(1) DEFAULT 0,
    id_ens_absence INT,
    FOREIGN KEY (id_eleve_absence) REFERENCES eleves(id_eleve) ON DELETE CASCADE,
    FOREIGN KEY (id_annee_absence) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE,
    FOREIGN KEY (id_ens_absence) REFERENCES enseignants(id_ens) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 13. Frais scolaires (créé AVANT paiements)
CREATE TABLE frais_scolaires (
    id_frais INT PRIMARY KEY AUTO_INCREMENT,
    id_eleve_frais INT NOT NULL,
    id_annee_frais INT NOT NULL,
    type_frais ENUM('Inscription','Mensuel','Cantine','Examen','Uniforme','Transport','Autre') NOT NULL,
    montant_frais DECIMAL(10,2) NOT NULL,
    montant_paye_frais DECIMAL(10,2) DEFAULT 0.00,
    date_echeance DATE NOT NULL,
    date_paiement_frais DATE,
    mode_paiement_frais ENUM('Espèces','Orange Money','Wave','Virement','Chèque'),
    motif_paiement_frais VARCHAR(255),
    statut_frais ENUM('Non payé','Partiel','Payé') DEFAULT 'Non payé',
    FOREIGN KEY (id_eleve_frais) REFERENCES eleves(id_eleve) ON DELETE CASCADE,
    FOREIGN KEY (id_annee_frais) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 14. Paiements
CREATE TABLE paiements (
    id_paiement INT PRIMARY KEY AUTO_INCREMENT,
    id_eleve_paiement INT,
    id_frais_paiement INT,
    id_annee_paiement INT NOT NULL,
    type_paiement VARCHAR(100) NOT NULL,
    montant_du DECIMAL(10,2) NOT NULL DEFAULT 0,
    montant_paye DECIMAL(10,2) NOT NULL,
    reste_a_payer DECIMAL(10,2) GENERATED ALWAYS AS (montant_du - montant_paye) STORED,
    date_paiement DATE NOT NULL,
    mode_paiement ENUM('Espèce','Chèque','Virement','Mobile Money') NOT NULL,
    reference_paiement VARCHAR(100),
    motif_paiement VARCHAR(255),
    id_user_receveur INT,
    date_creation_paiement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_eleve_paiement) REFERENCES eleves(id_eleve) ON DELETE CASCADE,
    FOREIGN KEY (id_frais_paiement) REFERENCES frais_scolaires(id_frais) ON DELETE SET NULL,
    FOREIGN KEY (id_annee_paiement) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE,
    FOREIGN KEY (id_user_receveur) REFERENCES utilisateurs(id_user) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 15. Emplois du temps
CREATE TABLE emplois_temps (
    id_emploi INT PRIMARY KEY AUTO_INCREMENT,
    id_classe_emploi INT NOT NULL,
    id_annee_emploi INT NOT NULL,
    jour_emploi ENUM('Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi') NOT NULL,
    heure_debut_emploi TIME NOT NULL,
    heure_fin_emploi TIME NOT NULL,
    id_matiere_emploi INT NOT NULL,
    id_ens_emploi INT NOT NULL,
    FOREIGN KEY (id_classe_emploi) REFERENCES classes(id_classe) ON DELETE CASCADE,
    FOREIGN KEY (id_annee_emploi) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE,
    FOREIGN KEY (id_matiere_emploi) REFERENCES matieres(id_matiere) ON DELETE CASCADE,
    FOREIGN KEY (id_ens_emploi) REFERENCES enseignants(id_ens) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 16. Cahier de texte
CREATE TABLE cahier_texte (
    id_cahier INT PRIMARY KEY AUTO_INCREMENT,
    id_ens_cahier INT NOT NULL,
    id_classe_cahier INT NOT NULL,
    id_matiere_cahier INT NOT NULL,
    id_annee_cahier INT NOT NULL,
    date_cahier DATE NOT NULL,
    type_cahier ENUM('Devoir','Lecon','Exercice') NOT NULL,
    contenu_cahier TEXT NOT NULL,
    a_faire_cahier TEXT,
    FOREIGN KEY (id_ens_cahier) REFERENCES enseignants(id_ens) ON DELETE CASCADE,
    FOREIGN KEY (id_classe_cahier) REFERENCES classes(id_classe) ON DELETE CASCADE,
    FOREIGN KEY (id_matiere_cahier) REFERENCES matieres(id_matiere) ON DELETE CASCADE,
    FOREIGN KEY (id_annee_cahier) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 17. Messages
CREATE TABLE messages (
    id_message INT PRIMARY KEY AUTO_INCREMENT,
    id_expediteur_message INT NOT NULL,
    id_destinataire_message INT NOT NULL,
    sujet_message VARCHAR(255) NOT NULL,
    contenu_message TEXT NOT NULL,
    date_message TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lu_message TINYINT(1) DEFAULT 0,
    FOREIGN KEY (id_expediteur_message) REFERENCES utilisateurs(id_user) ON DELETE CASCADE,
    FOREIGN KEY (id_destinataire_message) REFERENCES utilisateurs(id_user) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 18. Association Classes - Enseignants (plusieurs enseignants par classe)
CREATE TABLE classe_enseignants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_classe INT NOT NULL,
    id_ens INT NOT NULL,
    id_matiere INT,
    UNIQUE KEY unique_affectation (id_classe, id_ens),
    FOREIGN KEY (id_classe) REFERENCES classes(id_classe) ON DELETE CASCADE,
    FOREIGN KEY (id_ens) REFERENCES enseignants(id_ens) ON DELETE CASCADE,
    FOREIGN KEY (id_matiere) REFERENCES matieres(id_matiere) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =============================================================
-- DONNÉES INITIALES
-- =============================================================

-- Admin (mot de passe: admin123)
INSERT INTO utilisateurs (nom_user, prenom_user, email_user, mot_de_passe_user, role_user, telephone_user, statut_user)
VALUES ('Admin', 'EDU TERANGA', 'admin@eduteranga.sn',
        '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'Administrateur général', '771234567', 1);

-- Année scolaire (après admin car pas de FK, ordre libre)
INSERT INTO annees_scolaires (libelle_annee, date_debut_annee, date_fin_annee, est_active)
VALUES ('2025-2026', '2025-10-01', '2026-07-31', TRUE);