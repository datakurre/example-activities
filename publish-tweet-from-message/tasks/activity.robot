*** Settings ***
Library  RPA.Browser  use_testability
Library  RPA.Robocloud.Items
Library  RPA.Robocloud.Secrets
Library  RPA.RobotLogListener
Suite teardown  Close all browsers

*** Variables ***
${SECRET_NAME}  %{SECRET_NAME}

# +
*** Keywords ***
Run Selenium keyword and return status
    [Arguments]  ${keyword}  @{arguments}
    ${tmp}=  Register keyword to run on failure  No operation
    ${status}=  Run keyword and return status  ${keyword}  @{arguments}
    Register keyword to run on failure  ${tmp}
    [Return]  ${status}

Enter phone number
    Register Protected Keywords    Input text
    ${secrets}=  RPA.Robocloud.Secrets.Get secret  ${SECRET_NAME}
    Input text  name:challenge_response  ${secrets}[TWITTER_PHONENUMBER]
    Click button  Submit
    Wait until page does not contain
    ...  Verify your identity by entering the phone number
# -

*** Tasks ***
Tweet from message
    Register Protected Keywords    Input text
    ${secrets}=  RPA.Robocloud.Secrets.Get secret  ${SECRET_NAME}
    ${message}=  RPA.Robocloud.Items.Get work item variable  message
    Open available browser  https://twitter.com/session/new
    
    Wait until element is visible  session[username_or_email]
    Input text  name:session[username_or_email]  ${secrets}[TWITTER_USERNAME]
    Input text  name:session[password]  ${secrets}[TWITTER_PASSWORD]
    Click element  xpath://*[text()="Log in"]
    Wait until element is not visible  session[username_or_email]
    
    ${phoneChallenge}=  Run Selenium keyword and return status
    ...  Page should contain
    ...  Verify your identity by entering the phone number
    Run keyword if  ${phoneChallenge}  Enter phone number
    
    Go to  https://twitter.com/compose/tweet
    Wait until element is visible  xpath://*[@contenteditable="true"]
    Input text  xpath://*[@contenteditable="true"]  ${message}
    Click element  xpath://*[text()="Tweet"]
