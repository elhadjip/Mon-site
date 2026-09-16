<?php
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/config/session.php';

$page = isset($_GET['page']) ? $_GET['page'] : 'dashboard';

// Pages publiques (sans connexion)
$pages_publiques = ['login', 'logout', 'acces_refuse'];

if (!in_array($page, $pages_publiques)) {
    rediriger_si_non_connecte();
}

// Inclusion du contrôleur approprié
switch ($page) {
    case 'login':
        require_once __DIR__ . '/controleurs/AuthControleur.php';
        break;
    case 'logout':
        session_destroy();
        header("Location: index.php?page=login");
        exit();
    case 'acces_refuse':
        $vue = 'acces_refuse.php';
        break;
    case 'dashboard':
        require_once __DIR__ . '/controleurs/DashboardControleur.php';
        break;
    case 'absences':
        require_once __DIR__ . '/controleurs/AbsenceControleur.php';
        break;
    case 'annees':
        require_once __DIR__ . '/controleurs/AnneeScolaireControleur.php';
        break;
    case 'bulletins':
        require_once __DIR__ . '/controleurs/BulletinControleur.php';
        break;
    case 'cahier_texte':
        require_once __DIR__ . '/controleurs/CahierTexteControleur.php';
        break;
    case 'carte_eleve':
        require_once __DIR__ . '/controleurs/CarteEleveControleur.php';
        break;
    case 'carte_enseignant':
        require_once __DIR__ . '/controleurs/CarteEnseignantControleur.php';
        break;
    case 'carte_parent':
        require_once __DIR__ . '/controleurs/CarteParentControleur.php';
        break;
    case 'classes':
        require_once __DIR__ . '/controleurs/ClasseControleur.php';
        break;
    case 'ecoles':
        require_once __DIR__ . '/controleurs/EcoleControleur.php';
        break;
    case 'eleves':
        require_once __DIR__ . '/controleurs/EleveControleur.php';
        break;
    case 'emplois_temps':
        require_once __DIR__ . '/controleurs/EmploiTempsControleur.php';
        break;
    case 'enseignants':
        require_once __DIR__ . '/controleurs/EnseignantControleur.php';
        break;
    case 'examens':
        require_once __DIR__ . '/controleurs/ExamenControleur.php';
        break;
    case 'frais_scolaires':
        require_once __DIR__ . '/controleurs/FraisScolaireControleur.php';
        break;
    case 'inscriptions':
        require_once __DIR__ . '/controleurs/InscriptionControleur.php';
        break;
    case 'matieres':
        require_once __DIR__ . '/controleurs/MatiereControleur.php';
        break;
    case 'messages':
        require_once __DIR__ . '/controleurs/MessageControleur.php';
        break;
    case 'notes':
        require_once __DIR__ . '/controleurs/NoteControleur.php';
        break;
    case 'paiements':
        require_once __DIR__ . '/controleurs/PaiementControleur.php';
        break;
    case 'parents':
        require_once __DIR__ . '/controleurs/ParentControleur.php';
        break;
    case 'profil':
        require_once __DIR__ . '/controleurs/ProfilControleur.php';
        break;
    case 'utilisateurs':
        require_once __DIR__ . '/controleurs/UtilisateurControleur.php';
        break;
    default:
        $vue = '404.php';
        break;
}

// Si une vue a été définie (ex: acces_refuse), on l'inclut
if (isset($vue)) {
    require_once __DIR__ . '/vues/header.php';
    require_once __DIR__ . '/vues/' . $vue;
    require_once __DIR__ . '/vues/footer.php';
}
?>
