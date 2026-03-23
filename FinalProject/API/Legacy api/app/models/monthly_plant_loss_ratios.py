from pydantic import BaseModel

class MonthlyPlantLossRatiosModel(BaseModel):
    power_plant_source: str
    plant_to_substation_loss_ratio: float | None
    total_system_loss_ratio: float | None


    class Config:
        from_attributes = True