*** Keywords ***	
Post Search Log
    [Arguments]    ${url}    ${valueSearch}    ${value_applicationName}    
	${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    Authorization=${HEADER_AUTHENTICATION}    kbn-version=7.5.1  
    #${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    Host=azmagellancd001-iot.southeastasia.cloudapp.azure.com:30380    kbn-version=7.5.1    Origin=http://azmagellancd001-iot.southeastasia.cloudapp.azure.com:30380    
	# Log To Console    ${headers}	
	#return valueDateGte,valueDateLte (RANGE_SEARCH 15 minutes)
	${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    ${RANGE_SEARCH}    ${TIME_STRING_MINUTES}
	#${setRange}=    Rang Get Value Minus Time Current Date and Change Format    ${YYYYMMDDTHMSZ_FROM_NOW}    50    ${TIME_STRING_MINUTES}
	#Log To Console    setRange${setRange}
	${setRangeGTE}=    Set variable    ${setRange}[0]
	${setRangeLTE}=    Set variable    ${setRange}[1]
	Log    valueSearch${valueSearch}
	${multiMatchType}=    Set Variable    best_fields
    ${data}=    Evaluate    {"version":"true","size":500,"sort":[{"@timestamp_es":{"order":"desc","unmapped_type":"boolean"}}],"_source":{"excludes":[]},"aggs":{"2":{"date_histogram":{"field":"@timestamp_es","fixed_interval":"30s","time_zone":"Asia/Bangkok","min_doc_count":1}}},"stored_fields":["*"],"script_fields":{},"docvalue_fields":[{"field":"@timestamp_es","format":"date_time"},{"field":"cauldron.custom1.activityLog.endTime","format":"date_time"},{"field":"cauldron.custom1.activityLog.startTime","format":"date_time"},{"field":"time","format":"date_time"}],"query":{"bool":{"must":[],"filter":[{"multi_match":{"type":"${multiMatchType}","query":"${valueSearch}","lenient":"true"}},{"range":{"@timestamp_es":{"format":"strict_date_optional_time","gte":"${setRangeGTE}","lte":"${setRangeLTE}"}}}],"should":[],"must_not":[]}},"highlight":{"pre_tags":["@kibana-highlighted-field@"],"post_tags":["@/kibana-highlighted-field@"],"fields":{"*":{}},"fragment_size":2147483647}}
    # Log To Console    ${data}
	# Log To Console    ${url}
    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}    ${EMPTY}    ${headers}    ${data}
	Log    ${res}
	
	${total}=    Set variable    ${res['hits']['total']}
	Log    ${total}
	Should Not Be Equal     ${total}    0
	# Log To Console    ${res}
	Sleep    10s
	[return]    ${res}
	
Get tid for Search Log
    [Arguments]    ${value_applicationName}    ${valueSearch}    ${endPointName}
	#Log To Console    value_applicationName${value_applicationName}	
	#Log To Console    valueSearch${valueSearch}	
	${resLog}=    Wait Until Keyword Succeeds    3x    10s    Post Search Log    ${URL_GET_LOG}    ${valueSearch}    ${value_applicationName}
	Log    resLog${resLog}	
	${total}=    Set variable    ${resLog['hits']['total']}
	# Log To Console    resLog0${resLog}  
	# Log To Console    total${total}  
	#Run Keyword And Return If    '${total}'=='0'    ${resLog}
	Should Not Be Equal     ${total}    0
	@{valArrData}=    Create List
	FOR    ${i}    IN RANGE    ${total}
        # Log To Console    ${i}  
	    ${valLog}=    Set variable    ${resLog['hits']['hits'][${i}]['_source']['cauldron']}
        # Log To Console    applicationName${valLog['applicationName']}
        # Log To Console    valLog${valLog}		
	    ${applicationName}=    Set variable    ${valLog['applicationName']}
        # Log To Console    applicationName${applicationName}
		Run Keyword If    '${applicationName}'=='${value_applicationName}'     Append To List    ${valArrData}    ${valLog}        #Add data to array set at valArrData
		# Run Keyword If    '${valueSearch}'=='${ASGARD_COAPAPI_VALUE_TST_F4_0_2_003_DATASEARCH}'    Append To List    ${valArrData}    ${valLog}        #Add data to array set at valArrData		
        # Exit For Loop
	END
	#Log To Console    tivalArrDatad${valArrData}
    ${tid}=    Set variable    ${valArrData[0]['tid']}
	Log To Console    tid${tid}
	${sessionId}=    Set variable    ${valArrData[0]['sessionId']}
	Log To Console    sessionId${sessionId}
    [return]    ${tid}    ${sessionId}
	
Data Log Response
    [Arguments]    ${value_applicationName}    ${valueSearch}    ${endPointName}	
	Sleep    2s
	${resTid}=    Wait Until Keyword Succeeds    3x    10s    Get tid for Search Log    ${value_applicationName}    ${valueSearch}    ${endPointName}   
	${resLog}=    Wait Until Keyword Succeeds    3x    5s    Post Search Log    ${URL_GET_LOG}    ${resTid}[0]    ${value_applicationName}
    Log    resLog${resLog}	
	#Sleep    10s		
	${total}=    Set variable    ${resLog['hits']['total']}
	Log To Console    total11${total}	
    @{valArrData}=    Create List
	@{valArrDetail}=    Create List
	@{valArrSummary}=    Create List
	FOR    ${i}    IN RANGE    ${total}
        # Log To Console    ${i}  
	    ${valLog}=    Set variable    ${resLog['hits']['hits'][${i}]['_source']['log']}
        # Log To Console    valLog${valLog}
        # use for parameter / have in data 
	    ${dataResponse}=    Evaluate    json.loads(r'''${valLog}''')    json
        # Log To Console    dataRespon/se${dataResponse}	
	    ${applicationName}=    Set variable    ${dataResponse['applicationName']}
        # Log To Console    applicationName${applicationName}
		${logType}=    Set variable    ${dataResponse['logType']}
        # Log To Console    logType${logType}
	    Run Keyword If    '${applicationName}'=='${value_applicationName}'    Append To List    ${valArrData}    ${dataResponse}    #Add data to array set at valArrData
		Run Keyword If    '${applicationName}'=='${value_applicationName}' and '${logType}'=='${VALUE_DETAIL}'   Append To List    ${valArrDetail}    ${dataResponse}    #Add data to array set at valArrDetail
		Run Keyword If    '${applicationName}'=='${value_applicationName}' and '${logType}'=='${VALUE_SUMMARY}'   Append To List    ${valArrSummary}    ${dataResponse}    #Add data to array set at valArrSummary		
    END
	# Log To Console    valArrData${valArrData}  
	Log To Console    valArrDetail${valArrDetail}  
	Log To Console    valArrSummary${valArrSummary}  
    [return]    ${valArrData}    ${valArrDetail}    ${valArrSummary}    ${resTid}[0]    ${resTid}[1]

Check Log Detail 
    [Arguments]    ${code}    ${description}     ${data}    ${tid}    ${applicationName}     ${pathUrl}    ${dataSearch}    ${accessToken}    ${accountId}    ${body}    ${response}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${custom}    ${customDetailDB}    ${responseObjectDetail}   
    Log To Console  ============= Check Log Detail ================
    Log    data${data} 
	
	${dataLogDetail}=    Run keyword And Continue On Failure    Log Detail Check EndPointName    ${data}
    Log    ${dataLogDetail}    
	${valArrDetailHaveEndPointName}=    Set Variable    ${dataLogDetail}[0]
	Log    ${valArrDetailHaveEndPointName}
	${valArrDetailNotHaveEndPointName}=    Set Variable    ${dataLogDetail}[1]
	Log    ${valArrDetailNotHaveEndPointName}

	${langValArrDetailHaveEndPointName}=    Get Length    ${valArrDetailHaveEndPointName}
	${langValArrDetailNotHaveEndPointName}=    Get Length    ${valArrDetailNotHaveEndPointName}

	Run Keyword If    '${langValArrDetailHaveEndPointName}'!='0'    Check Log Detail Have EndPointName    ${code}    ${description}     ${valArrDetailHaveEndPointName}    ${tid}    ${applicationName}     ${pathUrl}    ${dataSearch}    ${accessToken}    ${accountId}    ${body}    ${response}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${custom}    ${customDetailDB}    ${responseObjectDetail}
    Run Keyword If    '${langValArrDetailNotHaveEndPointName}'!='0'    Check Log Detail App Do Not Have EndPointName    ${code}    ${description}     ${valArrDetailNotHaveEndPointName}    ${tid}    ${applicationName}     ${pathUrl}    ${dataSearch}    ${body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${accountId}    ${accessToken}    ${responseObjectDetail}
	
Log Detail Check EndPointName
    [Arguments]    ${data}
	${data_count}=    Get Length    ${data}
	#Log To Console    data_count${data_count}
    @{valArrDetailHaveEndPointName}=    Create List
	@{valArrDetailNotHaveEndPointName}=    Create List
    FOR    ${i}    IN RANGE    ${data_count}
	    ${keyCustom1}=    Set Variable   @{data[${i}]['custom1']}
		# Log To Console    ${keyCustom1}    
		${checkKeyEndPointName}=    Get Matches    ${keyCustom1}    endPointName
		${countKeyEndPointName}=    Get Length    ${checkKeyEndPointName}
		#Log To Console    checkKeyEndPointName${checkKeyEndPointName} 
		#Log To Console    countKeyEndPointName${countKeyEndPointName} 
		Run Keyword If    ${countKeyEndPointName}==1    Append To List    ${valArrDetailHaveEndPointName}    ${data}[${i}]    #Add data to array set at valArrData
		Run Keyword If    ${countKeyEndPointName}==0    Append To List    ${valArrDetailNotHaveEndPointName}    ${data}[${i}]    #Add data to array set at valArrData
		
		#${data[${i}]['custom1']['endPointName']}
	END	
	# Log To Console    valArrDetailHaveEndPointName${valArrDetailHaveEndPointName}  
	# Log To Console    valArrDetailNotHaveEndPointName${valArrDetailNotHaveEndPointName}  
	[return]    ${valArrDetailHaveEndPointName}    ${valArrDetailNotHaveEndPointName}

#============================================ Check Log Detail ===============================================================
#-------------------------------------------- Check Log Detail Have EndPointName --------------------------------------------#	
Check Log Detail Have EndPointName  
    [Arguments]    ${code}    ${description}     ${data}    ${tid}    ${applicationName}     ${pathUrl}    ${dataSearch}    ${accessToken}    ${accountId}    ${body}    ${response}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${custom}    ${customDetailDB}    ${responseObjectDetail}
    Log To Console  ============= Check Log Detail Have EndPointName ================
	${data_count}=    Get Length    ${data}
	# Log To Console    data_count${data_count}  
	# Log To Console    data${data} 
	# ${thingToken}=    Set Variable
	FOR    ${i}    IN RANGE    ${data_count}
		
		#Log To Console    ${data[${i}]['custom1']['requestObject']}
		#Log To Console    ${data[${i}]['custom1']['endPointName']}
		#Log To Console    ${code}
		
	    ${dataResponse}=    Set Variable    ${data[${i}]}
		# Log To Console    dataResponse${dataResponse}  
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}']    ${data[${i}]['systemTimestamp']}    ${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGTYPE}']    ${VALUE_DETAIL}    ${FIELD_LOG_DETAIL_LOGTYPE} 
        Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGLEVEL}']    ${logLevel}    ${FIELD_LOG_DETAIL_LOGLEVEL} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_NAMESPACE}']    ${namespace}    ${FIELD_LOG_DETAIL_NAMESPACE}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_APPLICATIONNAME}']    ${applicationName}    ${FIELD_LOG_DETAIL_APPLICATIONNAME}
		#Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CONTAINERID}']    ${containerId}    ${FIELD_LOG_DETAIL_CONTAINERID}
        # Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SESSIONID}']    ${tid}    ${FIELD_LOG_DETAIL_SESSIONID}
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_TID}']    ${tid}    ${FIELD_LOG_DETAIL_TID}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME}']    ${data[${i}]['custom1']['activityLog']['startTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}']    ${data[${i}]['custom1']['activityLog']['endTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}']    ${data[${i}]['custom1']['activityLog']['processTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}
        Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM2}']    ${VALUE_LOG_DETAIL_CUSTOM2}    ${FIELD_LOG_DETAIL_CUSTOM2}
		Run Keyword If    '${code}'!='20000' and '${cmdName}'!= '${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGGROUP}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_STATUS}']    ${code}:${description}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_STATUS} 
		Run Keyword If    '${data[${i}]['custom1']['endPointName']}'=='${DETAIL_ENDPOINTNAME_CONTROL}'    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ENDPOINTNAME}']    ${DETAIL_ENDPOINTNAME_CONTROL}    ['endPointName']
		#Custom
		${json_endPointName}=    Set Variable If    '${custom}'!='null' and '${data[${i}]['custom1']['endPointName']}'!='${DETAIL_ENDPOINTNAME_CONTROL}'         Convert String to JSON    ${endPointName}
		${dataEndPointName}=    Set Variable If    '${custom}'!='null' and '${data[${i}]['custom1']['endPointName']}'!='${DETAIL_ENDPOINTNAME_CONTROL}'         ${json_endPointName[${i}]}
		# Log To Console    dataEndPointName${dataEndPointName}  
	Run Keyword If    '${endPointName}'=='${DETAIL_ENDPOINTNAME_CONTROL}'    Check Log Detail Custom RequestObject and ResponseObject    ${code}    ${description}    ${dataResponse}    ${dataSearch}    ${tid}    ${cmdName}    ${dataEndPointName}    ${accessToken}    ${accountId}    ${body}    ${response}    ${applicationName}    ${pathUrl}    ${custom}    ${EMPTY}    ${responseObjectDetail} 
        
	END
