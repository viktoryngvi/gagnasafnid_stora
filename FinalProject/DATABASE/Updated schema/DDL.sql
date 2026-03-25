-- Task C3

CREATE TABLE orku_stodvar_eigandi(    --stod er að ná í þetta
    ID              PRIMARY KEY SERIAL,
    heiti_eigandans VARCHAR,--eigandi í orku_einingar
);     --þetta er þjónustufyrirtækiðCREATE VIEW monthly_plant_loss_ratio AS

CREATE TABLE hnit (
    ID          PRIMARY KEY SERIAL,
    X_HNIT      DOUBLE PRECISION,
    Y_HNIT      DOUBLE PRECISION
);

CREATE TABLE orku(
    ID                  INT PRIMARY KEY SERIAL,
    stadur              VARCHAR NOT NULL UNIQUE,
    dagsetning_uppsett  DATE NOT NULL,
    hnit_id             INT NOT NULL,
    stodvar_id          INT NOT NULL,
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
    ID          PRIMARY KEY SERIAL,
    hnit_id     INT,    --KEY
    stadsetning VARCHAR NOT NULL,   --heiti
    kennitala   VARCHAR NOT NULL UNIQUE,
    eigandi     VARCHAR NOT NULL,
    ar_stofnad  VARCHAR NOT NULL,   --ar_stofnað í notendur_skranning
    FOREIGN KEY(hnit_id) REFERENCES hnit(ID)
);    --þetta er fyrirtæki sem er að nota þjónustuna


CREATE TABLE maeling(
    ID                  PRIMARY KEY SERIAL,
    orku_ID             INT,
    sendandi_maelingar  VARCHAR NOT NULL,
    tegund_maelingar    VARCHAR NOT NULL,
    timi                TIMESTAMP NOT NULL,
    FOREIGN KEY (orku_ID) REFERENCES orku(ID)
);

CREATE TABLE gildin(
    ID              PRIMARY KEY SERIAL,
    maeling_ID      INT,
    notandi_ID      INT NULL,
    gildi_kwh       NUMERIC NOT NULL,
    FOREIGN KEY (notandi_ID) REFERENCES notandi(ID)
    FOREIGN KEY (maeling_ID) REFERENCES maeling(ID)
);


-- Task D1