# get eur rate from www.nbp.pl with 'requests' and 'bs4' and parent

import requests
from bs4 import BeautifulSoup
from robot.api.deco import keyword


@keyword(name="Return Eur From Nbp Web Service")
def return_eur_from_nbp_www():
    response = requests.get("https://www.nbp.pl/home.aspx?f=/kursy/kursya.html")
    response = response.text
    soup = BeautifulSoup(response, 'html.parser')
    table = soup.findAll('td', string='1 EUR')
    par = table[1].parent
    par2 = str(par.findAll('td'))
    par2 = par2[21:27].replace(',', '.')

    return float(par2)
#
# print(return_eur_from_nbp_www())
