# Task C5

from sqlalchemy.orm import Session
from sqlalchemy import text


'''
Service 1: get_monthly_energy_flow_data()
'''
def get_monthly_energy_flow_data(db: Session, from_date, to_date):
    query = text("""
        SELECT 
            O.stadur                            AS "Power_Plant_Source",
            EXTRACT(YEAR FROM G.timi)           AS "Year",
            EXTRACT(MONTH FROM G.timi)          AS "Month",
            M.tegund_maelingar                  AS "Type",
            SUM(G.gildi_kwh)                    AS "Total_kWh"
        FROM gildin G
        JOIN maeling M  ON M.ID = G.maeling_ID
        JOIN orku O     ON O.ID = M.orku_ID
        WHERE G.timi >= :from_date AND G.timi < :to_date
        GROUP BY
            O.stadur,
            EXTRACT(YEAR FROM G.timi),
            EXTRACT(MONTH FROM G.timi),
            M.tegund_maelingar
        ORDER BY 
            "Power_Plant_Source" ASC, 
            EXTRACT(MONTH FROM G.timi) ASC, 
            "Total_kWh" DESC;
    """)
    result = db.execute(query, {"from_date": from_date, "to_date": to_date})
    return [dict(row._mapping) for row in result]


'''
Service 2: get_monthly_company_usage_data()
'''
def get_monthly_company_usage_data(db: Session):
    query = text("""
        SELECT 
            O.stadur                            AS "Power_Plant_Source",
            EXTRACT(YEAR FROM G.timi)           AS "Year",
            EXTRACT(MONTH FROM G.timi)          AS "Month",
            N.eigandi                           AS "Customer_name",
            SUM(G.gildi_kwh)                    AS "Total_kWh"
        FROM gildin G
        JOIN maeling M  ON M.ID = G.maeling_ID
        JOIN notandi N  ON N.ID = G.notandi_ID
        JOIN orku O     ON O.ID = M.orku_ID
        WHERE EXTRACT(YEAR FROM G.timi) = 2025
        GROUP BY
            O.stadur,
            EXTRACT(YEAR FROM G.timi),
            EXTRACT(MONTH FROM G.timi),
            N.eigandi
        ORDER BY 
            "Power_Plant_Source" ASC, 
            EXTRACT(MONTH FROM G.timi) ASC, 
            "Customer_name" ASC;
    """)
    result = db.execute(query)
    return [dict(row._mapping) for row in result]


'''
Service 3: get_monthly_plant_loss_ratios_data()
'''
def get_monthly_plant_loss_ratios_data(db: Session):
    query = text("""
        SELECT   
            O.stadur                            AS "Power_Plant_Source",
            (SUM(CASE WHEN M.tegund_maelingar = 'Framleiðsla' THEN G.gildi_kwh ELSE 0 END)
              -
             SUM(CASE WHEN M.tegund_maelingar = 'Innmötun'    THEN G.gildi_kwh ELSE 0 END))
              /
             NULLIF(
                SUM(CASE WHEN M.tegund_maelingar = 'Framleiðsla' THEN G.gildi_kwh ELSE 0 END),
                0
            )                                   AS "Plant_To_Sub_loss_Ratio",
            (SUM(CASE WHEN M.tegund_maelingar = 'Framleiðsla' THEN G.gildi_kwh ELSE 0 END)
              -
             SUM(CASE WHEN M.tegund_maelingar = 'Úttekt'      THEN G.gildi_kwh ELSE 0 END))
              /
             NULLIF(
                SUM(CASE WHEN M.tegund_maelingar = 'Framleiðsla' THEN G.gildi_kwh ELSE 0 END),
                0
            )                                   AS "Total_System_Loss_Ratio"
        FROM gildin G
        JOIN maeling M  ON M.ID = G.maeling_ID
        JOIN orku O     ON O.ID = M.orku_ID
        GROUP BY 
            O.stadur
        ORDER BY
            O.stadur ASC;
    """)
    result = db.execute(query)
    return [dict(row._mapping) for row in result]
