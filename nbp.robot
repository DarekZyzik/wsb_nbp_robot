*** Settings ***

Library     RequestsLibrary
Resource    lib/robot/nbp.robot
Library     lib/python/html_parsing.py
Library     lib/python/pydantic_table_c_verification.py
Library     lib/python/pydantic_table_a_verification.py

*** Test Cases ***
Last Count Should Be Equal To Requested Rate Count
    [Documentation]     Check Rate Count is imported from lib/robot/nbp.robot

    FOR    ${requested_rate_count}    IN RANGE    1   3
        run keyword and continue on failure     Check Rate Count    ${requested_rate_count}
    END

NBP USD Buy Price Should Be Lower Than Sell Price
    [Documentation]    bierzemy odpowiedz z api https://api.nbp.pl/api/exchangerates/rates/c/usd/last/
    ...                Weryfikujemy ze klucz 'bid' zawiera mniejsza cene niz 'ask'
    ...                 test pokryte rowniez przez
    ${response}     GET     https://api.nbp.pl/api/exchangerates/rates/c/usd/last/
    ${bid}      SET VARIABLE        ${response.json()["rates"][0]['bid']}
    ${ask}      SET VARIABLE        ${response.json()["rates"][0]['ask']}
    should be true    ${ask}>${bid}
    log to console      bid=${bid}
    log to console      ask=${ask}

Validate Table C
    ${response}   GET    https://api.nbp.pl/api/exchangerates/rates/c/eur/last/
    Validate Table C    ${response.json()}

Validate Table A
    ${response}   GET    https://api.nbp.pl/api/exchangerates/rates/a/eur/last/
    Validate Table A    ${response.json()}

Validate Table A Currency Should Be Euro
    ${response}   GET    https://api.nbp.pl/api/exchangerates/rates/a/eur/last/
    Currency Should Be Euro In Table A    ${response.json()}


EUR rate From Web Service And From API Should Be Equal
    [Documentation]    'Return Eur From Nbp Web Service' is imported from lib/python/html_parsing.py
...                     Get EUR Rate From API is imported from lib/robot/nbp.robot

    ${rate_from_web_service}=   Return Eur From Nbp Web Service
    ${rate_from_api}=   Get EUR Rate From API
    SHOULD BE EQUAL     ${rate_from_web_service}    ${rate_from_api}

In Case Of Lack Data Status Code Should Be 404
    GET     https://api.nbp.pl/api/exchangerates/rates/c/usd/last/0     expected_status=404

In Case Of Bad Request Status Code Should Be 400
    GET     http://api.nbp.pl/api/cenyzlota/2033-01-02/     expected_status=400

In Case Of Request Limit Is To Big Status Code Should Be 400
    GET    http://api.nbp.pl/api/exchangerates/tables/a/2022-01-06/2022-04-10/     expected_status=400

Asking For Rates From Last 94 Days Should Give Status Code 400
    Rates From Last 94 Days Should Give Status Code 400     tables/a/
#    Rates From Last 94 Days Should Give Status Code 400     rates/a/usd