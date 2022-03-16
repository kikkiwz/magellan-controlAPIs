*** Settings ***
Library    RequestsLibrary

*** Keywords ***
#Get
Get Api Request
    [Arguments]    ${url}    ${pathUrl}
	Create Session    ${NAME_SESSION_GET}     ${BASE_URL}
    Log    URL${\n}${url}${pathUrl}
    ${res}=    Get Request    ${NAME_SESSION_GET}     ${pathUrl}
	Log    RESPONSE${\n}${res.json()}
	[return]    ${res.json()}
	#Response Status Code Should Have Success    ${res}
	#Response ResultCode Should Have    ${res.json()}    name
	
#Post
Post Api Request
    [Arguments]    ${url}    ${pathUrl}    ${headers}   ${data}
    Create Session    ${NAME_SESSION_POST}    ${url}    verify=false    disable_warnings=1
    Log To Console    ${url}${pathUrl} 
    Log    URL${\n}${url}${pathUrl}
    Log    HEADER${\n}${headers}
    Log    BODY${\n}${data} 
    
    ${res}=    POST On Session    ${NAME_SESSION_POST}    ${pathUrl}     expected_status=anything    headers=${headers}    json=${data} 
    Log To Console    POST${res}   
    # Log To Console    ${res.Content}
	Log    RESPONSE${\n}${res.json()}
	# Log To Console    ${res.text}
	[return]    ${res.json()} 
	
#Put
Put Api Request
    [Arguments]    ${url}    ${pathUrl}   ${headers}    ${data}
    Create Session    ${NAME_SESSION_PUT}    ${url}    verify=true    #for https
    Log    URL${\n}${url}${pathUrl}
    Log    HEADER${\n}${headers}
    Log    BODY${\n}${data} 
    ${res}=  PUT On Session    ${NAME_SESSION_PUT}    ${pathUrl}    expected_status=anything    json=${data}    headers=${headers}
	Log    RESPONSE${\n}${res.json()}
    [return]    ${res.json()}
	
#Delete	
Delete Api Request
    [Arguments]    ${url}    ${pathUrl}    ${headers}   ${data}
    Create Session    ${NAME_SESSION_DELETE}    ${url}    verify=true    #for https
    Log To Console    ${url}${pathUrl} 
    Log    URL${\n}${url}${pathUrl}
    Log    HEADER${\n}${headers}
    Log    BODY${\n}${data} 
    ${res}=    DELETE On Session    ${NAME_SESSION_DELETE}    ${pathUrl}    expected_status=anything    json=${data}    headers=${headers}
	# ${res}=    DELETE On Session    ${NAME_SESSION_DELETE}    ${pathUrl}    expected_status=anything    headers=${headers}
	
    ${res_json}=    Set Variable
    Log    RESPONSE${\n}${res.json()}
	
    #${result}=    Run Keyword And Return Status    Should Be Empty   ${res}
	#Run Keyword If    ${result} == False    Rollback Data    ${getData}
    #Log To Console    ${res.json()}
	[return]    ${res.json()}

#Check Response ResultCode 
Response ResultCode Should Have
    [Arguments]    ${res_json}    ${res_name}    ${field_OperationStatus}    ${field_Code}    ${field_Description}  
	${operationStatus}=    Get From Dictionary    ${res_json}     ${field_OperationStatus}    #OperationStatus
	${resultCode}=    Get From Dictionary    ${operationStatus}     ${field_Code}    #Code
    ${field_Description_Developermassage}=    Set Variable If    '${res_name}'!='${CREATEATHING}'    ${field_Description}
    ...    '${res_name}'!='${CREATEAWORKER}'    ${FIELD_DEVELOPERMESSAGE}
    ...    '${res_name}'=='${CREATEATHING}'    ${FIELD_DEVELOPERMESSAGE}
    ...    '${res_name}'=='${CREATEAWORKER}'    ${FIELD_DEVELOPERMESSAGE}
	${resultDescription}=    Get From Dictionary    ${operationStatus}     ${field_Description_Developermassage}        #Description
	${ResponseResultCodeShouldHaveSuccess}=    run keyword If    ${resultCode} == ${VALUE_RESULTCODE_20000}    Response ResultCode Should Have Success    ${resultCode}    ${resultDescription}    ${res_name}
	...    ELSE IF    ${resultCode} == ${VALUE_RESULTCODE_20100}    Response ResultCode Should Have Success    ${resultCode}    ${resultDescription}    ${res_name}
	...    ELSE IF    ${resultCode} != ${VALUE_RESULTCODE_20000} and ${resultCode} != ${VALUE_RESULTCODE_20100}    Fail    msg=${res_name} Error :[${resultCode}:${resultDescription}]
    ...    ELSE IF    ${resultCode} == ${VALUE_RESULTCODE_20000} or ${resultCode} == ${VALUE_RESULTCODE_20100}    Log    ${res_name} Succeeds :[${resultCode}:${resultDescription}]
    [Return]    ${ResponseResultCodeShouldHaveSuccess}


