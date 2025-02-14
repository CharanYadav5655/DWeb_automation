*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${Browser}  Chrome
${URL}  https://www.practo.com
${SPECIALIZATION}  Dentist
${SEARCH_XPATH}  //div[@class="search-bar-text"]
${LOCATION}  //input[@data-qa-id='omni-searchbox-locality']
${LOCATION_SUGGESTION}  (//div[@data-qa-id='omni-suggestion-main'])[1]
${DOCTORSEARCH_BOX}  //input[@data-qa-id='omni-searchbox-keyword']
${DOCTOR_SEARCH_SUGGESTION}  //div[@data-qa-id='omni-suggestion-listing']//div[@data-qa-id='omni-suggestion-main' and text()='Dentist']
${DOCTOR_LIST}  (//h2[@data-qa-id="doctor_name"])[1]
${BOOK_BUTTON}  (//div[@data-qa-id='cta_offline_book' and text()='Book Clinic Visit'])
${FIRST_TIME_SLOT}  (//span[@data-qa-id='timeslot_available'])[1]
${TOMORROW_TAB}  (//div[@class="c-appointment-slots__day-selector__list"]/div[2])

*** Test Cases ***
Search For a Dentist And Book The Slot On Availability
  Open Browser    ${URL}    ${BROWSER}    options=add_experimental_option("mobileEmulation", {"deviceName": "iPhone X"})
  Search For Location And Dentist
  Select The 1st Doctor
  Book The Slots Based On Availability
  Close Browser

*** Keywords ***
Search For Location And Dentist
  [Documentation]  Select the location and the doctor's specialization you wanted to book an appointment for.
  Wait Until Element Is Visible  ${SEARCH_XPATH}  timeout=10s
  Click Element  ${SEARCH_XPATH}
  Wait Until Element Is Visible  ${LOCATION}  10s
  Click Element  ${LOCATION}
  Wait Until Element Is Visible  ${LOCATION_SUGGESTION}  10s
  Click ELement  ${LOCATION_SUGGESTION}
  Wait Until Element Is Visible  ${DOCTORSEARCH_BOX}  3s
  Click Element  ${DOCTORSEARCH_BOX}
  Sleep  2s
  Input Text    ${DOCTORSEARCH_BOX}    ${SPECIALIZATION}
  Click Element  ${DOCTOR_SEARCH_SUGGESTION}
  Sleep  5s

Select The 1st Doctor
  [Documentation]  Select the 1st doctor from the doctor list.
  Click ELement  ${DOCTOR_LIST}
  Sleep  2s

Book The Slots Based On Availability
  [Documentation]  Select the slots for booking appointment based on your availability.
  Wait Until Element Is Visible  ${BOOK_BUTTON}  3s
  Click ELement  ${BOOK_BUTTON}
  Sleep  3s
  ${slot_available}    Run Keyword And Return Status    Page Should Contain Element    ${FIRST_TIME_SLOT}    5s
  IF    '${slot_available}' == 'False'
  Click ELement    ${TOMORROW_TAB}
  Wait Until Page Contains Element    ${FIRST_TIME_SLOT}    timeout=5s
  END
  Click ELement    ${FIRST_TIME_SLOT}
  Sleep  5s

