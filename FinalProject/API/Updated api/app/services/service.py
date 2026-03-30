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