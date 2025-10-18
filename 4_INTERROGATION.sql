USE plateforme_musicale;

/* =====================================================================
   4_INTERROGATION.SQL
   Requêtes de test (sélections, jointures, agrégations, filtres, etc.)
   Dataset utilisé : Damso / ElGrandeToto / Francis Mercier (étape 3)
   ===================================================================== */

/* ---------------------------------------------------------------------
   0) Aides : variables pour changer facilement d'artiste/abonné/playlist
   --------------------------------------------------------------------- */
SET @nom_artiste   = 'Damso';
SET @id_abonne     = 1;     -- Adam Benali
SET @id_playlist   = 1;     -- Rap & Chill

/* ---------------------------------------------------------------------
   1) Liste des morceaux d’un artiste (par titre d’album + date)
   Objectif : vérifier les jointures Artiste -> Album -> Morceau
   --------------------------------------------------------------------- */
SELECT ar.nom_artiste, al.titre_album, m.titre_morceau, m.date_sortie, m.nb_ecoutes
FROM Artiste ar
JOIN Album   al ON al.id_artiste = ar.id_artiste
JOIN Morceau m  ON m.id_album    = al.id_album
WHERE ar.nom_artiste = @nom_artiste
ORDER BY al.titre_album, m.date_sortie;

/* ---------------------------------------------------------------------
   2) Nombre d’albums par artiste (y compris artistes sans album)
   Objectif : LEFT JOIN + GROUP BY + ordre décroissant
   --------------------------------------------------------------------- */
SELECT ar.nom_artiste, COUNT(al.id_album) AS nb_albums
FROM Artiste ar
LEFT JOIN Album al ON al.id_artiste = ar.id_artiste
GROUP BY ar.id_artiste
ORDER BY nb_albums DESC, ar.nom_artiste;

/* ---------------------------------------------------------------------
   3) Morceaux les plus écoutés (TOP 5)
   Objectif : tri décroissant sur nb_ecoutes
   --------------------------------------------------------------------- */
SELECT m.titre_morceau, m.nb_ecoutes, al.titre_album, ar.nom_artiste
FROM Morceau m
JOIN Album  al ON al.id_album = m.id_album
JOIN Artiste ar ON ar.id_artiste = al.id_artiste
ORDER BY m.nb_ecoutes DESC
LIMIT 5;

/* ---------------------------------------------------------------------
   4) Moyenne des notes par morceau (avec uniquement ceux qui ont des notes)
   Objectif : AVG + GROUP BY
   --------------------------------------------------------------------- */
SELECT m.titre_morceau, AVG(e.note) AS note_moyenne, COUNT(*) AS nb_notes
FROM Morceau m
JOIN Evaluation e ON e.id_morceau = m.id_morceau
GROUP BY m.id_morceau
ORDER BY note_moyenne DESC, nb_notes DESC;

/* ---------------------------------------------------------------------
   5) Playlists publiques + nombre de morceaux
   Objectif : filtrer sur une colonne booléenne + COUNT + LEFT JOIN
   --------------------------------------------------------------------- */
SELECT p.id_playlist, p.nom_playlist, p.date_creation, COUNT(c.id_morceau) AS nb_morceaux
FROM Playlist p
LEFT JOIN Contient c ON c.id_playlist = p.id_playlist
WHERE p.publique = TRUE
GROUP BY p.id_playlist
ORDER BY nb_morceaux DESC, p.date_creation DESC;

/* ---------------------------------------------------------------------
   6) Les playlists d’un abonné avec statut (pub/privé) + nb de morceaux
   Objectif : paramètre @id_abonne
   --------------------------------------------------------------------- */
SELECT p.id_playlist, p.nom_playlist,
       CASE WHEN p.publique THEN 'publique' ELSE 'privee' END AS statut,
       COUNT(c.id_morceau) AS nb_morceaux
FROM Playlist p
LEFT JOIN Contient c ON c.id_playlist = p.id_playlist
WHERE p.id_abonne = @id_abonne
GROUP BY p.id_playlist
ORDER BY p.nom_playlist;

/* ---------------------------------------------------------------------
   7) Les abonnés qui suivent un artiste donné
   Objectif : jointure Suivre + filtre sur artiste
   --------------------------------------------------------------------- */
