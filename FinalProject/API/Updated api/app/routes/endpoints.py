# Task C5

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import get_orkuflaedi_session
from app.services.service import (
    get_monthly_energy_flow_data,
    get_monthly_company_usage_data,
    get_monthly_plant_loss_ratios_data,
    get_substations_gridflow_data
)
from app.utils.validate_date_range import validate_date_range_helper
from datetime import datetime
from typing import List

router = APIRouter()
db_name = "OrkuFlaediIsland"

'''
Endpoint 1: get_monthly_energy_flow()
GET /energy-flow/monthly
Returns total kWh per substation per measurement type per month (2025).
'''
@router.get("/monthly-energy-flow")
def get_monthly_energy_flow(
    from_date: datetime | None = None,
    to_date: datetime | None = None,
    db: Session = Depends(get_orkuflaedi_session)
):
    print(f"Calling [GET] /{db_name}/monthly-energy-flow")
    from_date, to_date = validate_date_range_helper(
        from_date,
        to_date,
        datetime(2025, 1, 1, 0, 0),
        datetime(2026, 1, 1, 0, 0)
    )
    return get_monthly_energy_flow_data(db, from_date, to_date)


'''
Endpoint 2: get_monthly_company_usage()
'''
@router.get("/monthly-company-usage")
def get_monthly_company_usage(
    db: Session = Depends(get_orkuflaedi_session)
):
    print(f"Calling [GET] /{db_name}/monthly-company-usage")
    return get_monthly_company_usage_data(db)


'''
Endpoint 3: get_monthly_plant_loss_ratios()
'''
@router.get("/sub-to-loss-ratio")
def get_monthly_plant_loss_ratios(
    db: Session = Depends(get_orkuflaedi_session)
):
    print(f"Calling [GET] /{db_name}/sub-to-loss-ratio")
    return get_monthly_plant_loss_ratios_data(db)


# Task E1

'''
Endpoint 4: insert_measurements()
'''

# Task F1
'''
Endpoint 5: get_substations_gridflow()
'''
@router.get("/substation-gridflow")
def get_substations_gridflow(
    from_date: datetime | None = None,
    to_date: datetime | None = None,
    db: Session = Depends(get_orkuflaedi_session)
):
    print(f"Calling [GET] /{db_name}/substation-gridflow")
    from_date, to_date = validate_date_range_helper(
        from_date,
        to_date,
        datetime(2025, 1, 1, 0, 0),
        datetime(2026, 1, 1, 0, 0)
    )
    return get_substations_gridflow_data(db, from_date, to_date)