Response ResultCode Should Have Success
    [Arguments]    ${resultCode}    ${resultDescription}    ${res_name}    

    ${shouldBeEqualResultCode}=    Run Keyword If    '${resultCode}' == '${VALUE_RESULTCODE_20000}'    Should Be Equal As Strings    ${resultCode}    ${VALUE_RESULTCODE_20000}
    ...    ELSE IF    ${resultCode} == '${VALUE_RESULTCODE_20100}'    Should Be Equal As Strings    ${resultCode}    ${VALUE_RESULTCODE_20100}
    # ...    ELSE IF    ${resultCode} != '${VALUE_RESULTCODE_20000}'    Should Be Equal As Strings    ${resultCode}    ${VALUE_RESULTCODE_20100}
    # ...    ELSE IF    ${resultCode} != '${VALUE_RESULTCODE_20100}'    Should Be Equal As Strings    ${resultCode}    ${VALUE_RESULTCODE_20100}
    
    # Log To Console    shouldBeEqualResultCode${shouldBeEqualResultCode}
    
    ${shouldBeEqualResultDescription}=    Run Keyword If    '${res_name}' == '${SINGNIN}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_SINGNIN_SUCCESS}    #singnin
    ...    ELSE IF    '${res_name}' == '${CREATEPARTNER}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_CREATEPARTNER_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${CREATEACCOUNT}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_CREATEACCOUNT_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${CREATETHING}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_CREATETHING_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${CREATETHINGSTATEINFO}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_CREATETHINGSTATEINFO_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${CREATEGROUP}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_CREATEGROUP_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${CREATECONTROLTHING}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_CREATECONTROLTHING_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${CREATECONTROLTHINGS}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_CREATECONTROLTHINGS_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${CREATECONTROLTHINGGROUP}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_CREATECONTROLTHINGGROUP_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${CREATECONTROLTHINGGROUPS}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_CREATECONTROLTHINGGROUPS_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${CREATEATHING}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_CREATEATHING_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${ACTIVATETHINGS_CENTRIC}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_ACTIVATETHINGS_CENTRIC_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${IMPORTTHING}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_IMPORTTHING_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${MAPPINGIMEI}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_MAPPINGIMEI_SUCCESS}    #create
    ...    ELSE IF    '${res_name}' == '${REMOVEPARTNER}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_REMOVEPARTNER_SUCCESS}    #remove
    ...    ELSE IF    '${res_name}' == '${REMOVEACCOUNT}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_REMOVEACCOUNT_SUCCESS}    #remove
    ...    ELSE IF    '${res_name}' == '${REMOVETHING}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_REMOVETHING_SUCCESS}    #remove
    ...    ELSE IF    '${res_name}' == '${REMOVEGROUP}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_REMOVEGROUP_SUCCESS}    #remove
    ...    ELSE IF    '${res_name}' == '${REMOVEATHING}'    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${VALUE_DESCRIPTION_REMOVEATHING_SUCCESS}    #remove
    ${result}=    Set Variable If    '${shouldBeEqualResultCode}'=='None' and '${shouldBeEqualResultDescription}'=='None'    true
    ...    '${shouldBeEqualResultCode}'!='None' and '${shouldBeEqualResultDescription}'!='None'    false
    [Return]    ${result}

Response ResultCode Should Have Error
    [Arguments]    ${res_json}    ${Code_Expect}    ${Description_Expect}  
	${operationStatus}=    Get From Dictionary    ${res_json}     ${FIELD_OPERATIONSTATUS_LOWCASE}    #OperationStatus
	${resultCode}=    Get From Dictionary    ${operationStatus}     ${FIELD_CODE_LOWCASE}    #Code
	${resultDescription}=    Get From Dictionary    ${operationStatus}     ${FIELD_DESCRIPTION_LOWCASE}    #Description
	Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultCode}    ${Code_Expect}
    Run keyword And Continue On Failure    Should Be Equal As Strings    ${resultDescription}    ${Description_Expect}

