-- Generated by Oracle SQL Developer Data Modeler 21.2.0.183.1957
--   at:        2021-12-17 11:27:50 EET
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE categorie (
    id_categorie NUMBER(2) NOT NULL,
    id_produs    NUMBER(10) NOT NULL
)
LOGGING;

ALTER TABLE categorie ADD CONSTRAINT categorie_pk PRIMARY KEY ( id_categorie,
                                                                id_produs );

CREATE TABLE categorii_animale (
    id_categorie       NUMBER(2) NOT NULL,
    denumire_categorie VARCHAR2(30) NOT NULL
)
LOGGING;

ALTER TABLE categorii_animale
    ADD CONSTRAINT categorii_animale_den_cat_ck CHECK ( ( length(denumire_categorie) > 3 )
                                                        AND ( REGEXP_LIKE ( denumire_categorie,
                                                                            '^[A-Za-z ]+$' ) ) );

ALTER TABLE categorii_animale ADD CONSTRAINT categorii_animale_pk PRIMARY KEY ( id_categorie );

ALTER TABLE categorii_animale ADD CONSTRAINT categorii_animale_denum_cat_un UNIQUE ( denumire_categorie );

CREATE TABLE clienti (
    nr_card     NUMBER(16) NOT NULL,
    nume_client VARCHAR2(40)
)
LOGGING;

ALTER TABLE clienti
    ADD CONSTRAINT clienti_nume_client_ck CHECK ( ( length(nume_client) > 3 )
                                                  AND ( REGEXP_LIKE ( nume_client,
                                                                      '^[A-Za-z ]+$' ) ) );

ALTER TABLE clienti ADD CONSTRAINT clienti_pk PRIMARY KEY ( nr_card );

ALTER TABLE clienti ADD CONSTRAINT clienti_nume_client_un UNIQUE ( nume_client );

CREATE TABLE detalii_clienti (
    nr_card       NUMBER(16) NOT NULL,
    "e-mail"      VARCHAR2(30),
    data_nasterii DATE,
    gen           CHAR(1),
    adresa        VARCHAR2(30),
    oras          VARCHAR2(20)
)
LOGGING;

ALTER TABLE detalii_clienti
    ADD CONSTRAINT "datelii_clienti_e-mail_ck" CHECK ( REGEXP_LIKE ( "e-mail",
                                                                     '[a-z0-9._%-]+@[a-z0-9._%-]+\.[a-z]{2,4}' ) );

CREATE UNIQUE INDEX detalii_clienti__idx ON
    detalii_clienti (
        nr_card
    ASC )
        LOGGING;

ALTER TABLE detalii_clienti ADD CONSTRAINT "detalii_clienti_e-mail_UN" UNIQUE ( "e-mail" );

CREATE TABLE furnizori (
    id_furnizor       NUMBER(3) NOT NULL,
    denumire_furnizor VARCHAR2(25) NOT NULL
)
LOGGING;

ALTER TABLE furnizori
    ADD CONSTRAINT furnizori_denum_furnizor_ck CHECK ( ( length(denumire_furnizor) > 3 )
                                                       AND ( REGEXP_LIKE ( denumire_furnizor,
                                                                           '^[A-Za-z ]+$' ) ) );

ALTER TABLE furnizori ADD CONSTRAINT furnizori_pk PRIMARY KEY ( id_furnizor );

ALTER TABLE furnizori ADD CONSTRAINT furnizori_denumire_furnizor_un UNIQUE ( denumire_furnizor );

CREATE TABLE produse (
    id_produs       NUMBER(10) NOT NULL,
    denumire_produs VARCHAR2(30) NOT NULL,
    stoc            NUMBER(4) NOT NULL,
    pret            NUMBER(7, 2) NOT NULL,
    um              VARCHAR2(3) NOT NULL,
    id_tip          NUMBER(2) NOT NULL,
    id_furnizor     NUMBER(3) NOT NULL
)
LOGGING;

ALTER TABLE produse
    ADD CONSTRAINT produse_denumire_produs_ck CHECK ( length(denumire_produs) > 2 );

ALTER TABLE produse ADD CONSTRAINT produse_stoc_ck CHECK ( stoc > 0 );

ALTER TABLE produse ADD CONSTRAINT produse_pret_ck CHECK ( pret > 0 );

ALTER TABLE produse
    ADD CHECK ( um IN ( 'L', 'buc', 'g', 'kg', 'mL' ) );

ALTER TABLE produse ADD CONSTRAINT produse_pk PRIMARY KEY ( id_produs );

CREATE TABLE tipuri_produse (
    id_tip       NUMBER(2)    NOT NULL,
    denumire_tip VARCHAR2(25) NOT NULL
)
LOGGING;

ALTER TABLE tipuri_produse
    ADD CONSTRAINT tipuri_produse_denumire_tip_ck CHECK ( ( length(denumire_tip) > 3 )
                                                          AND ( REGEXP_LIKE ( denumire_tip,
                                                                              '^[A-Za-z ]+$' ) ) );

