-- Task C3

CREATE TABLE orku_stodvar_eigandi(    --stod er að ná í þetta
    ID              SERIAL PRIMARY KEY,
    heiti_eigandans VARCHAR,--eigandi í orku_einingar
);     --þetta er þjónustufyrirtækiðCREATE VIEW monthly_plant_loss_ratio AS

CREATE TABLE hnit (
    ID          SERIAL PRIMARY KEY,
    X_HNIT      DOUBLE PRECISION,
    Y_HNIT      DOUBLE PRECISION
);

CREATE TABLE orku(
    ID                  SERIAL PRIMARY KEY,
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
    ID          SERIAL PRIMARY KEY,
    hnit_id     INT,    --KEY
    stadsetning VARCHAR NOT NULL,   --heiti
    kennitala   VARCHAR NOT NULL UNIQUE,
    eigandi     VARCHAR NOT NULL,
    ar_stofnad  VARCHAR NOT NULL,   --ar_stofnað í notendur_skranning
    FOREIGN KEY(hnit_id) REFERENCES hnit(ID)
);    --þetta er fyrirtæki sem er að nota þjónustuna


CREATE TABLE maeling(
    ID                  SERIAL PRIMARY KEY,
    orku_ID             INT,
    sendandi_maelingar  INT,
    tegund_maelingar    VARCHAR NOT NULL,
    FOREIGN KEY (orku_ID) REFERENCES orku(ID)
);

CREATE TABLE gildin(
    ID              SERIAL PRIMARY KEY,
    maeling_ID      INT,
    notandi_ID      INT NULL,
    gildi_kwh       NUMERIC NOT NULL,
    timi            TIMESTAMP NOT NULL,
    FOREIGN KEY (notandi_ID) REFERENCES notandi(ID)
    FOREIGN KEY (maeling_ID) REFERENCES maeling(ID)
);

CREATE TABLE new_one(
    ID          INT,
    orku_ID     INT,
    sendandi_maelingar  INT,
    tegund_maelingar    VARCHAR,
    FOREIGN KEY (orku_ID) REFERENCES orku(ID)
    FOREIGN KEY (sendandi_maelingar) REFERENCES something(ID)
);



-- CREATE TABLE maeling_sendandi (
--     ID SERIAL PRIMARY KEY,
--     sendanda_tegund VARCHAR NOT NULL CHECK (sendanda_tegund IN ('ORKA', 'EIGANDI'))
-- );
-- CREATE TABLE orku_stodvar_eigandi (
--     ID INT PRIMARY KEY REFERENCES maeling_sendandi(ID),
--     heiti_eigandans VARCHAR
-- );

-- CREATE TABLE orku (
--     ID INT PRIMARY KEY REFERENCES maeling_sendandi(ID),
--     stadur VARCHAR NOT NULL UNIQUE,
--     dagsetning_uppsett DATE NOT NULL,
--     hnit_id INT NOT NULL REFERENCES hnit(ID),
--     stodvar_id INT NOT NULL REFERENCES orku_stodvar_eigandi(ID)
-- );


-- CREATE TABLE maeling (
--     ID                  SERIAL PRIMARY KEY,
--     orku_ID             INT REFERENCES orku(ID),

--     -- Two specific foreign keys
--     sender_orku_id      INT REFERENCES orku(ID),
--     sender_eigandi_id   INT REFERENCES orku_stodvar_eigandi(ID),

--     tegund_maelingar    VARCHAR NOT NULL,

--     -- This constraint ensures you can't have both or neither
--     CONSTRAINT logical_sender CHECK (
--         (sender_orku_id IS NOT NULL AND sender_eigandi_id IS NULL) OR
--         (sender_orku_id IS NULL AND sender_eigandi_id IS NOT NULL)
--     )
-- );












SELECT *
FROM orku_stodvar_eigandi
LIMIT 10;

SELECT *
FROM gildin
LIMIT 1000;

SELECT *
FROM maeling
LIMIT 1000;

SELECT *
FROM notandi
LIMIT 100;

SELECT *
FROM tengdar_stodvar
LIMIT 100;

SELECT *
FROM orku
LIMIT 100;

SELECT *
FROM hnit
LIMIT 100;



-- Task D1