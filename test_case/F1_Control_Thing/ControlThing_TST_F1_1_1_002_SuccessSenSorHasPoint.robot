*** Settings ***
Resource    ../../variables/Variables.robot    
Resource    ../../keyword/Keyword.robot

*** Test Cases ***
ControlThing_TST_F1_1_1_002_SuccessSenSorHasPoint
    [Documentation]    Step is :    
    ...    1.Core : Signin
    ...    2.Core : Create Partner
    ...    3.Core : Create Account
    ...    4.Centric : ImportThing
    ...    5.Centric : MappingIMEI
    ...    6.Core : ActivateThingCore
    ...    7.Core : CreateThingStateInfo
    ...    8.Core : Control Thing
    ...    9.Verify Log
    ...    10.Remove Thing
    ...    11.Remove Account
    ...    12.Remove Partner
	#====== Start Prepare data ==========
	# Prepare data for create thing
	${valArrData}=    Prepare data for create thing ImportThing MappingIMEI and ActivateThingCore    1
    Log    valArrData is : ${valArrData}
    Log To Console    valArrData is : ${valArrData}
	# [accessToken,PartnerId,AccountId,AccountName,ThingIdArr]
	${createResponse}=    Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore and CreateThingStateInfo    ${SIGNIN_USERNAME_ROOTADMIN}    ${SIGNIN_PASSOWORD_ROOTADMIN}    ${valArrData}    ${VALUE_TYPE_REPORT}    ${VALUE_SENSORKEY_POINT}
    Log    createResponse is : ${createResponse}
	${accessToken}=    Set Variable    ${createResponse}[0]
	${AccountId}=    Set Variable    ${createResponse}[2]
    ${ThingIdArr}=    Set Variable    ${createResponse}[4]
    ${ThingId}=    Set Variable    ${ThingIdArr}[0]
    ${sensorValue}=    Set Variable    ${createResponse}[7]
    #====== End Prepare data ==========   
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    #Headers
	${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATECONTROLTHING}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATECONTROLAPI}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}    Accept=${HEADER_ACCEPT}  
	Log To Console    Headers is : ${headers}
	#Body
    ${body}=    Evaluate    { "ThingId": "${ThingId}", "Sensors": {"${VALUE_SENSORKEY_POINT}": "${sensorValue}"}}
    Log To Console    Body is : ${body}
    #Response
    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${CONTROLAPIS}    ${URL_CREATECONTROLTHING}    ${headers}    ${body}
	Log To Console    Response is : ${res}
    ${checkReponse}=    Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATECONTROLTHING}    ${FIELD_OPERATIONSTATUS_LOWCASE}    ${FIELD_CODE_LOWCASE}    ${FIELD_DESCRIPTION_LOWCASE}
    Log To Console    checkReponse is : ${checkReponse}
	#====== Check log and Verify DB ==========
	${dataSearch}=    Set Variable    ${HEADER_X_AIS_ORDERREF_CREATECONTROLTHING}${current_timestamp}
	#Check log detail and summary
	Log ControlThing   ${VALUE_RESULTCODE_20000}    ${VALUE_DESCRIPTION_CREATECONTROLTHING_SUCCESS}    ${res}    ${URL_CREATECONTROLTHING}    ${dataSearch}    ${accessToken}    ${AccountId}    ${ThingId}    ${VALUE_SENSORKEY_POINT}    ${sensorValue}
    [Teardown]    Generic Test Case Teardown    ${CREATECONTROLTHING}    ${createResponse}    ${valArrData}[0]
    


