*** Settings ***
Library    Collections
Library    String
Library    DateTime
Library    OperatingSystem
Library    Process
Library    BuiltIn
Library    JSONLibrary
Library    MongoDBLibrary

Resource    ../keyword/Keyword_Request.robot
Resource    ../keyword/Keyword_CreateData.robot
Resource    ../keyword/Keyword_RemoveData.robot
Resource    ../keyword/Keyword_Log.robot
Resource    ../keyword/Keyword_VerifyLog_ControlAPI.robot
#Library Document
#https://robotframework.org/robotframework/latest/libraries/BuiltIn.html
#https://robotframework.org/robotframework/latest/libraries/String.html
#https://robotframework.org/robotframework/latest/libraries/Collections.html
#https://robotframework-thailand.github.io/robotframework-jsonlibrary/JSONLibrary.html

*** Keywords ***
####################################################
Replace Text
    [Arguments]    ${string}    ${search_for}    ${replace_with}
	${replaceUrl}=    Replace String    ${string}    ${search_for}    ${replace_with}
	Log To Console    ${text}
	[RETURN]    ${text}
	
Replace Parameters Url Path
	[Arguments]    ${url}    ${urlPath}    ${ParametersField}    ${value_ParametersField}    ${ParametersField_ipAddress}    ${value_ipAddress}
	${replaceParametersUrl}=    Replace String    ${urlPath}    ${ParametersField}    ${value_ParametersField}
	#Log To Console    replaceUrl${replaceParametersUrl}
    ${replaceIPAddressUrl}=    Replace String    ${replaceParametersUrl}    ${ParametersField_ipAddress}    ${value_ipAddress}
	#Log To Console    replaceUrl${replaceIPAddressUrl}
	${url}=    Set Variable    ${url}${replaceIPAddressUrl}
	#Log To Console    ${url}
	[return]    ${url}
	
Replace Parameters Path
	[Arguments]    ${urlPath}    ${ParametersField}    ${value_ParametersField}    ${ParametersField_ipAddress}    ${value_ipAddress}
	${replaceParametersUrl}=    Replace String    ${urlPath}    ${ParametersField}    ${value_ParametersField}
	#Log To Console    replaceUrl${replaceParametersUrl}
    ${replaceIPAddressUrl}=    Replace String    ${replaceParametersUrl}    ${ParametersField_ipAddress}    ${value_ipAddress}
	#Log To Console    replaceUrl${replaceIPAddressUrl}
	${path}=    Set Variable    ${replaceIPAddressUrl}
	#Log To Console    ${path}
	[return]    ${path}	

Replace Parameters
	[Arguments]    ${urlPath}    ${ParametersField}    ${value_ParametersField}
	${replaceParametersUrl}=    Replace String    ${urlPath}    ${ParametersField}    ${value_ParametersField}
	#Log To Console    replaceUrl${replaceParametersUrl}
	${path}=    Set Variable    ${replaceParametersUrl}
	#Log To Console    ${path}
	[return]    ${path}	
	
#for use check log and verify DB check data 
Check Json Data Should Be Equal
	[Arguments]    ${JsonData}    ${field}    ${expected}    ${fieldName}	
	#json.dumps use for parameter convert ' to "
	${listAsString}=    Evaluate    json.dumps(${JsonData})    json
	#r use for parameter / have in data
	${resp_json}=    Evaluate    json.loads(r'''${listAsString}''')    json
	#Log To Console    resp_json${resp_json}	
    #Should Be Equal    ${resp_json['${field}']}    ${expected}
	#Log To Console    resp_json${resp_json${field}}
	Log Many    ${listAsString}	
	Log To Console    ${fieldName} : ${expected} = ${resp_json${field}}
    Run Keyword And Continue On Failure    Should Be Equal    ${expected}    ${resp_json${field}}    error=${field}	