#-------------------------------------------- Check Log Detail : RequestObject and ResponseObject Have EndPointName --------------------------------------------#		
Check Log Detail Custom RequestObject and ResponseObject
	[Arguments]    ${code}    ${description}    ${dataResponse}    ${dataSearch}    ${tid}    ${cmdName}    ${endPointName}    ${accessToken}    ${accountId}    ${body}    ${response}    ${applicationName}    ${pathUrl}   ${custom}    ${dataCustomDetailDB}    ${responseObjectDetail} 
	#-------------------------------------------- Control --------------------------------------------#
	Check RequestObject endPointName ControlAPIs     ${dataResponse}    ${pathUrl}    ${tid}    ${body}    ${response}    ${accessToken}    ${accountId}    ${cmdName}
	Check ResponseObject endPointName ControlAPIs     ${code}    ${description}    ${dataResponse}

#-------------------------------------------- Check Log Detail : RequestObject and ResponseObject --------------------------------------------#	
Check RequestObject endPointName ControlAPIs	
    [Arguments]    ${dataResponse}    ${pathUrl}    ${tid}    ${body}    ${response}    ${accessToken}    ${accountId}    ${cmdName}
    Log To Console  ============= Check RequestObject ===============
	${method}=    Set Variable    ${NAME_SESSION_POST}
	${orderdesc}=    Set Variable If    '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THING}'    ${HEADER_X_AIS_ORDERDESC_CREATECONTROLAPI}
	...    '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGS}'    ${HEADER_X_AIS_ORDERDESC_CREATECONTROLAPI}
	...    '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGGROUP}'    ${HEADER_X_AIS_ORDERDESC_CREATECONTROLAPI}    
	...    '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGGROUPS}'    ${HEADER_X_AIS_ORDERDESC_CREATECONTROLAPI}

	${valueReplace}=    Set Variable    ${VALUE_LOG_DETAIL_REQUESTOBJECT_APP_CONTROL}

	${replaceUrl}=    Replace String    ${valueReplace}    [valuePathUrl]    ${VALUE_LOG_URL}${pathUrl}
	${replaceTid}=    Replace String    ${replaceUrl}    [tid]    ${tid}
	${replaceAccessToken}=    Replace String    ${replaceTid}    [AccessToken]    ${FIELD_BEARER} ${accessToken}
	${replaceAccountId}=    Replace String    ${replaceAccessToken}    [AccountId]    ${accountId}
	${replaceBody}=    Replace String    ${replaceAccountId}    [body]    ${body}
	${replaceMethod}=    Replace String    ${replaceBody}    [method]    ${method}
	${replaceOrderdesc}=    Replace String    ${replaceMethod}    [Orderdesc]    ${orderdesc}
	${requestObject}=    Replace String To Object    ${replaceOrderdesc}

	# Log To Console    ProvisioningThingRequestObjectApp${requestObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT}
	
