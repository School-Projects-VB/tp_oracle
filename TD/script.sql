-- ADMIN BDD TD final - DEV B
-- Auteur: Victor BETSCH
-- Date de rendue maximum : 06/12/2022 à 18h
-- Coefficient : 3
-- Temps conseillé : 8h
-- Sujet choisi: Plateforme de musiques (SpotHiFi)

-- PARTIE 1

/*
    ----- EXPLICATION -----

    (Partie 1) Je vais ici créer une base de données sécurisée d'une plateforme de musiques (SpotHiFi).
    J'entends par "sécurisée" une base de données structurée constituée de tables
    (LISTENINGS, SONGS, PLAYLISTS, ALBUMS, ARTISTS, AUDITORS), de contraintes d'intégrité (PRIMARY KEY et FOREIGN KEY pour relier
    toutes les tables) et de tablespaces (TBS_LABELS, TBS_CLIENTS, TBS_USERDATA).

    (Partie 2) La base sera administrée par 4 utilisateurs (ADMIN, PRODUCER, ARTIST, AUDITOR) ayants des privilèges
    associés à leurs rôles respectifs (ADMIN et CLIENT) et des limites associées à leurs profils (COMMON et APP).
    Ils seront associés aux tablespaces qui leur convient.
    Les nouvelles fonctionnalités envisagées par le chef de projet impliquent la création de requêtes complexes
    ("The trendiest album", "The frequency of album published per month", "The number of listeners per country",
    "The most productive artists"), de vues ("Price per album", "The best song of the year", "Your number of listenings in the year",
    "Your last 10 albums listened to"), de fonctions ("The last music listened to by a user",
    "The history of the music listened to") et d'une instruction composée permettant de créer un nouvel album lorsqu'on
    ajoute une musique avec un album non-existant.

*/

-- CONFIGURE SGA TO 999Mo
ALTER system SET sga_target=999M SCOPE=SPFILE;

-- CONFIGURE PGA TO 200Mo per user so 200*4 = 800Mo
ALTER system SET pga_aggregate_target=800M;