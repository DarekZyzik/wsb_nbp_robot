*** Settings ***

Library     RequestsLibrary
Library    DateTime

*** Keywords ***

Check Rate Count
    [Arguments]    ${requested_rate_count}
    ${response}     GET     https://api.nbp.pl/api/exchangerates/rates/a/eur/last/${requested_rate_count}
    ${retrived_rate_count}      GET LENGTH      ${response.json()['rates']}
    LOG TO CONSOLE    Checking if requested rate count ${requested_rate_count} equals retrived rate count ${retrived_rate_count}
    SHOULD BE EQUAL AS INTEGERS    ${retrived_rate_count}    ${requested_rate_count}

Get EUR Rate From API
    ${response}     GET     https://api.nbp.pl/api/exchangerates/rates/a/eur/last
    ${rate}     SET VARIABLE    ${response.json()['rates'][0]["mid"]}
    [Return]    ${rate}

Rates From Last 94 Days Should Give Status Code 400
    [Documentation]     ${api_section} is API addres part after exchange rates and before date span
    ...                 for example: tables/a/
    [Arguments]    ${api_section}
    ${today}    GET CURRENT DATE    result_format=%Y-%m-%d
    ${94_days_ago}  subtract time from date    ${today}    94 days      result_format=%Y-%m-%d
    LOG TO CONSOLE   ${today} ${94_days_ago}
    GET     http://api.nbp.pl/api/exchangerates/${api_section}/${94_days_ago}/${today}/   expected_status=400