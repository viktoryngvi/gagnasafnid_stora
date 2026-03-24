-- Task C3

CREATE TABLE orku_stodvar_eigandi(    --stod er að ná í þetta
    ID              PRIMARY KEY,
    heiti_eigandans VARCHAR  --eigandi í orku_einingar 
);     --þetta er þjónustufyrirtækið

CREATE TABLE hnit (
    ID          PRIMARY KEY,
    X_HNIT      DOUBLE PRECISION,
    Y_HNIT      DOUBLE PRECISION,
);

CREATE TABLE notandi (
    ID          PRIMARY KEY,
    hnit_id     INT,    --KEY
    staðsetning VARCHAR NOT NULL,   --heiti
    kennitala   INT NOT NULL UNIQUE,
    eigandi     VARCHAR NOT NULL,
    ar_stofnad  DATE NOT NULL,   --ar_stofnað í notendur_skranning
    FOREIGN KEY(hnit_id) REFERENCES hnit(ID)
);    --þetta er fyrirtæki sem er að nota þjónustuna

CREATE TABLE stod ( 
    ID                  PRIMARY KEY,
    hnit_id             INT,    --KEY
    eigandi_ID          INT,    --KEY
    stadur              VARCHAR NOT NULL, -- heiti í orku_einingar
    ar_uppsett          DATE NOT NULL,   --Jeremias er að spyrja hildi hvort þetta er stöð eða orku_stodvar_eigandi
    hvort_dat_se_stod   VARCHAR,   --þarf annað nafn
    tegund              VARCHAR NOT NULL,
    FOREIGN KEY(eigandi_ID) REFERENCES orku_stodvar_eigandi(ID),
    FOREIGN KEY(hnit_id) REFERENCES hnit(ID)
);

CREATE TABLE tengdar_stodvar (
    STOD1_ID        INT,
    STOD2_ID        INT,
    FOREIGN KEY(STOD1_ID) REFERENCES stod(ID),
    FOREIGN KEY(STOD2_ID) REFERENCES stod(ID)
);

CREATE TABLE orku_maelingar(
    ID                      PRIMARY KEY,
    STOD_ID                 INT,     -- KEY
    notandi                 INT,     -- notandi fyrirtæki
    date_og_timi            DATETIME NOT NULL,
    tegund_maelingar        VARCHAR NOT NULL,
    gildi_kwh               NUMERIC NOT NULL,
    FOREIGN KEY(notandi) REFERENCES notandi(ID),
    FOREIGN KEY(STOD_ID) REFERENCES stod(ID)  --auka dót til að skrá hvaða stöð er með orku og eigandann
);     -- fyrst að orku_mælingin þarf orku_stoðvar_eigandann er það þá ekki transitive dependancy?





SELECT eining_heiti
FROM raforka_legacy.orku_maelingar
LIMIT 60;

SELECT heiti, eigandi
FROM raforka_legacy.notendur_skraning; 
-- notandi fyrirtæki

SELECT heiti, eigandi, tegund, tegund_stod, tengd_stod
FROM raforka_legacy.orku_einingar;
--þjónustufyrirtækin sjálf









-- Task D1