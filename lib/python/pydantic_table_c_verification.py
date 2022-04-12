# wykozystanie biblioteki pydantic do weryfikacji odpowiedzi z api w formacie json
# przy liscie 'rates' w elemencie json musi byc zaimportowany (from typing import List) i
# stworzona classa dla listy 'rates' tutaj class Rate

from pydantic import BaseModel, validator
from typing import List
from robot.api.deco import keyword

# json_table_c = {
#   "table": "C",
#   "currency": "dolar amerykański",
#   "code": "USD",
#   "rates": [
#     {
#       "no": "069/C/NBP/2022",
#       "effectiveDate": "2022-04-08",
#       "bid": 4.2113,
#       "ask": 4.2963
#     }
#   ]
# }


class Rate(BaseModel):
    no: str
    effectiveDate: str
    bid: float
    ask: float


class TableC(BaseModel):
    table: str
    currency: str
    code: str
    rates: List[Rate]


    @validator("rates")
    def ask_should_be_larger_than_bid(cls, values):
        for value in values:
            assert value.ask > value.bid, f"error: ask= {value.ask} is not larger than bid= {value.bid}"
        return values

@keyword(name="Validate Table C")
def validate_table_c(json_response):
    return TableC(**json_response)



# pydantic_table_C = TableC(**json_table_c)
# print(pydantic_table_C.rates[0].ask)

