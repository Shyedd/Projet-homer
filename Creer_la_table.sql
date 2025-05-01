
CREATE TABLE Utilisateur (
    id_utilisateur NCHAR(30) PRIMARY KEY,
    mot_de_passe VARCHAR(MAX),
    pseudo VARCHAR(MAX),
    avatar BINARY,
    role BIT,
    est_bloqué BIT,
    horodate_creation DATETIME,
    date_naissance DATE
);


CREATE TABLE Message (
    id_message NCHAR(30) PRIMARY KEY,
    contenu VARCHAR(MAX),
    statut BIT,
    horodate_envoie DATE,
    id_utilisateur NCHAR(10),
    id_groupe NCHAR(30),
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur),
    FOREIGN KEY (id_groupe) REFERENCES Groupe(id_groupe)
);


CREATE TABLE Groupe (
    id_groupe NCHAR(10) PRIMARY KEY,
    nom VARCHAR(50),
    horodate_creation DATE
);


CREATE TABLE Etre_un_contact (
    id_utilisateur_1 NCHAR(30),
    id_utilisateur_2 NCHAR(30),
    favori_1 BIT,
    favori_2 BIT,
    en_attente BIT,
    PRIMARY KEY (id_utilisateur_1, id_utilisateur_2),
    FOREIGN KEY (id_utilisateur_1) REFERENCES Utilisateur(id_utilisateur),
    FOREIGN KEY (id_utilisateur_2) REFERENCES Utilisateur(id_utilisateur)
);


CREATE TABLE Appartenir (
    id_utilisateur NCHAR(30),
    id_groupe NCHAR(30),
    date_appartenance DATE,
    PRIMARY KEY (id_utilisateur, id_groupe),
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur),
    FOREIGN KEY (id_groupe) REFERENCES Groupe(id_groupe)
);