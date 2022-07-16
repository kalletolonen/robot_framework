*** Comments ***
#    Only the robot is allowed to get the orders file. You may not save the file manually on your computer.
#    The robot should save each order HTML receipt as a PDF file.
#    The robot should save a screenshot of each of the ordered robots.
#    The robot should embed the screenshot of the robot to the PDF receipt.
#    The robot should create a ZIP archive of the PDF receipts (one zip archive that contains all the PDF files). Store the archive in the output directory.
#    The robot should complete all the orders even when there are technical failures with the robot order website.
#    The robot should read some data from a local vault. In this case, do not store sensitive data such as credentials in the vault. The purpose is to verify that you know how to use the vault.
#    The robot should use an assistant to ask some input from the human user, and then use that input some way.
#    The robot should be available in public GitHub repository.
#    Store the local vault file in the robot project repository so that it does not require manual setup.
#    It should be possible to get the robot from the public GitHub repository and run it without manual setup.


*** Settings ***
Documentation       Insert orders to system, produce receipts and a summary ZIP

Library             RPA.Browser.Selenium    auto_close=${FALSE}


*** Tasks ***
Insert orders to system, produce receipts and a summary ZIP
    #Open the order site ADDRESS FROM VAULT
    Open the order site
    #Click cookie warning
    Click OK
    #try-catch <- if server error, reload

    #Download the order file

    # - wait for the element to load
    #-Fill out the order
    Fill out the order
    #-Select Head
    #-Select Body
    #-Type in Legs
    #-Type in address

    #Save a screenshot of the order
    # - wait for the element to load
    #Embed the screenshot to a PDF of the order
    #Create a ZIP archive of the orders ASK FOR A NAME FROM A HUMAN
    #Try-catch (redundancy)


*** Keywords ***
Open the order site
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order

Click OK
    Wait Until Page Contains Element    class:alert-buttons
    Click Button    OK

Fill out the order
    Wait Until Page Contains Element    class:form-group
    Select From List By Index    head    1
    Select Radio Button    body    2
    Input Text    xpath://html/body/div/div/div[1]/div/div[1]/form/div[3]/input    1
    Input Text    address    1
    Click Button    Order
