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
LIMIT 50;