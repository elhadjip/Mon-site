-- Ajout des colonnes d'abonnement à la table ecoles
ALTER TABLE ecoles 
  ADD COLUMN abonnement_debut DATE DEFAULT NULL AFTER date_creation_ecole,
  ADD COLUMN abonnement_fin DATE DEFAULT NULL AFTER abonnement_debut,
  ADD COLUMN statut_abonnement ENUM('Actif','Expiré','Suspendu') DEFAULT 'Actif' AFTER abonnement_fin;

-- Abonnement illimité pour l'école par défaut
UPDATE ecoles SET 
  abonnement_debut = '2025-01-01',
  abonnement_fin = '2099-12-31',
  statut_abonnement = 'Actif'
WHERE id_ecole = 1;

-- Type d'école (Primaire, Collège, Lycée)
ALTER TABLE ecoles ADD COLUMN type_ecole ENUM('Primaire','Collège','Lycée','Complète','Franco-Arabe') DEFAULT 'Primaire' AFTER statut_ecole;
ALTER TABLE ecoles MODIFY COLUMN type_ecole ENUM('Primaire','Collège','Lycée','Complète','Franco-Arabe') DEFAULT 'Primaire';