SELECT ar.nom_artiste, ab.id_abonne, ab.nom, ab.email
FROM Suivre s
JOIN Artiste ar ON ar.id_artiste = s.id_artiste
JOIN Abonne ab ON ab.id_abonne = s.id_abonne
WHERE ar.nom_artiste = @nom_artiste
ORDER BY ab.nom;

/* ---------------------------------------------------------------------
   8) Détail d’une playlist : morceaux + artiste + album
   Objectif : triple jointure Contient -> Morceau -> Album -> Artiste
   --------------------------------------------------------------------- */
SELECT p.id_playlist, p.nom_playlist,
       m.titre_morceau, al.titre_album, ar.nom_artiste, m.nb_ecoutes
FROM Playlist p
JOIN Contient c ON c.id_playlist = p.id_playlist
JOIN Morceau m  ON m.id_morceau  = c.id_morceau
JOIN Album al   ON al.id_album   = m.id_album
JOIN Artiste ar ON ar.id_artiste = al.id_artiste
WHERE p.id_playlist = @id_playlist
ORDER BY m.titre_morceau;

/* ---------------------------------------------------------------------
   9) Top artistes par nombre total d’écoutes (somme des morceaux)
   Objectif : SUM sur nb_ecoutes + GROUP BY artiste
   --------------------------------------------------------------------- */
SELECT ar.nom_artiste, SUM(m.nb_ecoutes) AS total_ecoutes
FROM Artiste ar
JOIN Album al  ON al.id_artiste = ar.id_artiste
JOIN Morceau m ON m.id_album    = al.id_album
GROUP BY ar.id_artiste
ORDER BY total_ecoutes DESC;

/* ---------------------------------------------------------------------
   10) Moyenne des notes par artiste (en se basant sur les morceaux notés)
   Objectif : GROUP BY artiste + AVG sur Evaluation
   --------------------------------------------------------------------- */
SELECT ar.nom_artiste, ROUND(AVG(e.note), 2) AS note_moyenne, COUNT(*) AS nb_notes
FROM Evaluation e
JOIN Morceau m ON m.id_morceau = e.id_morceau
JOIN Album al  ON al.id_album  = m.id_album
JOIN Artiste ar ON ar.id_artiste = al.id_artiste
GROUP BY ar.id_artiste
HAVING nb_notes >= 1
ORDER BY note_moyenne DESC;

/* ---------------------------------------------------------------------
   11) Les abonnés qui ont noté au moins 2 morceaux
   Objectif : HAVING COUNT >= 2
   --------------------------------------------------------------------- */
SELECT ab.id_abonne, ab.nom, COUNT(*) AS nb_notes
FROM Evaluation e
JOIN Abonne ab ON ab.id_abonne = e.id_abonne
GROUP BY ab.id_abonne
HAVING COUNT(*) >= 2
ORDER BY nb_notes DESC, ab.nom;

/* ---------------------------------------------------------------------
   12) Petites “vues” (facultatif mais pratique pour le rapport)
   Objectif : créer des VIEWS lisibles pour faire des SELECT rapides
   --------------------------------------------------------------------- */
-- Vue 1 : morceaux avec album + artiste
CREATE OR REPLACE VIEW vw_morceaux_complets AS
SELECT m.id_morceau, m.titre_morceau, m.duree, m.nb_ecoutes,
       al.titre_album, ar.nom_artiste
FROM Morceau m
JOIN Album al  ON al.id_album  = m.id_album
JOIN Artiste ar ON ar.id_artiste = al.id_artiste;

-- Vue 2 : playlists + nb de morceaux
CREATE OR REPLACE VIEW vw_playlists_compte AS
SELECT p.id_playlist, p.nom_playlist, p.publique,
       COUNT(c.id_morceau) AS nb_morceaux
FROM Playlist p
LEFT JOIN Contient c ON c.id_playlist = p.id_playlist
GROUP BY p.id_playlist;

-- Exemples d’utilisation des vues :
SELECT * FROM vw_morceaux_complets ORDER BY nb_ecoutes DESC LIMIT 5;
SELECT * FROM vw_playlists_compte ORDER BY nb_morceaux DESC, id_playlist;
