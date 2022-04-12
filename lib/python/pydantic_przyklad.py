# wykozystanie biblioteki pydantic do weryfikacji odpowiedzi z api w formacie json

from pydantic import BaseModel, validator

urzytkownik = {
    "imie": "Dariusz",
    "nazwisko": "Zyzik",
    "PESEL": 78060602345
}

class Czlowiek(BaseModel):
    imie: str
    nazwisko: str
    PESEL: int


# self trzeba zamienic na cls !!!
# return value zwraca walidowany element w nie zmienionej formie

    @validator("PESEL")
    def pesel_should_have_11_digits(cls, value):
        assert len(str(value)) == 11, "PESEL should have 11 digits"
        return value

ja = Czlowiek(**urzytkownik)
print(ja.PESEL)