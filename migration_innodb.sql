-- =============================================================
-- MIGRATION MyISAM → InnoDB + Contraintes FK avec CASCADE
-- =============================================================

-- 1. Nettoyage : supprimer les inscriptions orphelines
DELETE FROM inscriptions WHERE id_eleve_inscription NOT IN (SELECT id_eleve FROM eleves);
DELETE FROM notes WHERE id_eleve_note NOT IN (SELECT id_eleve FROM eleves);
DELETE FROM bulletins WHERE id_eleve_bulletin NOT IN (SELECT id_eleve FROM eleves);
DELETE FROM absences WHERE id_eleve_absence NOT IN (SELECT id_eleve FROM eleves);
DELETE FROM frais_scolaires WHERE id_eleve_frais NOT IN (SELECT id_eleve FROM eleves);
DELETE FROM paiements WHERE id_eleve_paiement NOT IN (SELECT id_eleve FROM eleves);

-- 2. Conversion des tables en InnoDB
ALTER TABLE utilisateurs ENGINE = InnoDB;
ALTER TABLE parents ENGINE = InnoDB;
ALTER TABLE enseignants ENGINE = InnoDB;
ALTER TABLE annees_scolaires ENGINE = InnoDB;
ALTER TABLE classes ENGINE = InnoDB;
ALTER TABLE matieres ENGINE = InnoDB;
ALTER TABLE eleves ENGINE = InnoDB;
ALTER TABLE inscriptions ENGINE = InnoDB;
ALTER TABLE examens ENGINE = InnoDB;
ALTER TABLE notes ENGINE = InnoDB;
ALTER TABLE bulletins ENGINE = InnoDB;
ALTER TABLE absences ENGINE = InnoDB;
ALTER TABLE frais_scolaires ENGINE = InnoDB;
ALTER TABLE paiements ENGINE = InnoDB;
ALTER TABLE emplois_temps ENGINE = InnoDB;
ALTER TABLE cahier_texte ENGINE = InnoDB;
ALTER TABLE messages ENGINE = InnoDB;
ALTER TABLE classe_enseignants ENGINE = InnoDB;

-- 3. Ajout des contraintes FK (si pas déjà présentes)

-- parents
ALTER TABLE parents ADD CONSTRAINT fk_parent_user FOREIGN KEY (id_user_parent) REFERENCES utilisateurs(id_user) ON DELETE CASCADE;

-- enseignants
ALTER TABLE enseignants ADD CONSTRAINT fk_ens_user FOREIGN KEY (id_user_ens) REFERENCES utilisateurs(id_user) ON DELETE CASCADE;

-- classes
ALTER TABLE classes ADD CONSTRAINT fk_classe_annee FOREIGN KEY (id_annee_classe) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE;
ALTER TABLE classes ADD CONSTRAINT fk_classe_principal FOREIGN KEY (id_ens_principal) REFERENCES enseignants(id_ens) ON DELETE SET NULL;

-- matieres
ALTER TABLE matieres ADD CONSTRAINT fk_matiere_ens FOREIGN KEY (id_enseignant_matiere) REFERENCES enseignants(id_ens) ON DELETE SET NULL;

-- eleves
ALTER TABLE eleves ADD CONSTRAINT fk_eleve_user FOREIGN KEY (id_user_eleve) REFERENCES utilisateurs(id_user) ON DELETE CASCADE;
ALTER TABLE eleves ADD CONSTRAINT fk_eleve_parent FOREIGN KEY (id_parent_eleve) REFERENCES parents(id_parent) ON DELETE RESTRICT;

-- inscriptions
ALTER TABLE inscriptions ADD CONSTRAINT fk_inscription_eleve FOREIGN KEY (id_eleve_inscription) REFERENCES eleves(id_eleve) ON DELETE CASCADE;
ALTER TABLE inscriptions ADD CONSTRAINT fk_inscription_classe FOREIGN KEY (id_classe_inscription) REFERENCES classes(id_classe) ON DELETE CASCADE;
ALTER TABLE inscriptions ADD CONSTRAINT fk_inscription_annee FOREIGN KEY (id_annee_inscription) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE;

-- examens
ALTER TABLE examens ADD CONSTRAINT fk_examen_annee FOREIGN KEY (id_annee_examen) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE;
ALTER TABLE examens ADD CONSTRAINT fk_examen_matiere FOREIGN KEY (id_matiere_examen) REFERENCES matieres(id_matiere) ON DELETE CASCADE;
ALTER TABLE examens ADD CONSTRAINT fk_examen_classe FOREIGN KEY (id_classe_examen) REFERENCES classes(id_classe) ON DELETE CASCADE;
ALTER TABLE examens ADD CONSTRAINT fk_examen_ens FOREIGN KEY (id_ens_examen) REFERENCES enseignants(id_ens) ON DELETE CASCADE;

