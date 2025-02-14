*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${URL}  https://www.practo.com
${SEARCH_BOX_XPATH}  //input[@data-qa-id='omni-searchbox-keyword']
${SUGGESTION_ITEM_XPATH}  (//div[contains(@class,'c-omni-suggestion-item')])[1]
${DOCTOR_LIST_XPATH}  (//h2[@data-qa-id='doctor_name'])[3]
${DOCTOR_URL_XPATH}  (//h2[@data-qa-id='doctor_name'])[3]/ancestor::a
${TODAY_SLOT_XPATH}  (//div[contains(@class,'c-day-session__slot')]/span)[1]
${TOMORROW_TAB_XPATH}  //div[contains(@class,'c-slots-header')]//i[contains(@class,'c-slots-header__next-btn')]
${FIRST_SLOT_XPATH}  (//div[contains(@class,'c-day-session__slot')]/span)[1]
${SPECIALITY}  Dentist


*** Test Cases ***
Search For A Dentist And Book The First Available Slot
    Open Browser  ${URL}  chrome
    Maximize Browser Window
    Search For Dentist In The Searchbox
    Select The 3rd Doctor From The Doctor's List
    Check For The Slots Available
    Close Browser

*** Keywords ***
Search For Dentist In The Searchbox
    [Documentation]  Searching for the doctor with specialization dentist.
    Wait Until Element Is Visible  ${SEARCH_BOX_XPATH}  timeout=10s
    Clear Element Text  ${SEARCH_BOX_XPATH}
    Input Text  ${SEARCH_BOX_XPATH}  ${SPECIALITY}
    Sleep  3s

Select The 3rd Doctor From The Doctor's List
    [Documentation]  Selecting the 3rd doctor from displayed doctors card list.
    Click Element  ${SUGGESTION_ITEM_XPATH}
    Wait Until Element Is Visible  ${DOCTOR_URL_XPATH}  timeout=10s
    ${DOCTOR_URL} =  Get Element Attribute  ${DOCTOR_URL_XPATH}  href
    Go To  ${DOCTOR_URL}
    Sleep  3s

Check For The Slots Available
    [Documentation]  Verifying the slots to book based on the availability.
    ${TODAY_SLOT_COUNT} =  Get Element Count  ${TODAY_SLOT_XPATH}
    Run Keyword If  ${TODAY_SLOT_COUNT} > 0  Book Slot  ${TODAY_SLOT_XPATH}  ELSE  Go To Tomorrow And Book Slot
    Sleep  10s

Book Slot
    [Arguments]  ${SLOT_XPATH}
    Wait Until Element Is Visible  ${SLOT_XPATH}  timeout=10s
    Click Element  ${SLOT_XPATH}
    Log  "Successfully booked a slot."

Go To Tomorrow And Book Slot
    Wait Until Page Contains Element  ${TOMORROW_TAB_XPATH}  timeout=20s
    Scroll Element Into View  ${TOMORROW_TAB_XPATH}
    Execute JavaScript  document.querySelector(".c-slots-header__next-btn").click()
    Sleep  3s
    Wait Until Element Is Visible  ${FIRST_SLOT_XPATH}  timeout=10s
    Click Element  ${FIRST_SLOT_XPATH}
    Log  "No slots available today. Booked a slot for tomorrow."