Check ResponseObject endPointName ControlAPIs	
    [Arguments]    ${code}    ${description}    ${dataResponse}
    Log To Console  ============= Check ResponseObject ===============
	${responseObject_data}=    Set Variable If    '${description}'!='${VALUE_RESULTDESC_THINGGROUP_MISSING}'    ${VALUE_LOG_DETAIL_RESPONSEOBJECT_APP_CONTROL}
	...   ${VALUE_LOG_DETAIL_RESPONSEOBJECT_APP_CONTROL_MISSINGTHINGGROUP}
	Log    ${responseObject_data} 
	${replaceCode}    Replace String    ${responseObject_data}    [Code]    ${code}  
	${replaceDescription}=    Replace String    ${replaceCode}    [Description]    ${description}
    ${responseObject}=    Replace String To Object    ${replaceDescription}

	# Log To Console    ProvisioningRenewTokenresponseObject${responseObject}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT}


#-------------------------------------------- Check Log Detail Do Not Have EndPointName --------------------------------------------#		
Check Log Detail App Do Not Have EndPointName
    [Arguments]    ${code}    ${description}     ${data}    ${tid}    ${applicationName}     ${pathUrl}    ${dataSearch}    ${body}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${accountId}    ${accessToken}    ${responseObjectDetail}
    Log To Console  ============= Check Log Detail App Do Not Have EndPointName ================
	${data_count}=    Get Length    ${data}
	# Log To Console    data_count${data_count}  
	FOR    ${i}    IN RANGE    ${data_count}
	 
	    ${dataResponse}=    Set Variable    ${data[${i}]}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}']    ${data[${i}]['systemTimestamp']}    ${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGTYPE}']    ${VALUE_DETAIL}    ${FIELD_LOG_DETAIL_LOGTYPE}
        Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_LOGLEVEL}']    ${logLevel}    ${FIELD_LOG_DETAIL_LOGLEVEL}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_NAMESPACE}']    ${namespace}    ${FIELD_LOG_DETAIL_NAMESPACE}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_APPLICATIONNAME}']    ${applicationName}    ${FIELD_LOG_DETAIL_APPLICATIONNAME}
		#Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CONTAINERID}']    ${containerId}    ${FIELD_LOG_DETAIL_CONTAINERID}
        # Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_SESSIONID}']    ${tid}    ${FIELD_LOG_DETAIL_SESSIONID}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_TID}']    ${tid}    ${FIELD_LOG_DETAIL_TID}
		Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_COMMAND}']    ${cmdName}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_COMMAND} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_STATUS}']    ${code}:${description}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_STATUS} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ORDERREF}']    ${dataSearch}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ORDERREF}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME}']    ${data[${i}]['custom1']['activityLog']['startTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME} 
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}']    ${data[${i}]['custom1']['activityLog']['endTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}
	    Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_ACTIVITYLOG}']['${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}']    ${data[${i}]['custom1']['activityLog']['processTime']}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_ACTIVITYLOG}.${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}
        Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM2}']    ${VALUE_LOG_DETAIL_CUSTOM2}    ${FIELD_LOG_DETAIL_CUSTOM2}
		Check Log Detail Custom RequestObject and ResponseObject App    ${code}    ${description}    ${applicationName}    ${dataResponse}    ${accountId}    ${tid}    ${cmdName}    ${endPointName}    ${body}    ${pathUrl}    ${accessToken}    ${responseObjectDetail}
				
	END