-- notes
ALTER TABLE notes ADD CONSTRAINT fk_note_examen FOREIGN KEY (id_examen_note) REFERENCES examens(id_examen) ON DELETE SET NULL;
ALTER TABLE notes ADD CONSTRAINT fk_note_eleve FOREIGN KEY (id_eleve_note) REFERENCES eleves(id_eleve) ON DELETE CASCADE;
ALTER TABLE notes ADD CONSTRAINT fk_note_matiere FOREIGN KEY (id_matiere_note) REFERENCES matieres(id_matiere) ON DELETE CASCADE;
ALTER TABLE notes ADD CONSTRAINT fk_note_annee FOREIGN KEY (id_annee_note) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE;
ALTER TABLE notes ADD CONSTRAINT fk_note_ens FOREIGN KEY (id_ens_note) REFERENCES enseignants(id_ens) ON DELETE SET NULL;

-- bulletins
ALTER TABLE bulletins ADD CONSTRAINT fk_bulletin_eleve FOREIGN KEY (id_eleve_bulletin) REFERENCES eleves(id_eleve) ON DELETE CASCADE;
ALTER TABLE bulletins ADD CONSTRAINT fk_bulletin_annee FOREIGN KEY (id_annee_bulletin) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE;

-- absences
ALTER TABLE absences ADD CONSTRAINT fk_absence_eleve FOREIGN KEY (id_eleve_absence) REFERENCES eleves(id_eleve) ON DELETE CASCADE;
ALTER TABLE absences ADD CONSTRAINT fk_absence_annee FOREIGN KEY (id_annee_absence) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE;
ALTER TABLE absences ADD CONSTRAINT fk_absence_ens FOREIGN KEY (id_ens_absence) REFERENCES enseignants(id_ens) ON DELETE SET NULL;

-- frais_scolaires
ALTER TABLE frais_scolaires ADD CONSTRAINT fk_frais_eleve FOREIGN KEY (id_eleve_frais) REFERENCES eleves(id_eleve) ON DELETE CASCADE;
ALTER TABLE frais_scolaires ADD CONSTRAINT fk_frais_annee FOREIGN KEY (id_annee_frais) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE;

-- paiements
ALTER TABLE paiements ADD CONSTRAINT fk_paiement_eleve FOREIGN KEY (id_eleve_paiement) REFERENCES eleves(id_eleve) ON DELETE CASCADE;
ALTER TABLE paiements ADD CONSTRAINT fk_paiement_frais FOREIGN KEY (id_frais_paiement) REFERENCES frais_scolaires(id_frais) ON DELETE SET NULL;
ALTER TABLE paiements ADD CONSTRAINT fk_paiement_annee FOREIGN KEY (id_annee_paiement) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE;
ALTER TABLE paiements ADD CONSTRAINT fk_paiement_user FOREIGN KEY (id_user_receveur) REFERENCES utilisateurs(id_user) ON DELETE CASCADE;

-- emplois_temps
ALTER TABLE emplois_temps ADD CONSTRAINT fk_emploi_classe FOREIGN KEY (id_classe_emploi) REFERENCES classes(id_classe) ON DELETE CASCADE;
ALTER TABLE emplois_temps ADD CONSTRAINT fk_emploi_annee FOREIGN KEY (id_annee_emploi) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE;
ALTER TABLE emplois_temps ADD CONSTRAINT fk_emploi_matiere FOREIGN KEY (id_matiere_emploi) REFERENCES matieres(id_matiere) ON DELETE CASCADE;
ALTER TABLE emplois_temps ADD CONSTRAINT fk_emploi_ens FOREIGN KEY (id_ens_emploi) REFERENCES enseignants(id_ens) ON DELETE CASCADE;

-- cahier_texte
ALTER TABLE cahier_texte ADD CONSTRAINT fk_cahier_ens FOREIGN KEY (id_ens_cahier) REFERENCES enseignants(id_ens) ON DELETE CASCADE;
ALTER TABLE cahier_texte ADD CONSTRAINT fk_cahier_classe FOREIGN KEY (id_classe_cahier) REFERENCES classes(id_classe) ON DELETE CASCADE;
ALTER TABLE cahier_texte ADD CONSTRAINT fk_cahier_matiere FOREIGN KEY (id_matiere_cahier) REFERENCES matieres(id_matiere) ON DELETE CASCADE;
ALTER TABLE cahier_texte ADD CONSTRAINT fk_cahier_annee FOREIGN KEY (id_annee_cahier) REFERENCES annees_scolaires(id_annee) ON DELETE CASCADE;

-- messages
ALTER TABLE messages ADD CONSTRAINT fk_message_expediteur FOREIGN KEY (id_expediteur_message) REFERENCES utilisateurs(id_user) ON DELETE CASCADE;
ALTER TABLE messages ADD CONSTRAINT fk_message_destinataire FOREIGN KEY (id_destinataire_message) REFERENCES utilisateurs(id_user) ON DELETE CASCADE;

-- classe_enseignants (pas de FK dans le schéma original)
ALTER TABLE classe_enseignants ADD CONSTRAINT fk_ce_classe FOREIGN KEY (id_classe) REFERENCES classes(id_classe) ON DELETE CASCADE;
ALTER TABLE classe_enseignants ADD CONSTRAINT fk_ce_ens FOREIGN KEY (id_ens) REFERENCES enseignants(id_ens) ON DELETE CASCADE;