Generic Test Case Teardown
    [Arguments]    ${Flow}    ${getData}    ${data}
	# Log To Console    Flow${Flow}    
    # Catch of Try Catch Finally
    Run Keyword If Test Failed    Test Case Catch 
    # Finally of Try Catch Finally
    #  RKITS is only executed when test passed.
    Run Keyword If Test Passed    Test Case Finally    
    ${ThingName}=    Get From Dictionary    ${data}    ThingName
    ${result}=    Search All Fields    {"ThingName" : "${ThingName}"}
    ${ThingID_Centric}=    Get From Dictionary    ${result}    _id
    ${accessToken}=    Set Variable    ${getData}[0]
	${AccountId}=    Set Variable    ${getData}[2]
    ${ThingIdArr}=    Set Variable    ${getData}[4]
    ${ThingId_Core}=    Set Variable    ${ThingIdArr}[0]
    ${PartnerId}=    Set Variable    ${getData}[1]
    ${GroupId}=    Set Variable If    '${Flow}'=='${CREATECONTROLTHINGGROUP}' or '${Flow}'=='${CREATECONTROLTHINGGROUPS}'    ${getData}[8]
	Remove A Thing    ${URL_CENTRIC}    ${ThingID_Centric}
    Remove Thing    ${URL}    ${accessToken}    ${ThingId_Core}    ${AccountId}
	Remove Account    ${URL}    ${accessToken}    ${PartnerId}    ${AccountId}
	Remove Partner    ${URL}    ${accessToken}    ${PartnerId}
    Run Keyword If    '${Flow}'=='${CREATECONTROLTHINGGROUP}' or '${Flow}'=='${CREATECONTROLTHINGGROUPS}'    Remove Group    ${URL}    ${accessToken}    ${AccountId}    ${GroupId}
    
Test Case Catch
    Log To Console    Test Case Catch : Rollback!!
  
Test Case Finally
    Log To Console    Test Case Finally

ConnectMongodb
    ${username}=    Set Variable    admin
    ${pass}=    Set Variable    ais.co.th
    ${ip}=    Set Variable    52.163.210.190:27018
    ${authSource}=    Set Variable    admin
    ${db}=    Set Variable    mongodb://${username}:${pass}@${ip}/mgcore?authSource=${authSource}
    Connect To Mongodb    ${db}    

Search All Fields
    [Arguments]    ${json_data}
    Log    ${json_data}
    Log To Console    Search All Fields${json_data}
    ConnectMongodb
    ${result}=    Retrieve Some Mongodb Records    dbName=mgcentric    dbCollName=things    recordJSON=${json_data}    returnDocuments=True
    Log    ${result}
    # Log To Console    Search All Fields${result}
    #ได้ record เดียวเสมอ, convert dict กลับไปถ้าจะดึงค่าให้ใช้  ${result}=    Get From Dictionary    ${dict}    ชื่อฟิลด์ 
    ${dict}=    Convert To Dictionary    ${result}[0]
    # Log To Console    dict${dict}
    Disconnect From Mongodb
    [Return]    ${dict} 


Prepare data for create thing ImportThing MappingIMEI and ActivateThingCore
    [Arguments]    ${num}  
	${data_count}=    Set Variable    ${num}
    # Log To Console    ${data_count}
	@{valArrData}=    Create List
	FOR    ${i}    IN RANGE    ${data_count}
        #set IMEI
        ${randomIM1}=    Evaluate    random.randint(10000000, 99999999)    random
        ${randomIM2}=    Evaluate    random.randint(1000000, 9999999)    random
        ${random_IMEI}=    Set Variable    ${randomIM1}${randomIM2}
        # Log To Console    ${random_IMEI} 
        Set Global Variable    ${IMEI}    ${random_IMEI}
        Log To Console    IMEI is : ${IMEI}
        #set ThingSecret
        ${randomIM3}=    Evaluate    random.randint(10000000, 99999999)    random
        ${randomIM4}=    Evaluate    random.randint(1000000, 9999999)    random
        ${random_ThingSecret}=    Set Variable    ${randomIM3}${randomIM4}
        # Log To Console    ${random_ThingSecret} 
        Set Global Variable    ${ThingSecret}    ${random_ThingSecret}
        Log To Console    ThingSecret is : ${ThingSecret}	
        #set ThingIdentifier
        ${randomICCID1}=    Evaluate    random.randint(1000000, 9999999)    random
        ${randomICCID2}=    Evaluate    random.randint(100000, 999999)    random
        ${random_ThingIdentifier}=    Set Variable    ${FIELD_ICCIDPRE}${randomICCID1}${randomICCID2}
        # Log To Console    ${random_ThingIdentifier} 
        Set Global Variable    ${ThingIdentifier}    ${random_ThingIdentifier}
        Log To Console    ThingIdentifier is : ${ThingIdentifier}	
		#ThingName
        ${random_number}=    generate random string    6    [NUMBERS]
        ${ThingName}=    Set Variable    ${VALUE_ATHINGNAME}${random_number}
        Log To Console    ThingName is : ${ThingName}        
        ${data}=    Evaluate    { "ConnectivityType": "${VALUE_CONNECTIVITYTYPE_NBIOT}", "ThingName": "${ThingName}", "ThingIdentifier": "${ThingIdentifier}", "ThingSecret": "${ThingSecret}", "IMEI": "${IMEI}" }
        Append To List    ${valArrData}    ${data}        #Add data to array set at valArrData
		# Run Keyword If    '${valueSearch}'=='${ASGARD_COAPAPI_VALUE_TST_F4_0_2_003_DATASEARCH}'    Append To List    ${valArrData}    ${valLog}        #Add data to array set at valArrData		
    # Exit For Loop
	END
	# Log To Console    valArrData${valArrData}
	[return]    ${valArrData}

