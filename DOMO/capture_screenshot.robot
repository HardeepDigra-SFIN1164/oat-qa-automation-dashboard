*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Library    OperatingSystem
Library    BuiltIn
Library    capture_screenshot.py  # Import the Python file as a library

*** Variables ***
${USERNAME}          sv-ctio-oat-box@rakuten.com
${PASSWORD}          B&XTp8rC#y#3uXKr#%hFFvU%miqF%AFb
${URL}               https://rakuten-denwa.domo.com/page/-100000       #https://rakuten-denwa.domo.com/datasources/b4c77da3-9ab6-4d01-8400-e592550d9b4f/details/history      #https://www.domo.com/domopalooza/agenda#training   #https://www.globalsqa.com/     #https://rakuten-denwa.domo.com/page/-100000
${BROWSER}           chrome
${DASHBOARD_NAME}    COGS_Maintenance Dashboard
${SCREENSHOT_DIR}    ${EXECDIR}/CurrentScreenshots  # Define the screenshot directory

# XPaths
${SIGN_IN_BUTTON}        xpath=//span[normalize-space()='Sign In']
${USERNAME_INPUT}        xpath=//input[@id='userNameInput']
${PASSWORD_INPUT}        xpath=//input[@id='passwordInput']
${SUBMIT_BUTTON}         xpath=//span[@id='submitButton']
${NAVIGATION_BUTTON}     xpath=//button[@class='TopNavBar_navButton_HMFJj db-button ng-scope']
${SEARCH_INPUT}          xpath=//input[@placeholder='Filter by name']
${DASHBOARD_LINK}        xpath=(//span[text()='${DASHBOARD_NAME}'])[1]
${PAGE_TITLE}            xpath=//div[@id='pageTitleInlineEditorHeader']

*** Test Cases ***
Login, Search, Open Dashboard, Verify and Capture Full Screenshot
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Sign In to Website
    Search and Open Dashboard
    Verify Dashboard Name
    Capture Full Page Screenshot
    Close Browser

*** Keywords ***
Sign In to Website
    Wait Until Element Is Visible    ${SIGN_IN_BUTTON}
    Click Element    ${SIGN_IN_BUTTON}
    Wait Until Element Is Visible    ${USERNAME_INPUT}
    Input Text    ${USERNAME_INPUT}    ${USERNAME}
    Wait Until Element Is Visible    ${PASSWORD_INPUT}
    Input Text    ${PASSWORD_INPUT}    ${PASSWORD}
    Wait Until Element Is Visible    ${SUBMIT_BUTTON}
    Click Element    ${SUBMIT_BUTTON}
    Sleep    10

Search and Open Dashboard
    Wait Until Element Is Visible    ${NAVIGATION_BUTTON}
    Click Element    ${NAVIGATION_BUTTON}
    Wait Until Element Is Visible    ${SEARCH_INPUT}
    Input Text    ${SEARCH_INPUT}    ${DASHBOARD_NAME}
    Sleep    5
    Wait Until Element Is Visible    ${DASHBOARD_LINK}
    Click Element    ${DASHBOARD_LINK}
    Sleep    10

Verify Dashboard Name
    Reload page
    Sleep    15
    ${actual_dashboard_name}=    Get Text    ${PAGE_TITLE}
    Should Be Equal As Strings    ${actual_dashboard_name}    ${DASHBOARD_NAME}

Capture Full Page Screenshot
    Sleep    10
    [Documentation]    Capture a full-page screenshot with lazy-loaded content using the custom Python function.
    ${filename} =    capture_full_page_screenshot_keyword    # Calls the custom keyword from Python
    Log    Full-page screenshot saved at ${filename}
