*** Settings ***
Library  RPA.HTTP
Library  RPA.Robocloud.Items
Library  RPA.Robocloud.Secrets
Library  RPA.RobotLogListener

*** Variables ***
${SECRET_NAME}  %{SECRET_NAME}
${CAMUNDA_REST_URL}  %{CAMUNDA_REST_URL}
${CAMUNDA_MESSAGE_NAME}  %{CAMUNDA_MESSAGE_NAME}

# +
*** Keywords ***
Publish message to Camunda
    [Arguments]  ${message}
    Register Protected Keywords  Create dictionary
    Register Protected Keywords  Post request
    ${secrets}=  Get secret  ${SECRET_NAME}
    ${headers}=  Create dictionary
    ...  Accept=application/json
    ...  Content-Type=application/json
    ...  Authorization=${secrets}[CAMUNDA_AUTHORIZATION]
    ${messageVariable}=  Create dictionary
    ...  value=${message}
    ...  type=string
    ${processVariables}=  Create dictionary
    ...  message=${messageVariable}
    ${data}=  Create dictionary
    ...  messageName=${CAMUNDA_MESSAGE_NAME}
    ...  correlationKeys=${processVariables}
    ...  processVariables=${processVariables}
    Post request  default  /message
    ...  json=${data}
    ...  headers=${headers}
    
Publish messages
    ${messages}=  Get work item variable  messages
    FOR  ${message}  IN  @{messages}
        Publish message to Camunda  ${message}
    END

Publish message
    ${message}=  Get work item variable  message
    Publish message to Camunda  ${message}
# -

*** Tasks ***
Publish messages to Camunda
    Create session  default  ${CAMUNDA_REST_URL}
    Run keyword and ignore error  Publish messages
    Run keyword and ignore error  Publish message


