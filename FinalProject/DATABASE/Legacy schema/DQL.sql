-- Task A2
SELECT *
FROM raforka_legacy.orku_einingar
LIMIT 20;

SELECT *
FROM raforka_legacy.orku_einingar_id_seq

SELECT *
FROM raforka_legacy.orku_maelingar
LIMIT 20;

SELECT *
FROM raforka_legacy.orku_maelingar_id_seq

SELECT *
FROM raforka_legacy.orku_maelingar_pkey


-- 1. Query 
SELECT 
    M.eining_heiti AS "Power_Plant_Source",
    EXTRACT(YEAR FROM timi) AS "Year",
    EXTRACT(MONTH FROM timi) AS "Month",
    M.tegund_maelingar "Type",
    SUM(M.gildi_kwh) AS "Total_kWh"
FROM raforka_legacy.orku_maelingar M
WHERE EXTRACT(YEAR FROM timi) = 2025
GROUP BY 
    M.eining_heiti,
    "Year",
    "Month",
    M.tegund_maelingar
ORDER BY 
    "Power_Plant_Source" ASC, 
    "Month" ASC, 
    "Total_kWh" DESC
LIMIT 60;

-- 2. Query SEMI SEMI 

SELECT 
    M.eining_heiti AS "Power_Plant_Source",
    EXTRACT(YEAR FROM timi) AS "Year",
    EXTRACT(MONTH FROM timi) AS "Month",
    M.notandi_heiti AS "Customer_name",
    SUM(M.gildi_kwh) AS "Total_kWh"
FROM raforka_legacy.orku_maelingar M
WHERE EXTRACT(YEAR FROM timi) = 2025 AND M.notandi_heiti is NOT NULL
GROUP BY 
    M.eining_heiti,
    "Year",
    "Month",
    M.notandi_heiti
ORDER BY 
    "Power_Plant_Source" ASC, 
    "Month" ASC, 
    "Customer_name" ASC
LIMIT 50;

-- 3. Query 

CREATE VIEW monthly_plant_loss_ratio AS
SELECT 
    M.eining_heiti AS "Power_Plant_Source",
    (SUM(CASE WHEN M.tegund_maelingar = 'Framleiðsla' THEN M.gildi_kwh ELSE 0 END) 
      - 
     SUM(CASE WHEN M.tegund_maelingar = 'Innmötun' THEN M.gildi_kwh ELSE 0 END))
      / 
    NULLIF(
        SUM(CASE WHEN M.tegund_maelingar = 'Framleiðsla' THEN M.gildi_kwh ELSE 0 END), 
        0
    ) AS "Plant_To_Sub_loss_Ratio",

    (SUM(CASE WHEN M.tegund_maelingar = 'Framleiðsla' THEN M.gildi_kwh ELSE 0 END) 
      - 
     SUM(CASE WHEN M.tegund_maelingar = 'Úttekt' THEN M.gildi_kwh ELSE 0 END))
      / 
    NULLIF(
        SUM(CASE WHEN M.tegund_maelingar = 'Framleiðsla' THEN M.gildi_kwh ELSE 0 END), 
        0
    ) AS "Total_System_Loss_Ratio"
FROM raforka_legacy.orku_maelingar M
GROUP BY 
    M.eining_heiti,
    EXTRACT(MONTH FROM timi)

SELECT "Power_Plant_Source", AVG("Plant_To_Sub_loss_Ratio"), AVG("Total_System_Loss_Ratio")
FROM monthly_plant_loss_ratio
GROUP BY "Power_Plant_Source"
ORDER BY "Power_Plant_Source"