ALTER TABLE tipuri_produse ADD CONSTRAINT tipuri_produse_pk PRIMARY KEY ( id_tip );

ALTER TABLE tipuri_produse ADD CONSTRAINT tipuri_produse_denumire_tip_un UNIQUE ( denumire_tip );

CREATE TABLE vanzari (
    nr_card         NUMBER(16) NOT NULL,
    id_produs       NUMBER(10) NOT NULL,
    nr_bon          NUMBER(10) NOT NULL,
    cantitate       NUMBER(2)  NOT NULL,
    data_achizitiei DATE
)
LOGGING;

ALTER TABLE vanzari ADD CONSTRAINT vanzari_pk PRIMARY KEY ( nr_bon );

ALTER TABLE categorie
    ADD CONSTRAINT categorie_categorii_animale_fk FOREIGN KEY ( id_categorie )
        REFERENCES categorii_animale ( id_categorie )
    NOT DEFERRABLE;

ALTER TABLE categorie
    ADD CONSTRAINT categorie_produse_fk FOREIGN KEY ( id_produs )
        REFERENCES produse ( id_produs )
    NOT DEFERRABLE;

ALTER TABLE detalii_clienti
    ADD CONSTRAINT detalii_clienti_clienti_fk FOREIGN KEY ( nr_card )
        REFERENCES clienti ( nr_card )
    NOT DEFERRABLE;

ALTER TABLE produse
    ADD CONSTRAINT produse_furnizori_fk FOREIGN KEY ( id_furnizor )
        REFERENCES furnizori ( id_furnizor )
    NOT DEFERRABLE;

ALTER TABLE produse
    ADD CONSTRAINT produse_tipuri_produse_fk FOREIGN KEY ( id_tip )
        REFERENCES tipuri_produse ( id_tip )
    NOT DEFERRABLE;

ALTER TABLE vanzari
    ADD CONSTRAINT vanzari_clienti_fk FOREIGN KEY ( nr_card )
        REFERENCES clienti ( nr_card )
    NOT DEFERRABLE;

ALTER TABLE vanzari
    ADD CONSTRAINT vanzari_produse_fk FOREIGN KEY ( id_produs )
        REFERENCES produse ( id_produs )
    NOT DEFERRABLE;

CREATE OR REPLACE TRIGGER trg_vanzari_BRIU 
    BEFORE INSERT OR UPDATE ON vanzari 
    FOR EACH ROW 
BEGIN
	IF( :new.data_achizitiei <= TO_DATE('01.01.2000', 'DD.MM.YYYY') )
	THEN
		RAISE_APPLICATION_ERROR( -20001,
		'Data invalida: ' || TO_CHAR( :new.data_achizitiei, 'DD.MM.YYYY HH24:MI:SS' ) || ' trebuie sa fie mai mare decat data deschiderii magazinului.' );
END IF;
END; 
/

CREATE SEQUENCE categorii_animale_id_categorie START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER categorii_animale_id_categorie BEFORE
    INSERT ON categorii_animale
    FOR EACH ROW
    WHEN ( new.id_categorie IS NULL )
BEGIN
    :new.id_categorie := categorii_animale_id_categorie.nextval;
END;
/

CREATE SEQUENCE clienti_nr_card_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER clienti_nr_card_trg BEFORE
    INSERT ON clienti
    FOR EACH ROW
    WHEN ( new.nr_card IS NULL )
BEGIN
    :new.nr_card := clienti_nr_card_seq.nextval;
END;
/

CREATE SEQUENCE furnizori_id_furnizor_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER furnizori_id_furnizor_trg BEFORE
    INSERT ON furnizori
    FOR EACH ROW
    WHEN ( new.id_furnizor IS NULL )
BEGIN
    :new.id_furnizor := furnizori_id_furnizor_seq.nextval;
END;
/

CREATE SEQUENCE produse_id_produs_seq START WITH 1000 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER produse_id_produs_trg BEFORE
    INSERT ON produse
    FOR EACH ROW
    WHEN ( new.id_produs IS NULL )
BEGIN
    :new.id_produs := produse_id_produs_seq.nextval;
END;
/

CREATE SEQUENCE tipuri_produse_id_tip_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER tipuri_produse_id_tip_trg BEFORE
    INSERT ON tipuri_produse
    FOR EACH ROW
    WHEN ( new.id_tip IS NULL )
BEGIN
    :new.id_tip := tipuri_produse_id_tip_seq.nextval;
END;
/

CREATE SEQUENCE vanzari_nr_bon_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER vanzari_nr_bon_trg BEFORE
    INSERT ON vanzari
    FOR EACH ROW
    WHEN ( new.nr_bon IS NULL )
BEGIN
    :new.nr_bon := vanzari_nr_bon_seq.nextval;
END;
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             8
-- CREATE INDEX                             1
-- ALTER TABLE                             28
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           7
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          6
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