#-------------------------------------------- Check Log Detail : RequestObject and ResponseObject --------------------------------------------#		
Check Log Detail Custom RequestObject and ResponseObject App
	[Arguments]    ${code}    ${description}    ${applicationName}    ${dataResponse}    ${accountId}    ${tid}    ${cmdName}    ${endPointName}    ${body}    ${pathUrl}    ${accessToken}    ${responseObject}

	${orderdesc}=    Set Variable If    '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THING}'    ${HEADER_X_AIS_ORDERDESC_CREATECONTROLAPI}
	...    '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGS}'    ${HEADER_X_AIS_ORDERDESC_CREATECONTROLAPI}
	...    '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGGROUP}'    ${HEADER_X_AIS_ORDERDESC_CREATECONTROLAPI}    
	...    '${cmdName}'=='${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGGROUPS}'    ${HEADER_X_AIS_ORDERDESC_CREATECONTROLAPI}

	${valueReplace}=    Set Variable    ${VALUE_LOG_DETAIL_REQUESTOBJECT_NOTENDPOINT_CONTROL}

	${replaceTid}=    Replace String    ${valueReplace}    [tid]    ${tid}
	${replaceOrderdesc}=    Replace String    ${replaceTid}    [Orderdesc]    ${orderdesc}
	${replaceAccessToken}=    Replace String    ${replaceOrderdesc}    [AccessToken]    ${FIELD_BEARER} ${accessToken}
	${replaceAccountId}=    Replace String    ${replaceAccessToken}    [AccountId]    ${accountId}
	${replaceBody}=    Replace String    ${replaceAccountId}    [body]    ${body}
	${requestObject}=    Replace String To Object    ${replaceBody}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_REQUESTOBJECT}']    ${requestObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_REQUESTOBJECT} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_DETAIL_CUSTOM1}']['${FIELD_LOG_DETAIL_RESPONSEOBJECT}']    ${responseObject}    ${FIELD_LOG_DETAIL_CUSTOM1}.${FIELD_LOG_DETAIL_RESPONSEOBJECT} 


