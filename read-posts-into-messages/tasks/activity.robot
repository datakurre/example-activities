*** Settings ***
Library  FeedLibrary
Library  RPA.Robocloud.Items
Library  Collections

*** Variables ***
${URL}  https://datakurre.pandala.org

*** Tasks ***
Messages from feedreader entries
    ${entries}=  Get entries  ${URL}
    ${messages}=  Create list
    FOR  ${entry}  IN  @{entries}
        Append to list  ${messages}  ${entry}[title]: ${entry}[link]        
    END
    Set work item variable  messages  ${messages}
    Save work item
