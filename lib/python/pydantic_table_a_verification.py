# wykozystanie biblioteki pydantic do weryfikacji odpowiedzi z api w formacie json
# przy liscie 'rates' w elemencie json musi byc zaimportowany (from typing import List) i
# stworzona classa dla listy 'rates' tutaj class Rate

from pydantic import BaseModel, validator
from typing import List
from robot.api.deco import keyword

class Rate(BaseModel):
    no: str
    effectiveDate: str
    mid: float


class TableA(BaseModel):
    table: str
    currency: str
    code: str
    rates: List[Rate]

    @validator("currency")
    def check_if_currency_is_eur(cls, currency):
        assert currency == "euro", f"{currency} is not EUR"
        return currency


    @validator("table")
    def check_if_table_is_A(cls, table):
        assert table == "A", f"{table=} is not A"
        return table

@keyword(name="Validate Table A")
def validate_table_A(json_response):
    return TableA(**json_response)

@keyword(name="Currency Should Be Euro In Table A")
def validate_currency(json_response):
    return TableA(**json_response)
