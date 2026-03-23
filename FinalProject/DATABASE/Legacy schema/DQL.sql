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
LIMIT 10;

-- 3. Query 
