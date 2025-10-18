USE plateforme_musicale;

-- 1) Unicité de l’email
ALTER TABLE Abonne
  ADD CONSTRAINT uq_abonne_email UNIQUE (email);

-- 2) Règles de cohérence basiques
ALTER TABLE Artiste
  ADD CONSTRAINT ck_artiste_nb_abonnes CHECK (nb_abonnes >= 0);

-- durée positive (ou NULL si inconnue)
ALTER TABLE Morceau
  ADD CONSTRAINT ck_morceau_duree CHECK (duree IS NULL OR duree > 0);

-- nb_ecoutes ne doit pas être négatif
ALTER TABLE Morceau
  ADD CONSTRAINT ck_morceau_nb_ecoutes CHECK (nb_ecoutes >= 0);

-- note entre 1 et 5
ALTER TABLE Evaluation
  ADD CONSTRAINT ck_eval_note CHECK (note BETWEEN 1 AND 5);

-- 3) Index utiles (jointures / perfs)
CREATE INDEX ix_album_artiste   ON Album(id_artiste);
CREATE INDEX ix_morceau_album   ON Morceau(id_album);
CREATE INDEX ix_playlist_abonne ON Playlist(id_abonne);
CREATE INDEX ix_eval_morceau    ON Evaluation(id_morceau);
CREATE INDEX ix_eval_abonne     ON Evaluation(id_abonne);
