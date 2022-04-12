import requests
# from mock import Mock
from mock import patch

# mock do oszukania 'requests.get' w przypadku gdy api jeszcze nie dziala za pomoca 'patch' z mock
# nie istniejace api http://glapi.nbp.pl/


class FakeInternetWithCode400:
    status_code = 400


with patch("requests.get", return_value=FakeInternetWithCode400()):
    response = requests.get("http://glapi.nbp.pl/api/cenyzlota/2033-01-02/")
    assert response.status_code == 400, f"Status code not equal to 400. Actual result:{response.status_code}"