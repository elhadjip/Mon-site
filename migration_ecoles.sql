-- =============================================================
-- MIGRATION MULTI-ÉCOLES
-- Ajoute le support de plusieurs écoles dans une base existante
-- =============================================================

-- 1. Table des écoles
CREATE TABLE IF NOT EXISTS ecoles (
    id_ecole INT PRIMARY KEY AUTO_INCREMENT,
    nom_ecole VARCHAR(255) NOT NULL,
    sigle_ecole VARCHAR(50) DEFAULT NULL,
    devise_ecole VARCHAR(255) DEFAULT NULL,
    adresse_ecole TEXT DEFAULT NULL,
    telephone_ecole VARCHAR(20) DEFAULT NULL,
    email_ecole VARCHAR(100) DEFAULT NULL,
    logo_ecole VARCHAR(255) DEFAULT NULL,
    statut_ecole TINYINT(1) DEFAULT 1,
    date_creation_ecole TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. École par défaut (reprendre les données existantes)
INSERT INTO ecoles (nom_ecole, sigle_ecole, devise_ecole, adresse_ecole, telephone_ecole, email_ecole)
VALUES ('EDU TERANGA', 'ET', 'Éduquer pour un avenir meilleur', 'Dakar, Sénégal', '+221 77 123 45 67', 'contact@eduteranga.sn');

-- 3. Ajouter id_ecole dans toutes les tables (NULL d'abord, puis NOT NULL après migration)
ALTER TABLE annees_scolaires ADD COLUMN id_ecole INT DEFAULT NULL AFTER est_active;
ALTER TABLE utilisateurs ADD COLUMN id_ecole INT DEFAULT NULL AFTER date_creation_user;
ALTER TABLE parents ADD COLUMN id_ecole INT DEFAULT NULL AFTER profession_parent;
ALTER TABLE enseignants ADD COLUMN id_ecole INT DEFAULT NULL AFTER statut_ens;
ALTER TABLE classes ADD COLUMN id_ecole INT DEFAULT NULL AFTER id_ens_principal;
ALTER TABLE matieres ADD COLUMN id_ecole INT DEFAULT NULL AFTER description_matiere;
ALTER TABLE eleves ADD COLUMN id_ecole INT DEFAULT NULL AFTER id_parent_eleve;
ALTER TABLE inscriptions ADD COLUMN id_ecole INT DEFAULT NULL AFTER statut_inscription;
ALTER TABLE examens ADD COLUMN id_ecole INT DEFAULT NULL AFTER coefficient_examen;
ALTER TABLE notes ADD COLUMN id_ecole INT DEFAULT NULL AFTER id_ens_note;
ALTER TABLE bulletins ADD COLUMN id_ecole INT DEFAULT NULL AFTER date_generation_bulletin;
ALTER TABLE absences ADD COLUMN id_ecole INT DEFAULT NULL AFTER id_ens_absence;
ALTER TABLE frais_scolaires ADD COLUMN id_ecole INT DEFAULT NULL AFTER statut_frais;
ALTER TABLE paiements ADD COLUMN id_ecole INT DEFAULT NULL AFTER date_creation_paiement;
ALTER TABLE emplois_temps ADD COLUMN id_ecole INT DEFAULT NULL AFTER id_ens_emploi;
ALTER TABLE cahier_texte ADD COLUMN id_ecole INT DEFAULT NULL AFTER a_faire_cahier;
ALTER TABLE messages ADD COLUMN id_ecole INT DEFAULT NULL AFTER lu_message;
ALTER TABLE classe_enseignants ADD COLUMN id_ecole INT DEFAULT NULL AFTER id_matiere;

-- 4. Assigner toutes les données existantes à l'école par défaut
UPDATE annees_scolaires SET id_ecole = 1;
UPDATE utilisateurs SET id_ecole = 1;
UPDATE parents SET id_ecole = 1;
UPDATE enseignants SET id_ecole = 1;
UPDATE classes SET id_ecole = 1;
UPDATE matieres SET id_ecole = 1;
UPDATE eleves SET id_ecole = 1;
UPDATE inscriptions SET id_ecole = 1;
UPDATE examens SET id_ecole = 1;
UPDATE notes SET id_ecole = 1;
UPDATE bulletins SET id_ecole = 1;
UPDATE absences SET id_ecole = 1;
UPDATE frais_scolaires SET id_ecole = 1;
UPDATE paiements SET id_ecole = 1;
UPDATE emplois_temps SET id_ecole = 1;
UPDATE cahier_texte SET id_ecole = 1;
UPDATE messages SET id_ecole = 1;
UPDATE classe_enseignants SET id_ecole = 1;

-- 5. Rendre id_ecole NOT NULL
ALTER TABLE annees_scolaires MODIFY id_ecole INT NOT NULL;
ALTER TABLE utilisateurs MODIFY id_ecole INT NOT NULL;
ALTER TABLE parents MODIFY id_ecole INT NOT NULL;
ALTER TABLE enseignants MODIFY id_ecole INT NOT NULL;
ALTER TABLE classes MODIFY id_ecole INT NOT NULL;
ALTER TABLE matieres MODIFY id_ecole INT NOT NULL;
ALTER TABLE eleves MODIFY id_ecole INT NOT NULL;
ALTER TABLE inscriptions MODIFY id_ecole INT NOT NULL;
ALTER TABLE examens MODIFY id_ecole INT NOT NULL;
ALTER TABLE notes MODIFY id_ecole INT NOT NULL;
ALTER TABLE bulletins MODIFY id_ecole INT NOT NULL;
ALTER TABLE absences MODIFY id_ecole INT NOT NULL;
ALTER TABLE frais_scolaires MODIFY id_ecole INT NOT NULL;
ALTER TABLE paiements MODIFY id_ecole INT NOT NULL;
ALTER TABLE emplois_temps MODIFY id_ecole INT NOT NULL;
ALTER TABLE cahier_texte MODIFY id_ecole INT NOT NULL;
ALTER TABLE messages MODIFY id_ecole INT NOT NULL;
ALTER TABLE classe_enseignants MODIFY id_ecole INT NOT NULL;

-- 5bis. Unicité des matières par école (l'ancien index global nom_matiere est supprimé par database.php)
ALTER TABLE matieres ADD UNIQUE KEY uniq_nom_matiere_ecole (id_ecole, nom_matiere);

-- 6. Ajouter les clés étrangères
ALTER TABLE annees_scolaires ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;ALTER TABLE utilisateurs ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE parents ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE enseignants ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE classes ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE matieres ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE eleves ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE inscriptions ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE examens ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE notes ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE bulletins ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE absences ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE frais_scolaires ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE paiements ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE emplois_temps ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE cahier_texte ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE messages ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
ALTER TABLE classe_enseignants ADD FOREIGN KEY (id_ecole) REFERENCES ecoles(id_ecole) ON DELETE CASCADE;