Check Log Response 
    #resultCode_summary[20000],resultDesc_summary[The requested operation was successfully],Code_detail[20000],Description_detail[The requested operation was successfully],applicationName,pathUrl,dataSearch,accessToken,accountId,body[request],response[response],namespace,containerId,identity,cmdName,endPointName,logLevel,custom,customDetailDB,responseObjectDetail
    [Arguments]    ${code}    ${description}    ${applicationName}    ${pathUrl}     ${dataSearch}    ${accessToken}    ${accountId}    ${body}    ${response}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${endPointName}    ${logLevel}    ${customDetail}    ${customSummary}    ${responseObjectDetail}
    #Log To Console    imsi_thingTokenimsi_thingToken${imsi_thingToken}
	#return valArrData,valArrDetail,valArrSummary,tid
	${dataLogResponse}=    Data Log Response    ${applicationName}    ${dataSearch}    ${endPointName}
	Log    Log is ${dataLogResponse}
	
	Check Log Detail    ${code}    ${description}    ${dataLogResponse}[1]    ${dataLogResponse}[3]    ${applicationName}    ${pathUrl}    ${dataSearch}    ${accessToken}    ${accountId}    ${body}    ${response}    ${endPointName}    ${logLevel}    ${namespace}    ${containerId}    ${cmdName}    ${customDetail}    ${EMPTY}    ${responseObjectDetail}  
    Check Log Summary    ${code}    ${description}    ${dataLogResponse}[2]    ${dataLogResponse}[3]    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${customSummary}


