-- Task C3

CREATE TABLE notandi (
    ID          PRIMARY KEY,
    heiti       VARCHAR NOT NULL,
    kennitala   INT NOT NULL,
    eigandi     VARCHAR NOT NULL,
    skranning   DATE NOT NULL   -- ar_stofnað í notendur_skranning
    X_HNIT      DOUBLE PRECISION,
    Y_HNIT      DOUBLE PRECISION,
);    --þetta er fyrirtæki sem er að nota þjónustuna

CREATE TABLE orku_stodvar_eigandi(    --stod er að ná í þetta
    ID              PRIMARY KEY,
    heiti_eigandans VARCHAR,  --eigandi í orku_einingar 
);     --þetta er þjónustufyrirtækið

CREATE TABLE stod ( 
    ID                  PRIMARY KEY,
    heiti               VARCHAR NOT NULL, -- heiti í orku einingar??
    eigandi_ID          INT,
    hvort_dat_se_stod   VARCHAR,   --þarf annað nafn
    tegund              VARCHAR NOT NULL,
    -- X_HNIT              DOUBLE PRECISION,
    -- Y_HNIT              DOUBLE PRECISION,   --þarf annað hvort að vera hér eða í orku_einingum
    FOREIGN KEY(eigandi_ID) REFERENCES orku_stodvar_eigandi(ID)
);

CREATE TABLE tengdar_stodvar (
    STOD1_ID,
    STOD2_ID,
    FOREIGN KEY(STOD1_ID) REFERENCES stod(ID),
    FOREIGN KEY(STOD2_ID) REFERENCES stod(ID)
);


CREATE TABLE orku_einingar(
    tegund_stod_ID      INT,
    skranning           DATE NOT NULL, -- dagsetning
    -- X_HNIT              DOUBLE PRECISION,
    -- Y_HNIT              DOUBLE PRECISION,   --þarf annað hvort að vera hér eða í orku_einingum
    FOREIGN KEY(tegund_stod_ID) REFERENCES stod(ID)
);



CREATE TABLE orku_maelingar(
    ID                      PRIMARY KEY,
    notandi                 INT,     -- notandi fyrirtæki
    date_og_timi            DATETIME NOT NULL,
    sendandi_maelingar      INT,  -- þjónustufyrirtæki
    tegund_maelingar        VARCHAR NOT NULL,
    gildi_kwh               NUMERIC NOT NULL,
    STOD_ID                 INT,
    FOREIGN KEY(notandi) REFERENCES notandi(ID),
    FOREIGN KEY(sendandi_maelingar) REFERENCES orku_stodvar_eigandi(ID),
    FOREIGN KEY(STOD_ID) REFERENCES stod(ID)  --auka dót til að skrá hvaða stöð er með orku
);


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