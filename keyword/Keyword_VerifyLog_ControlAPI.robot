*** Keywords ***
####################################################
Log ControlThing
	[Arguments]    ${Code}    ${Description}    ${response}    ${pathUrl}    ${dataSearch}    ${accessToken}    ${accountId}    ${ThingId}    ${sensorKey}    ${sensorValue}	 
	#set value identity
	${identity}=    Set Variable If    '${Description}'=='${VALUE_RESULTDESC_ACCOUNTKEY_MISSING_OR_INVALID}'    {"ThingId":"${ThingId}"}	 
    ...        {"ThingID":"${ThingId}"}
	#set value custom
	${custom_accountKeyNull}=    Evaluate    {"url": "${VALUE_LOG_URL}${pathUrl}","accountkey": None,"ThingID": ["${ThingId}"]}
	${custom_accountKeyNotNull}=    Evaluate    {"url":"${VALUE_LOG_URL}${pathUrl}","accountkey":"${accountId}","ThingID":["${ThingId}"]}
	${custom}=    Set Variable If    '${Description}'=='${VALUE_RESULTDESC_ACCOUNTKEY_MISSING_OR_INVALID}'    ${custom_accountKeyNull}
    ...    ${custom_accountKeyNotNull}
    #set value body
    ${body}=    Set Variable    {"ThingId":"${ThingId}","Sensors":{"${sensorKey}":"${sensorValue}"}}
	#set value responseObject 
	${responseObject}=    Set Variable    {"OperationStatus":{"Code":"${Code}","Description":"${Description}"}}
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully],Code_detail[20000],Description_detail[The requested operation was successfully],applicationName[ProvisioningAPIs],pathUrl[mg-iot.siamimo.com/api/v1/auth/signin],dataSearch,accessToken,accountId,body[request],response[response],namespace[magellan],containerId[provisioningapis-vXX],identity,cmdName[SignInProcess],endPointName[],logLevel[INFO],custom,customDetailDB,responseObjectDetail
    Check Log Response    ${Code}    ${Description}    ${VALUE_APPLICATIONNAME_CONTROL}    ${pathUrl}    ${dataSearch}    ${accessToken}    ${accountId}    ${body}    ${response}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_CONTROL}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THING}    ${EMPTY}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${EMPTY}    ${custom}    ${responseObject}

Log ControlThings
	[Arguments]    ${Code}    ${Description}    ${response}    ${pathUrl}    ${dataSearch}    ${accessToken}    ${accountId}    ${ThingId}    ${sensorKey}    ${sensorValue}	 
	#set value identity
	${identity}=    Set Variable    {"ThingID":["${ThingId}"]}	 
	#set value custom
	${custom_accountKeyNull}=    Evaluate    {"url": "${VALUE_LOG_URL}${pathUrl}","accountkey": None,"ThingID": ["${ThingId}"]}
	${custom_accountKeyNotNull}=    Evaluate    {"url":"${VALUE_LOG_URL}${pathUrl}","accountkey":"${accountId}","ThingID":["${ThingId}"]}
	${custom}=    Set Variable If    '${Description}'=='${VALUE_RESULTDESC_ACCOUNTKEY_MISSING_OR_INVALID}'    ${custom_accountKeyNull}
    ...    ${custom_accountKeyNotNull}
    #set value body
    ${body}=    Set Variable    {"ThingId":["${ThingId}"],"Sensors":{"${sensorKey}":"${sensorValue}"}}
	#set value responseObject 
	${responseObject}=    Set Variable    {"OperationStatus":{"Code":"${Code}","Description":"${Description}"}}
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully],Code_detail[20000],Description_detail[The requested operation was successfully],applicationName[ProvisioningAPIs],pathUrl[mg-iot.siamimo.com/api/v1/auth/signin],dataSearch,accessToken,accountId,body[request],response[response],namespace[magellan],containerId[provisioningapis-vXX],identity,cmdName[SignInProcess],endPointName[],logLevel[INFO],custom,customDetailDB,responseObjectDetail
    Check Log Response    ${Code}    ${Description}    ${VALUE_APPLICATIONNAME_CONTROL}    ${pathUrl}    ${dataSearch}    ${accessToken}    ${accountId}    ${body}    ${response}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_CONTROL}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGS}    ${EMPTY}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${EMPTY}    ${custom}    ${responseObject}