# Task E1

'''
Service 4: insert_measurements_data()
'''

# Task F1

'''
Service 5: get_substations_gridflow_data()
'''
def get_substations_gridflow_data(db: Session, from_date, to_date):
    query = text("""
        WITH substation_distances AS (
            SELECT 
                t.STOD1,
                t.STOD2,
                SQRT(
                    POWER(h2.X_HNIT - h1.X_HNIT, 2) +
                    POWER(h2.Y_HNIT - h1.Y_HNIT, 2)
                ) AS dist
            FROM tengdar_stodvar t
            JOIN orku o1    ON t.STOD1 = o1.stadur
            JOIN hnit h1    ON o1.hnit_id = h1.ID
            JOIN orku o2    ON t.STOD2 = o2.stadur
            JOIN hnit h2    ON o2.hnit_id = h2.ID
            WHERE o1.id <> o2.id
        ),
        measurement_totals AS (
            SELECT
                AVG(CASE 
                    WHEN o.stadur IN ('P1_Þröstur', 'P2_Búrfell')
                         AND m.tegund_maelingar = 'Innmötun' 
                    THEN g.gildi_kwh ELSE 0 
                END) AS s1_inj,
                AVG(CASE 
                    WHEN o.stadur = 'P3_Strokkur'
                         AND m.tegund_maelingar = 'Innmötun'
                    THEN g.gildi_kwh ELSE 0 
                END) AS s2_inj,
                AVG(CASE 
                    WHEN m.tegund_maelingar = 'Úttekt' 
                    THEN g.gildi_kwh ELSE 0 
                END) AS s3_with
            FROM gildin g
            JOIN maeling m  ON g.maeling_ID = m.ID
            JOIN orku o     ON m.orku_ID = o.ID
            WHERE g.timi >= :from_date AND g.timi < :to_date
        ),
        distances AS (
            SELECT
                MAX(CASE WHEN STOD1 = 'S1_Krókur'   AND STOD2 = 'S2_Rimakot'          THEN dist END) AS dist1_2,
                MAX(CASE WHEN STOD1 = 'S2_Rimakot'  AND STOD2 = 'S3_Vestmannaeyjar'   THEN dist END) AS dist2_3
            FROM substation_distances
        ),
        calculations AS (
            SELECT
                s1_inj,
                s2_inj,
                s3_with,
                dist1_2,
                dist2_3,
                ((s1_inj + s2_inj) - s3_with)  AS total_loss,
                (dist1_2 + dist2_3)             AS total_dist
            FROM measurement_totals, distances
        )
        SELECT
            'S1_Krókur → S2_Rimakot'            AS "Segment",
            dist1_2                              AS "Segment_Distance",
            total_dist                           AS "Total_Distance",
            total_loss                           AS "Total_Loss_kWh",
            ROUND(
                ((dist1_2 / NULLIF(total_dist, 0)) * total_loss)::numeric, 4
            )                                    AS "Segment_Loss_kWh",
            ROUND(
                ((dist1_2 / NULLIF(total_dist, 0)) * 100)::numeric, 2
            )                                    AS "Distance_Weight_Pct"
        FROM calculations

        UNION ALL

        SELECT
            'S2_Rimakot → S3_Vestmannaeyjar'    AS "Segment",
            dist2_3                              AS "Segment_Distance",
            total_dist                           AS "Total_Distance",
            total_loss                           AS "Total_Loss_kWh",
            ROUND(
                ((dist1_2 / NULLIF(total_dist, 0)) * total_loss)::numeric, 4
            )                                    AS "Segment_Loss_kWh",
            ROUND(
                ((dist1_2 / NULLIF(total_dist, 0)) * 100)::numeric, 2
            )                                    AS "Distance_Weight_Pct"
        FROM calculations;
    """)
    result = db.execute(query, {"from_date": from_date, "to_date": to_date})
    return [dict(row._mapping) for row in result]