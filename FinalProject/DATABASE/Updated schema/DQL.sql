-- Task C5

-- 1. Query 
SELECT 
    S.stadur "Power_Plant_Source",
    EXTRACT(YEAR FROM M.timi) AS "Year",
    EXTRACT(MONTH FROM M.timi) AS "Month",
    M.tegund_maelingar AS "Type",
    SUM(G.gildi_kwh) AS "Total_kWh"
FROM gildin G
JOIN maeling M ON M.ID = G.maeling_ID
JOIN stod S on S.ID = M.stod_ID
WHERE EXTRACT(YEAR FROM M.timi) = 2025
GROUP BY
    S.stadur,
    "Year",
    "Month",
    M.tegund_maelingar
ORDER BY 
    "Power_Plant_Source" ASC, 
    "Month" ASC, 
    "Total_kWh" DESC


-- 2. Query SEMI SEMI 
SELECT 
    S.stadur "Power_Plant_Source",
    EXTRACT(YEAR FROM M.timi) AS "Year",
    EXTRACT(MONTH FROM M.timi) AS "Month",
    N.eigandi AS "Customer_name",
    SUM(G.gildi_kwh) AS "Total_kWh"
FROM gildin G
JOIN maeling M ON M.ID = G.maeling_ID
JOIN notandi N ON N.ID = G.notandi_ID
JOIN stod S ON S.ID = M.stod_ID
WHERE EXTRACT(YEAR FROM M.timi) = 2025
GROUP BY
    S.stadur,
    "Year",
    "Month",
    N.eigandi
ORDER BY 
    "Power_Plant_Source" ASC, 
    "Month" ASC, 
    "Customer_name" ASC

    
-- 3. Query 
CREATE VIEW monthly_plant_loss_ratio AS
SELECT   
    s.stadur AS "Power_Plant_Source",
    (SUM(CASE WHEN M.tegund_maelingar = 'Framleiðsla' THEN G.gildi_kwh ELSE 0 END)
      -
     SUM(CASE WHEN M.tegund_maelingar = 'Innmötun' THEN G.gildi_kwh ELSE 0 END))
      /
     NULLIF(
        SUM(CASE WHEN M.tegund_maelingar = 'Framleiðsla' THEN G.gildi_kwh ELSE 0 END),
        0
    ) AS "Plant_To_Sub_loss_Ratio",
    (SUM(CASE WHEN M.tegund_maelingar = 'Framleiðsla' THEN G.gildi_kwh ELSE 0 END)
      -
     SUM(CASE WHEN M.tegund_maelingar = 'Úttekt' THEN G.gildi_kwh ELSE 0 END))
      /
     NULLIF(
        SUM(CASE WHEN M.tegund_maelingar = 'Framleiðsla' THEN G.gildi_kwh ELSE 0 END),
        0
    ) AS "Total_System_Loss_Ratio"
FROM gildin G
JOIN maeling M ON M.ID = G.maeling_ID
JOIN stod S ON S.ID = M.stod_ID
GROUP BY 
    s.stadur,
    EXTRACT(MONTH FROM M.timi)


SELECT "Power_Plant_Source", AVG("Plant_To_Sub_loss_Ratio"), AVG("Total_System_Loss_Ratio")
FROM monthly_plant_loss_ratio
GROUP BY "Power_Plant_Source"
ORDER BY "Power_Plant_Source"