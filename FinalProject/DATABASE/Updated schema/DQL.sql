-- Task C5

-- 1. Query 
SELECT 
    S.stadur "Power_Plant_Source",
    EXTRACT(YEAR FROM G.timi) AS "Year",
    EXTRACT(MONTH FROM G.timi) AS "Month",
    M.tegund_maelingar AS "Type",
    SUM(G.gildi_kwh) AS "Total_kWh"
FROM gildin G
JOIN maeling M ON M.ID = G.maeling_ID
JOIN orku S on S.ID = M.orku_ID
WHERE EXTRACT(YEAR FROM G.timi) = 2025
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
    EXTRACT(YEAR FROM G.timi) AS "Year",
    EXTRACT(MONTH FROM G.timi) AS "Month",
    N.eigandi AS "Customer_name",
    SUM(G.gildi_kwh) AS "Total_kWh"
FROM gildin G
JOIN maeling M ON M.ID = G.maeling_ID
JOIN notandi N ON N.ID = G.notandi_ID
JOIN orku S ON S.ID = M.orku_ID
WHERE EXTRACT(YEAR FROM G.timi) = 2025
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
JOIN orku S ON S.ID = M.orku_ID
GROUP BY 
    S.stadur,
    EXTRACT(MONTH FROM G.timi)


SELECT "Power_Plant_Source", AVG("Plant_To_Sub_loss_Ratio"), AVG("Total_System_Loss_Ratio")
FROM monthly_plant_loss_ratio
GROUP BY "Power_Plant_Source"
ORDER BY "Power_Plant_Source"



CREATE OR REPLACE VIEW substation_distances AS
SELECT 
    t.STOD1, 
    t.STOD2,
    SQRT(POWER(h2.X_HNIT - h1.X_HNIT, 2) + POWER(h2.Y_HNIT - h1.Y_HNIT, 2)) AS dist
FROM tengdar_stodvar t
JOIN orku o1 ON t.STOD1 = o1.stadur
JOIN hnit h1 ON o1.hnit_id = h1.ID
JOIN orku o2 ON t.STOD2 = o2.stadur
JOIN hnit h2 ON o2.hnit_id = h2.ID
WHERE o1.id <> o2.id;

WITH measurement_totals AS (
    SELECT 
        -- Sum Innmötun for the plants -> S1
        SUM(CASE WHEN o.stadur IN ('P1_Þröstur', 'P2_Búrfell') 
                 AND m.tegund_maelingar = 'Innmötun' THEN g.gildi_kwh ELSE 0 END) as s1_inj,
        -- Sum Innmötun for the plant -> S2
        SUM(CASE WHEN o.stadur = 'P3_Strokkur' 
                 AND m.tegund_maelingar = 'Innmötun' THEN g.gildi_kwh ELSE 0 END) as s2_inj,
        -- Sum withdrawals (Úttekt) -> S3
        SUM(CASE WHEN m.tegund_maelingar = 'Úttekt' THEN g.gildi_kwh ELSE 0 END) as s3_with
    FROM gildin g
    JOIN maeling m ON g.maeling_ID = m.ID
    JOIN orku o ON m.orku_ID = o.ID
    -- WHERE g.timi >= '2025-01-01' AND g.timi <= '2025-12-31'
),
distances AS (
    SELECT 
        MAX(CASE WHEN STOD1 = 'S1_Krókur' AND STOD2 = 'S2_Rimakot' THEN dist_km END) as d12,
        MAX(CASE WHEN STOD1 = 'S2_Rimakot' AND STOD2 = 'S3_Vestmannaeyjar' THEN dist_km END) as d23
    FROM substation_distances
),
calculations AS (
    SELECT 
        s1_inj, s2_inj, s3_with, d12, d23,
        ((s1_inj + s2_inj) - s3_with) as total_loss,
        (d12 + d23) as total_dist
    FROM measurement_totals, distances
)
SELECT 
    -- Flow entering the wire at S1
    s1_inj AS flow_out_s1,
    
    -- Proportional loss on first segment
    (d12 / NULLIF(total_dist, 0)) * total_loss AS loss_s1_s2,
    
    -- Flow entering the wire at S2 (What arrived from S1 + New Injection at S2)
    (s1_inj - ((d12 / NULLIF(total_dist, 0)) * total_loss)) + s2_inj AS flow_out_s2,
    
    -- Proportional loss on second segment
    (d23 / NULLIF(total_dist, 0)) * total_loss AS loss_s2_s3
FROM calculations;


SELECT stadur
FROM orku

SELECT *
FROM substation_distances

SELECT o.stadur, m.tegund_maelingar, COUNT(g.id) as num_records
FROM orku o
JOIN maeling m ON o.id = m.orku_id
JOIN gildin g ON m.id = g.maeling_id
GROUP BY o.stadur, m.tegund_maelingar
ORDER BY num_records DESC;


