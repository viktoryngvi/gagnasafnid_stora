-- Task C3

CREATE TABLE orku_stodvar_eigandi(    --stod er að ná í þetta
    ID              PRIMARY KEY AUTO_INCREMENT,
    heiti_eigandans VARCHAR, --eigandi í orku_einingar
);     --þetta er þjónustufyrirtækiðCREATE VIEW monthly_plant_loss_ratio AS

CREATE TABLE hnit (
    ID          PRIMARY KEY AUTO_INCREMENT,
    X_HNIT      DOUBLE PRECISION,
    Y_HNIT      DOUBLE PRECISION
);

CREATE TABLE orku(
    ID          INT PRIMARY KEY AUTO_INCREMENT,
    stadur      VARCHAR NOT NULL,
    dagur_uppsett DATE NOT NULL,
    hnit_id     INT NOT NULL,
    stodvar_id  INT NOT NULL,
    FOREIGN KEY(hnit_id) REFERENCES hnit(ID),
    FOREIGN KEY(stodvar_id) REFERENCES orku_stodvar_eigandi(ID)
);

CREATE TABLE virkjun(
    ID          INT PRIMARY KEY REFERENCES orku(ID),
    tegund      VARCHAR NOT NULL
);

CREATE TABLE stod ( 
    ID          INT PRIMARY KEY REFERENCES orku(ID),
    tegund      VARCHAR NOT NULL
);

CREATE TABLE tengdar_stodvar (
    STOD1        VARCHAR,
    STOD2        VARCHAR,
    PRIMARY KEY(STOD1, STOD2),
    FOREIGN KEY(STOD1) REFERENCES orku(stadur),
    FOREIGN KEY(STOD2) REFERENCES orku(stadur)
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


CREATE TABLE maeling(
    ID                  PRIMARY KEY AUTO_INCREMENT,
    orku_id             INT,
    sendandi_maelingar  VARCHAR NOT NULL,
    tegund_maelingar    VARCHAR NOT NULL,
    timi            DATETIME NOT NULL,
    FOREIGN KEY (orku_id) REFERENCES orku(ID)
);

CREATE TABLE gildin(
    ID              PRIMARY KEY AUTO_INCREMENT,
    maeling_ID      INT,
    notandi_ID      INT NULL,
    gildi_kwh       NUMERIC NOT NULL,
    FOREIGN KEY (notandi_ID) REFERENCES notandi(ID)
    FOREIGN KEY (maeling_ID) REFERENCES maeling(ID)
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