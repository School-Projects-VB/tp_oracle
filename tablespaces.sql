CREATE TABLESPACE EXERCICE_TBS
DATAFILE 'exo_tbs2.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M
ONLINE;

ALTER TABLESPACE EXERCICE_TBS
ADD DATAFILE 'exo_tbs3.dbf' SIZE 100K
AUTOEXTEND ON NEXT 10K
MAXSIZE 500K;

ALTER TABLESPACE EXERCICE_TBS
RENAME TO exo_tbs;

CREATE TEMPORARY TABLESPACE EXERCICE2_TBS
TEMPFILE 'Tbs_Temp_Exo.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M;