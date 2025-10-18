USE plateforme_musicale;

-- 1) On vide proprement (dans l’ordre enfant -> parent)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Contient;
TRUNCATE TABLE Evaluation;
TRUNCATE TABLE Suivre;
TRUNCATE TABLE Morceau;
TRUNCATE TABLE Album;
TRUNCATE TABLE Playlist;
TRUNCATE TABLE Abonne;
TRUNCATE TABLE Artiste;
SET FOREIGN_KEY_CHECKS = 1;

-- 2) Réinsertion des données
-- ------------------------------------------------------------
-- 🎵 Artistes
-- ------------------------------------------------------------
INSERT INTO Artiste (id_artiste, nom_artiste, pays, biographie, nb_abonnes) VALUES
(1, 'Damso',         'Belgique', 'Rappeur, auteur-compositeur (textes introspectifs et poétiques).', 2500000),
(2, 'ElGrandeToto',  'Maroc',    'Figure de la trap marocaine, mélange arabe/français/anglais.',      1800000),
(3, 'Francis Mercier','Haïti',   'DJ/producteur Afro House, collabs internationales.',                 600000);

-- ------------------------------------------------------------
-- 👤 Abonnés (utilisateurs)
-- ------------------------------------------------------------
INSERT INTO Abonne (id_abonne, nom, email, date_inscription) VALUES
(1, 'Adam Benali', 'adam.benali@gmail.com',  '2024-03-10'),
(2, 'Sarah Lopez', 'sarah.lopez@gmail.com',  '2024-06-22'),
(3, 'Yanis Karchal','yanis.karchal@gmail.com','2024-09-15');

-- ------------------------------------------------------------
-- 💿 Albums (référencent id_artiste)
-- ------------------------------------------------------------
INSERT INTO Album (id_album, titre_album, date_sortie, illustration, genre, duree_totale, id_artiste) VALUES
(1, 'QALF',                '2020-09-18', NULL, 'Rap',        3600, 1), -- Damso
(2, '27',                  '2021-11-05', NULL, 'Trap',       2800, 2), -- ElGrandeToto
(3, 'Welcome To Djouka',   '2023-06-15', NULL, 'Afro House', 2400, 3); -- Francis Mercier

-- ------------------------------------------------------------
-- 🎧 Morceaux (référencent id_album)
-- ------------------------------------------------------------
INSERT INTO Morceau (id_morceau, titre_morceau, duree, date_sortie, nb_ecoutes, id_album) VALUES
(1, 'Θ. Macarena',       210, '2020-09-18', 7000000, 1), -- QALF
(2, '2.911',             230, '2020-09-18', 5500000, 1), -- QALF
(3, 'Love Nwantiti Remix',240, '2023-06-15', 1200000, 3), -- Welcome To Djouka
(4, '7elmet Ado',        200, '2021-11-05', 2500000, 2), -- 27
(5, 'Mghayer',           220, '2021-11-05', 2800000, 2); -- 27

-- ------------------------------------------------------------
-- 🎶 Playlists (colonne = publique SANS underscore)
-- ------------------------------------------------------------
INSERT INTO Playlist (id_playlist, nom_playlist, date_creation, publique, date_modification, id_abonne) VALUES
(1, 'Rap & Chill',   '2024-07-01', TRUE,  NULL, 1), -- Adam
(2, 'Trap Maghreb',  '2024-07-10', FALSE, NULL, 2), -- Sarah
(3, 'Afro Vibes',    '2024-08-02', TRUE,  NULL, 3); -- Yanis

-- ------------------------------------------------------------
-- 🤝 Abonnements (qui suit qui)
-- ------------------------------------------------------------
INSERT INTO Suivre (id_artiste, id_abonne) VALUES
(1,1),  -- Adam suit Damso
(2,1),  -- Adam suit ElGrandeToto
(2,2),  -- Sarah suit ElGrandeToto
(3,3);  -- Yanis suit Francis Mercier

-- ------------------------------------------------------------
-- ⭐ Évaluations (notes entre 1 et 5)
-- ------------------------------------------------------------
INSERT INTO Evaluation (id_morceau, id_abonne, note) VALUES
(1,1,5),  -- Adam kiffe 'Macarena'
(2,1,4),
(4,2,5),  -- Sarah met 5 à '7elmet Ado'
(3,3,4);  -- Yanis met 4 à 'Love Nwantiti Remix'

-- ------------------------------------------------------------
-- 📀 Contenu des playlists (morceaux ⇄ playlists)
-- ------------------------------------------------------------
INSERT INTO Contient (id_morceau, id_playlist) VALUES
(1,1), (2,1),      -- Rap & Chill (Adam)
(4,2), (5,2),      -- Trap Maghreb (Sarah)
(3,3);             -- Afro Vibes (Yanis)

