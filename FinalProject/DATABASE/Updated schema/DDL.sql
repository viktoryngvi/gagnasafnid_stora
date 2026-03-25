-- Task C3

CREATE TABLE orku_stodvar_eigandi(    --stod er að ná í þetta
    ID              PRIMARY KEY AUTO_INCREMENT,
    heiti_eigandans VARCHAR  --eigandi í orku_einingar 
);     --þetta er þjónustufyrirtækið

CREATE TABLE hnit (
    ID          PRIMARY KEY AUTO_INCREMENT,
    X_HNIT      DOUBLE PRECISION,
    Y_HNIT      DOUBLE PRECISION,
);

CREATE TABLE notandi (
    ID          PRIMARY KEY AUTO_INCREMENT,
    hnit_id     INT,    --KEY
    stadsetning VARCHAR NOT NULL,   --heiti
    kennitala   INT NOT NULL UNIQUE,
    eigandi     VARCHAR NOT NULL,
    ar_stofnad  DATE NOT NULL,   --ar_stofnað í notendur_skranning
    FOREIGN KEY(hnit_id) REFERENCES hnit(ID)
);    --þetta er fyrirtæki sem er að nota þjónustuna

CREATE TABLE stod ( 
    ID                  PRIMARY KEY AUTO_INCREMENT,
    hnit_id             INT,    --KEY
    eigandi_ID          INT,    --KEY
    stadur              VARCHAR NOT NULL, -- heiti í orku_einingar
    dagsetning_uppsett  DATE NOT NULL,   --Jeremias er að spyrja hildi hvort þetta er stöð eða orku_stodvar_eigandi
    hvort_dat_se_stod   VARCHAR,   --þarf annað nafn
    tegund              VARCHAR NOT NULL,
    FOREIGN KEY(eigandi_ID) REFERENCES orku_stodvar_eigandi(ID),
    FOREIGN KEY(hnit_id) REFERENCES hnit(ID)
);

CREATE TABLE tengdar_stodvar (
    STOD1        VARCHAR,
    STOD2        VARCHAR,
    PRIMARY KEY(STOD1, STOD2)
    FOREIGN KEY(STOD1) REFERENCES stod(stadur),
    FOREIGN KEY(STOD2) REFERENCES stod(stadur)
);

-- CREATE TABLE orku_maelingar(
--     ID                  PRIMARY KEY AUTO_INCREMENT,
--     STOD_ID             INT,     -- KEY
--     notandi             INT,     -- notandi fyrirtæki
--     date_og_timi        DATETIME NOT NULL,
--     tegund_maelingar    VARCHAR NOT NULL,
--     gildi_kwh           NUMERIC NOT NULL,
--     FOREIGN KEY(notandi) REFERENCES notandi(ID),
--     FOREIGN KEY(STOD_ID) REFERENCES stod(ID)  --auka dót til að skrá hvaða stöð er með orku og eigandann
-- );

CREATE TABLE maeling(
    ID                  SERIAL PRIMARY KEY AUTO_INCREMENT,
    STOD_ID             INT,
    sendandi_maelingar  VARCHAR NOT NULL,
    tegund_maelingar    VARCHAR NOT NULL,
    timi            DATETIME NOT NULL,
);

CREATE TABLE gildin(
    ID              SERIAL PRIMARY KEY AUTO_INCREMENT,
    maeling_ID      INT,
    notandi_ID      INT NULL,
    gildi_kwh       NUMERIC NOT NULL,
    FOREIGN KEY (notandi_ID) REFERENCES notandi(ID)
    FOREIGN KEY (maeling_ID) REFERENCES maeling(ID)
);



SELECT *
FROM raforka_legacy.orku_maelingar
LIMIT 60;

SELECT heiti, eigandi
FROM raforka_legacy.notendur_skraning; 
-- notandi fyrirtæki

SELECT heiti, eigandi, tegund, tegund_stod, tengd_stod
FROM raforka_legacy.orku_einingar;

SELECT *
FROM raforka_legacy.orku_einingar;

SELECT "X_HNIT", "Y_HNIT"
FROM raforka_legacy.orku_einingar;

SELECT ar_uppsett, manudir_uppsett, dagur_uppsett
FROM raforka_legacy.orku_einingar;
--þjónustufyrirtækin sjálf









-- Task D1