Convert Format Date
    [Arguments]    ${date}    ${format}  
	${dateConvert} =	Convert Date	${date}    result_format=${DATE_MONGODB_NOW}
    Log To Console    dateConvert${dateConvert} 
	[return]    ${dateConvert}

Convert Format Date MongoDB
    [Arguments]    ${valueDate}
	${date}=    Convert Date    ${valueDate}    datetime
    # Log To Console    date : ${date}
   ${dateConvert}=    Set Variable    ${date.year}, ${date.month}, ${date.day}, ${date.hour}, ${date.minute}, ${date.second}, ${date.microsecond}
   #Log To Console    dateConvert: ${dateConvert}
   [return]    ${dateConvert}

Convert Format Date MongoDB not have Microsecond
    [Arguments]    ${valueDate}
	${date}=    Convert Date    ${valueDate}    datetime
    # Log To Console    date : ${date}
   ${dateConvert}=    Set Variable    ${date.year}, ${date.month}, ${date.day}, ${date.hour}, ${date.minute}, ${date.second}
   #Log To Console    dateConvert: ${dateConvert}
   [return]    ${dateConvert}

#ex. 10/03/2020
Change format date now
    [Arguments]    ${format}
	#change format
	${now}    Evaluate  '${format}'.format(dt=datetime.datetime.now())    modules=datetime
	#Log To Console    now${now}
	[return]    ${now}

#ex. 23/09/2020 -> 24/10/2020 add 31 days
Value Add date now
    [Arguments]    ${format}    ${day} 
	#${getTime}=    Get Text    ${locator} 
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	${addDate}=      Add Time To Date      ${currentDate}      ${day} days
    ${valueDate}      Convert Date      ${addDate}      result_format=${format}
	#Log To Console    valueDate${valueDate}
	[return]    ${valueDate}
	
Value Minus date now
    [Arguments]    ${format}    ${day} 
	#${getTime}=    Get Text    ${locator} 
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	${subtractDate}=      Subtract Time From Date      ${currentDate}      ${day} days
    ${valueDate}      Convert Date      ${subtractDate}      result_format=${format}
	[return]    ${valueDate}
	
Value Minus Time Current Date and Change Format
    [Arguments]    ${format}    ${time}    ${timeString} 
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	${subtractDate}=      Subtract Time From Date      ${currentDate}      ${time} ${timeString}
	#Log To Console    subtractDate${subtractDate}
    ${valueDate}      Convert Date      ${subtractDate}      result_format=${format}
	[return]    ${valueDate}

Value Minus Time Current Date Not Change Format
    [Arguments]    ${time}    ${timeString} 			
	${currentDate}=      Get Current Date      UTC      exclude_millis=yes
	${subtractDate}=      Subtract Time From Date      ${currentDate}      ${time} ${timeString}
	#Log To Console    subtractDate${subtractDate}
	[return]    ${subtractDate}
		
#Gte -> Lte
Rang Get Value Minus Time Current Date and Change Format
    [Arguments]    ${format}    ${time}    ${timeString} 
	${date}=      Get Current Date      UTC      exclude_millis=yes
	${currentDate}=      Add Time To Date      ${date}    -1 hour
	#${subtractDate1}=      Subtract Time From Date      ${currentDate}      15 ${timeString}
	${tomorrowDate}=      Add Time To Date      ${currentDate}    1 days
	#Log To Console    subtractDate${subtractDate}
	${valueDateGte}      Convert Date      ${currentDate}      result_format=${format}
	${valueDateLte}      Convert Date      ${tomorrowDate}      result_format=${format}
	#Log To Console    valueDateGte${valueDateGte}
	#Log To Console    valueDateLte${valueDateLte}
	[return]    ${valueDateGte}    ${valueDateLte}    

Replace String To Object
    [Arguments]    ${string}
    
	${replStringToJsonStart}=    Replace String    ${string}    "{    {
	${replStringToJsonEnd}=    Replace String    ${replStringToJsonStart}    }"    }
	[RETURN]    ${replStringToJsonEnd}