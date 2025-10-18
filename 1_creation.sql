CREATE DATABASE IF NOT EXISTS plateforme_musicale;
USE plateforme_musicale;

CREATE TABLE Artiste (
   id_artiste INT PRIMARY KEY,
   nom_artiste VARCHAR(100),
   pays VARCHAR(50),
   biographie TEXT,
   nb_abonnes INT
);

CREATE TABLE Abonne (
   id_abonne INT PRIMARY KEY,
   nom VARCHAR(100),
   email VARCHAR(150),
   date_inscription DATE
);

CREATE TABLE Playlist (
   id_playlist INT PRIMARY KEY,
   nom_playlist VARCHAR(100),
   date_creation DATE,
   publique BOOLEAN NOT NULL,
   date_modification DATE,
   id_abonne INT NOT NULL,
   FOREIGN KEY (id_abonne) REFERENCES Abonne(id_abonne)
);

CREATE TABLE Album (
   id_album INT PRIMARY KEY,
   titre_album VARCHAR(100),
   date_sortie DATE,
   illustration VARCHAR(255),
   genre VARCHAR(50),
   duree_totale INT,
   id_artiste INT NOT NULL,
   FOREIGN KEY (id_artiste) REFERENCES Artiste(id_artiste)
);

CREATE TABLE Morceau (
   id_morceau INT PRIMARY KEY,
   titre_morceau VARCHAR(100),
   duree INT,
   date_sortie DATE,
   nb_ecoutes INT,
   id_album INT NOT NULL,
   FOREIGN KEY (id_album) REFERENCES Album(id_album)
);

CREATE TABLE Suivre (
   id_artiste INT,
   id_abonne INT,
   PRIMARY KEY (id_artiste, id_abonne),
   FOREIGN KEY (id_artiste) REFERENCES Artiste(id_artiste),
   FOREIGN KEY (id_abonne) REFERENCES Abonne(id_abonne)
);

CREATE TABLE Evaluation (
   id_morceau INT,
   id_abonne INT,
   note INT,
   PRIMARY KEY (id_morceau, id_abonne),
   FOREIGN KEY (id_morceau) REFERENCES Morceau(id_morceau),
   FOREIGN KEY (id_abonne) REFERENCES Abonne(id_abonne)
);

CREATE TABLE Contient (
   id_morceau INT,
   id_playlist INT,
   PRIMARY KEY (id_morceau, id_playlist),
   FOREIGN KEY (id_morceau) REFERENCES Morceau(id_morceau),
   FOREIGN KEY (id_playlist) REFERENCES Playlist(id_playlist)
);
