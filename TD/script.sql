-- ADMIN BDD TD final - DEV B
-- Auteur: Victor BETSCH
-- Date de rendue maximum : 06/12/2022 à 18h
-- Coefficient : 3
-- Temps conseillé : 8h
-- Sujet choisi: Plateforme de musiques (SpotHiFi)


--------------------- PARTIE 1 ---------------------

/*
    ----- EXPLICATION -----

    (Partie 1) Je vais ici créer une base de données sécurisée d'une plateforme de musiques (SpotHiFi).
    J'entends par "sécurisée" une base de données structurée constituée de tables
    (LISTENINGS, SONGS, PLAYLISTS, ALBUMS, ARTISTS, AUDITORS), de contraintes d'intégrité (PRIMARY KEY et FOREIGN KEY pour relier
    toutes les tables) et de tablespaces (TBS_LABELS, TBS_CLIENTS, TD_TBS_ARCHIVE, TBS_USERDATA).

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


-- TABLESPACES
CREATE TABLESPACE TD_TBS_LABELS
DATAFILE 'tbs_labels.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M
ONLINE;

CREATE TABLESPACE TD_TBS_CLIENTS
DATAFILE 'tbs_clients.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M
ONLINE;

CREATE UNDO TABLESPACE TD_TBS_ARCHIVE
DATAFILE 'tbs_archive.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M;

CREATE TEMPORARY TABLESPACE TD_TBS_USERDATA
TEMPFILE 'tbs_userdata.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M;


-- TABLES
CREATE TABLE SYSTEM.TD_ARTIST (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    NAME VARCHAR2(255) NOT NULL
);

CREATE TABLE SYSTEM.TD_ALBUM (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    NAME VARCHAR2(255) NOT NULL,
    RELEASE_DATE DATE NULL
)
TABLESPACE TD_TBS_LABELS;

CREATE TABLE SYSTEM.TD_AUDITOR (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    NAME VARCHAR2(255) NOT NULL,
    MAIL VARCHAR2(255) NULL,
    AGE NUMBER(8) NULL,
    COUNTRY VARCHAR2(255) NULL
)
TABLESPACE TD_TBS_CLIENTS;

CREATE TABLE SYSTEM.TD_SONG (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    NAME VARCHAR2(255) NOT NULL,
    PRICE FLOAT NULL,
    ALBUM_ID NUMBER(8) NULL,
    CONSTRAINT FK_SONG_ALBUM FOREIGN KEY (ALBUM_ID)
        REFERENCES TD_ALBUM(ID)
)
TABLESPACE TD_TBS_LABELS;

CREATE TABLE SYSTEM.TD_LISTENING (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    AUDITOR_ID NUMBER(8) NOT NULL,
    SONG_ID NUMBER(8) NOT NULL,
    LISTEN_DATE DATE NULL,
    CONSTRAINT FK_LISTENING_AUDITOR FOREIGN KEY (AUDITOR_ID)
        REFERENCES TD_AUDITOR(ID),
    CONSTRAINT FK_LISTENING_SONG FOREIGN KEY (SONG_ID)
        REFERENCES TD_SONG(ID)
);

CREATE TABLE SYSTEM.TD_PLAYLIST (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    NAME VARCHAR2(255) NOT NULL,
    AUDITOR_ID NUMBER(8) NOT NULL,
    CONSTRAINT FK_PLAYLIST_AUDITOR FOREIGN KEY (AUDITOR_ID)
        REFERENCES TD_AUDITOR(ID)
);

CREATE TABLE SYSTEM.TD_COMPOSED_OF (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    PLAYLIST_ID NUMBER(8) NOT NULL,
    SONG_ID NUMBER(8) NOT NULL,
    CONSTRAINT FK_COMPOSEDOF_PLAYLIST FOREIGN KEY (PLAYLIST_ID)
        REFERENCES TD_PLAYLIST(ID),
    CONSTRAINT FK_COMPOSEDOF_SONG FOREIGN KEY (SONG_ID)
        REFERENCES TD_SONG(ID)
);

CREATE TABLE SYSTEM.TD_PRODUCED_BY (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    SONG_ID NUMBER(8) NOT NULL,
    ARTIST_ID NUMBER(8) NOT NULL,
    CONSTRAINT FK_PRODUCEDBY_SONG FOREIGN KEY (SONG_ID)
        REFERENCES TD_SONG(ID),
    CONSTRAINT FK_PRODUCEDBY_ARTIST FOREIGN KEY (ARTIST_ID)
        REFERENCES TD_ARTIST(ID)
);

--------------------- PARTIE 2 ---------------------

-- PROFILES
CREATE PROFILE TD_PROFILE_COMMON LIMIT
    SESSIONS_PER_USER 8
    CPU_PER_SESSION UNLIMITED
    CPU_PER_CALL 2000
    CONNECT_TIME 200
    IDLE_TIME 10;

CREATE PROFILE TD_PROFILE_APP LIMIT
    FAILED_LOGIN_ATTEMPTS 5
    PASSWORD_LIFE_TIME 30
    PASSWORD_REUSE_TIME 60
    PASSWORD_REUSE_MAX 2
    PASSWORD_LOCK_TIME 5
    PASSWORD_GRACE_TIME 7;


-- ROLES
CREATE ROLE TD_ROLE_ADMIN IDENTIFIED EXTERNALLY;
CREATE ROLE TD_ROLE_CLIENT IDENTIFIED EXTERNALLY;


-- USERS
CREATE USER TD_USER_ADMIN
    TEMPORARY TABLESPACE TD_TBS_USERDATA
    IDENTIFIED BY adm1n;

CREATE USER TD_USER_PRODUCER
    IDENTIFIED BY pr0duc3r
    TEMPORARY TABLESPACE TD_TBS_USERDATA
    DEFAULT TABLESPACE TD_TBS_LABELS
    PROFILE TD_PROFILE_COMMON;

CREATE USER TD_USER_ARTIST
    IDENTIFIED BY art1st
    TEMPORARY TABLESPACE TD_TBS_USERDATA
    PROFILE TD_PROFILE_APP;

CREATE USER TD_USER_AUDITOR
    IDENTIFIED BY aud1t0r
    TEMPORARY TABLESPACE TD_TBS_USERDATA
    PROFILE TD_PROFILE_APP;


-- PRIVILEGES
GRANT CREATE SESSION TO TD_USER_ADMIN;
GRANT CREATE SESSION TO TD_USER_PRODUCER;
GRANT CREATE SESSION TO TD_USER_ARTIST;
GRANT CREATE SESSION TO TD_USER_AUDITOR;

GRANT TD_ROLE_ADMIN TO TD_USER_ADMIN;
GRANT TD_ROLE_CLIENT TO TD_USER_ARTIST;
GRANT TD_ROLE_CLIENT TO TD_USER_AUDITOR;

GRANT CREATE ANY TABLE, ALTER ANY TABLE, DROP ANY TABLE TO TD_ROLE_ADMIN;
GRANT SELECT ANY TABLE, UPDATE ANY TABLE, INSERT ANY TABLE, DELETE ANY TABLE TO TD_ROLE_ADMIN;

GRANT SELECT ON SYSTEM.TD_ARTIST TO TD_ROLE_CLIENT;
GRANT SELECT ON SYSTEM.TD_ALBUM TO TD_ROLE_CLIENT;
GRANT SELECT ON SYSTEM.TD_AUDITOR TO TD_ROLE_CLIENT;
GRANT SELECT ON SYSTEM.TD_SONG TO TD_ROLE_CLIENT;
GRANT SELECT ON SYSTEM.TD_LISTENING TO TD_ROLE_CLIENT;
GRANT SELECT ON SYSTEM.TD_PRODUCED_BY TO TD_ROLE_CLIENT;

GRANT SELECT, INSERT ON SYSTEM.TD_ARTIST TO TD_USER_PRODUCER;
GRANT SELECT, INSERT ON SYSTEM.TD_ALBUM TO TD_USER_PRODUCER;
GRANT SELECT, INSERT ON SYSTEM.TD_SONG TO TD_USER_PRODUCER;
GRANT SELECT, INSERT ON SYSTEM.TD_PRODUCED_BY TO TD_USER_PRODUCER;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYSTEM.TD_ARTIST TO TD_USER_ARTIST;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYSTEM.TD_AUDITOR TO TD_USER_AUDITOR;
GRANT SELECT, INSERT, UPDATE, DELETE ON SYSTEM.TD_PLAYLIST TO TD_USER_AUDITOR;