Log ControlThingGroup
	[Arguments]    ${Code}    ${Description}    ${response}    ${pathUrl}    ${dataSearch}    ${accessToken}    ${accountId}    ${GroupId}    ${sensorKey}    ${sensorValue}	 
	#set value identity
	${identity}=    Set Variable If    '${Description}'!='${VALUE_RESULTDESC_THINGGROUP_MISSING}'    {"ThingGroupID":"${GroupId}"}   	 
	
	#set value custom
	${custom_accountKeyNull}=    Evaluate    {"url": "${VALUE_LOG_URL}${pathUrl}","accountkey": None,"ThingGroupID": ["${GroupId}"]}
	${custom_accountKeyNotNull}=    Evaluate    {"url":"${VALUE_LOG_URL}${pathUrl}","accountkey":"${accountId}","ThingGroupID":["${GroupId}"]}
	${custom}=    Set Variable If    '${Description}'=='${VALUE_RESULTDESC_ACCOUNTKEY_MISSING_OR_INVALID}' and '${Description}'!='${VALUE_RESULTDESC_THINGGROUP_MISSING}'    ${custom_accountKeyNull}
    ...   '${Description}'!='${VALUE_RESULTDESC_THINGGROUP_MISSING}'   ${custom_accountKeyNotNull}    

    #set value body 
	${body}=    Set Variable If    '${Description}'=='${VALUE_RESULTDESC_THINGGROUP_MISSING}'    {"Sensors":{"${sensorKey}":"${sensorValue}"}}
    ...   {"ThingGroupId":"${GroupId}","Sensors":{"${sensorKey}":"${sensorValue}"}}

	#set value responseObject 
	${responseObject}=    Set Variable If    '${Description}'!='${VALUE_RESULTDESC_THINGGROUP_MISSING}'    {"OperationStatus":{"Code":"${Code}","Description":"${Description}"}}
	...   {"ModelState":null,"OperationStatus":{"Code":"${Code}","Description":"${Description}"}}
	
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully],Code_detail[20000],Description_detail[The requested operation was successfully],applicationName[ProvisioningAPIs],pathUrl[mg-iot.siamimo.com/api/v1/auth/signin],dataSearch,accessToken,accountId,body[request],response[response],namespace[magellan],containerId[provisioningapis-vXX],identity,cmdName[SignInProcess],endPointName[],logLevel[INFO],custom,customDetailDB,responseObjectDetail
    Check Log Response    ${Code}    ${Description}    ${VALUE_APPLICATIONNAME_CONTROL}    ${pathUrl}    ${dataSearch}    ${accessToken}    ${accountId}    ${body}    ${response}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_CONTROL}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGGROUP}    ${EMPTY}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${EMPTY}    ${custom}    ${responseObject}

Log ControlThingGroups
	[Arguments]    ${Code}    ${Description}    ${response}    ${pathUrl}    ${dataSearch}    ${accessToken}    ${accountId}    ${GroupId}    ${sensorKey}    ${sensorValue}	 
	#set value identity
	#${identity}=    Set Variable If    '${Description}'!='${VALUE_RESULTDESC_THINGGROUP_MISSING}'    {"ThingGroupID":["${GroupId}"]}   	 
	${identity}=    Set Variable    {"ThingGroupID":["${GroupId}"]}   	 
	
	#set value custom
	${custom_accountKeyNull}=    Evaluate    {"url": "${VALUE_LOG_URL}${pathUrl}","accountkey": None,"ThingGroupID": ["${GroupId}"]}
	${custom_accountKeyNotNull}=    Evaluate    {"url":"${VALUE_LOG_URL}${pathUrl}","accountkey":"${accountId}","ThingGroupID":["${GroupId}"]}
	${custom}=    Set Variable If    '${Description}'=='${VALUE_RESULTDESC_ACCOUNTKEY_MISSING_OR_INVALID}' and '${Description}'!='${VALUE_RESULTDESC_THINGGROUP_MISSING}'    ${custom_accountKeyNull}
    ...   '${Description}'!='${VALUE_RESULTDESC_THINGGROUP_MISSING}'   ${custom_accountKeyNotNull}    

    #set value body 
	#${body}=    Set Variable If    '${Description}'=='${VALUE_RESULTDESC_THINGGROUP_MISSING}'    {"Sensors":{"${sensorKey}":"${sensorValue}"}}
    #...   {"ThingGroupId":"${GroupId}","Sensors":{"${sensorKey}":"${sensorValue}"}}
	${body}=    Set Variable    {"ThingGroupId":["${GroupId}"],"Sensors":{"${sensorKey}":"${sensorValue}"}}

	#set value responseObject 
	${responseObject}=    Set Variable If    '${Description}'!='${VALUE_RESULTDESC_THINGGROUP_MISSING}'    {"OperationStatus":{"Code":"${Code}","Description":"${Description}"}}
	...   {"ModelState":null,"OperationStatus":{"Code":"${Code}","Description":"${Description}"}}
	
	#resultCode_summary[20000],resultDesc_summary[The requested operation was successfully],Code_detail[20000],Description_detail[The requested operation was successfully],applicationName[ProvisioningAPIs],pathUrl[mg-iot.siamimo.com/api/v1/auth/signin],dataSearch,accessToken,accountId,body[request],response[response],namespace[magellan],containerId[provisioningapis-vXX],identity,cmdName[SignInProcess],endPointName[],logLevel[INFO],custom,customDetailDB,responseObjectDetail
    Check Log Response    ${Code}    ${Description}    ${VALUE_APPLICATIONNAME_CONTROL}    ${pathUrl}    ${dataSearch}    ${accessToken}    ${accountId}    ${body}    ${response}    ${VALUE_LOG_NAMESPACE}    ${VALUE_LOG_CONTAINERID_CONTROL}    ${identity}    ${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGGROUPS}    ${EMPTY}    ${VALUE_LOG_DETAIL_LOGLEVEL}    ${EMPTY}    ${custom}    ${responseObject}