#============================================ Check Log Summary ===============================================================
Check Log Summary
    [Arguments]    ${resultCode}    ${resultDesc}    ${data}    ${tid}    ${applicationName}    ${namespace}    ${containerId}    ${identity}    ${cmdName}    ${custom}
    Log To Console  ============= Check Log Summary ================
	${dataResponse}=    Set Variable    ${data[0]} 
    Log    ${dataResponse}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_SYSTEMTIMESTAP}']    ${data[0]['systemTimestamp']}    ${FIELD_LOG_SUMMARY_SYSTEMTIMESTAP}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_LOGTYPE}']    ${VALUE_SUMMARY}    ${FIELD_LOG_SUMMARY_LOGTYPE}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_NAMESPACE}']    ${namespace}    ${FIELD_LOG_SUMMARY_NAMESPACE}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_APPLICATIONNAME}']    ${applicationName}    ${FIELD_LOG_SUMMARY_APPLICATIONNAME}
	#Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CONTAINERID}']    ${containerId}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_SESSIONID}']    ${data[0]['sessionId']}    ${FIELD_LOG_SUMMARY_SESSIONID}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_TID}']    ${data[0]['tid']}    ${FIELD_LOG_SUMMARY_TID}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_IDENTITY}']    ${identity}    ${FIELD_LOG_SUMMARY_IDENTITY}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CMDNAME}']    ${cmdName}    ${FIELD_LOG_SUMMARY_CMDNAME} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_RESULTCODE}']    ${resultCode}    ${FIELD_LOG_SUMMARY_RESULTCODE} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_RESULTDESC}']    ${resultDesc}    ${FIELD_LOG_SUMMARY_RESULTDESC}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_REQTIMESTAP}']    ${data[0]['reqTimestamp']}    ${FIELD_LOG_SUMMARY_REQTIMESTAP} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_RESTIMESTAMP}']    ${data[0]['resTimestamp']}    ${FIELD_LOG_SUMMARY_RESTIMESTAMP}
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_USAGETIME}']    ${data[0]['usageTime']}    ${FIELD_LOG_SUMMARY_USAGETIME} 
	Check Json Data Should Be Equal    ${dataResponse}    ['${FIELD_LOG_SUMMARY_CUSTOM}']    ${custom}    ${FIELD_LOG_SUMMARY_CUSTOM}
