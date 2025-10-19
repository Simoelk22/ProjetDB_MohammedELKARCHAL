- Reset complet de la base
DROP DATABASE IF EXISTS plateforme_musicale;
CREATE DATABASE plateforme_musicale
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE plateforme_musicale;

CREATE TABLE Artiste (
   id_artiste INT PRIMARY KEY AUTO_INCREMENT,
   nom_artiste VARCHAR(100) NOT NULL,
   pays VARCHAR(50),
   biographie TEXT,
   nb_abonnes INT DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE Abonne (
   id_abonne INT PRIMARY KEY AUTO_INCREMENT,
   nom VARCHAR(100) NOT NULL,
   email VARCHAR(150) NOT NULL,
   date_inscription DATE NOT NULL,
   UNIQUE KEY uq_abonne_email (email)
) ENGINE=InnoDB;


CREATE TABLE Playlist (
   id_playlist INT PRIMARY KEY AUTO_INCREMENT,
   nom_playlist VARCHAR(100) NOT NULL,
   date_creation DATE NOT NULL,
   publique BOOLEAN NOT NULL DEFAULT FALSE,
   date_modification DATE,
   id_abonne INT NOT NULL,
   CONSTRAINT fk_playlist_abonne
     FOREIGN KEY (id_abonne) REFERENCES Abonne(id_abonne)
     ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Album (
   id_album INT PRIMARY KEY AUTO_INCREMENT,
   titre_album VARCHAR(100) NOT NULL,
   date_sortie DATE,
   illustration VARCHAR(255),
   genre VARCHAR(50),
   duree_totale INT,
   id_artiste INT NOT NULL,
   CONSTRAINT fk_album_artiste
     FOREIGN KEY (id_artiste) REFERENCES Artiste(id_artiste)
     ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Morceau (
   id_morceau INT PRIMARY KEY AUTO_INCREMENT,
   titre_morceau VARCHAR(100) NOT NULL,
   duree INT,                       -- durée en secondes (optionnel)
   date_sortie DATE,
   nb_ecoutes INT DEFAULT 0,
   id_album INT NOT NULL,
   CONSTRAINT fk_morceau_album
     FOREIGN KEY (id_album) REFERENCES Album(id_album)
     ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Suivre (
   id_artiste INT NOT NULL,
   id_abonne INT NOT NULL,
   PRIMARY KEY (id_artiste, id_abonne),
   CONSTRAINT fk_suivre_artiste
     FOREIGN KEY (id_artiste) REFERENCES Artiste(id_artiste)
     ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT fk_suivre_abonne
     FOREIGN KEY (id_abonne) REFERENCES Abonne(id_abonne)
     ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Evaluation (
   id_morceau INT NOT NULL,
   id_abonne INT NOT NULL,
   note TINYINT NOT NULL,
   PRIMARY KEY (id_morceau, id_abonne),
   CONSTRAINT chk_note_1_5 CHECK (note BETWEEN 1 AND 5),
   CONSTRAINT fk_eval_morceau
     FOREIGN KEY (id_morceau) REFERENCES Morceau(id_morceau)
     ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT fk_eval_abonne
     FOREIGN KEY (id_abonne) REFERENCES Abonne(id_abonne)
     ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Contient (
   id_morceau INT NOT NULL,
   id_playlist INT NOT NULL,
   PRIMARY KEY (id_morceau, id_playlist),
   CONSTRAINT fk_contient_morceau
     FOREIGN KEY (id_morceau) REFERENCES Morceau(id_morceau)
     ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT fk_contient_playlist
     FOREIGN KEY (id_playlist) REFERENCES Playlist(id_playlist)
     ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
