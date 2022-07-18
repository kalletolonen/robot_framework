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
Library             RPA.PDF
Library             RPA.HTTP
Library             RPA.Tables
Library             OperatingSystem


*** Variables ***
${receipt_directory}=       ${OUTPUT_DIR}${/}receipts/
${image_directory}=         ${OUTPUT_DIR}${/}images/


*** Tasks ***
Insert orders to system, produce receipts and a summary ZIP
    Download the csv file

    #Open the order site ADDRESS FROM VAULT
    Open the order site

    #Click cookie warning
    Click OK

    Fill in the order form using the date from the csv file
    #-Select Head
    #-Select Body
    #-Type in Legs
    #-Type in address

    #Embed the screenshot to a PDF of the order

    #Create a ZIP archive of the orders ASK FOR A NAME FROM A HUMAN

    Delete original files


*** Keywords ***
Download the csv file
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=True

Open the order site
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order

Click OK
    Wait Until Page Contains Element    class:alert-buttons
    Click Button    OK

Fill out 1 order
    [Arguments]    ${orders}
    Wait Until Page Contains Element    class:form-group
    Select From List By Index    head    ${orders}[Head]
    Select Radio Button    body    ${orders}[Body]
    Input Text    xpath://html/body/div/div/div[1]/div/div[1]/form/div[3]/input    ${orders}[Legs]
    Input Text    address    ${orders}[Address]
    Click Button    Preview
    Wait Until Keyword Succeeds    5x    500ms    Make order

    #Input Text    firstname    ${sales_rep}[First Name]

Fill in the order form using the date from the csv file
    ${orders}=    Read table from CSV    path=orders.csv
    FOR    ${order}    IN    @{orders}
        Fill out 1 order    ${order}
        Save order details
        Return to order form
        Click OK
    END

Make order
    Click Button    Order
    Page Should Contain Element    id:receipt

Return to order form
    Wait Until Element Is Visible    id:order-another
    Click Button    id:order-another

Save order details
    Wait Until Element Is Visible    id:receipt
    ${order_id}=    Get Text    //*[@id="receipt"]/p[1]
    Set Local Variable    ${receipt_filename}    ${receipt_directory}receipt_${order_id}.png
    Screenshot    id:receipt    ${receipt_filename}
    Wait Until Element Is Visible    id:robot-preview-image
    Set Local Variable    ${image_filename}    ${image_directory}robot_${order_id}.png
    Screenshot    id:robot-preview-image    ${image_filename}
    Combine receipt with robot image to a PDF    ${receipt_filename}    ${image_filename}

Combine receipt with robot image to a PDF
    [Arguments]    ${receipt_filename}    ${image_filename}
    Log To Console    1. ${receipt_filename}
    Log To Console    2. ${image_filename}

Delete original files
    Empty Directory    ${image_directory}
    Empty Directory    ${receipt_directory}
