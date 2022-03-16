*** Variables ***
#-------------------------------------------- Field Detail Log --------------------------------------------#
${DETAIL_ENDPOINTNAME_CONTROL}    ControlAPIs
${DETAIL_ENDPOINTNAME_CONTROL_DESIRE}    desire.ex
${VALUE_DETAIL}    Detail  
${FIELD_LOG_DETAIL_SYSTEMTIMESTAP}    systemTimestamp   
${FIELD_LOG_DETAIL_LOGTYPE}    logType  
${FIELD_LOG_DETAIL_LOGLEVEL}    logLevel  
${FIELD_LOG_DETAIL_NAMESPACE}    namespace  
${FIELD_LOG_DETAIL_APPLICATIONNAME}    applicationName  
${FIELD_LOG_DETAIL_CONTAINERID}    containerId
${FIELD_LOG_DETAIL_SESSIONID}    sessionId  
${FIELD_LOG_DETAIL_TID}    tid 
${FIELD_LOG_DETAIL_CUSTOM1}    custom1   
${FIELD_LOG_DETAIL_CUSTOM2}    custom2   
${FIELD_LOG_DETAIL_ENDPOINTNAME}    endPointName
${FIELD_LOG_DETAIL_REQUESTOBJECT}    requestObject
${FIELD_LOG_DETAIL_URL}    url
${FIELD_LOG_DETAIL_HEADERS}    headers
${FIELD_LOG_DETAIL_XAISORDERREF}    x-ais-OrderRef
${FIELD_LOG_DETAIL_BODY}    body
${FIELD_LOG_DETAIL_IMSI}    Imsi
${FIELD_LOG_DETAIL_IPADDRESS}    IpAddress        
${FIELD_LOG_DETAIL_RESPONSEOBJECT}    responseObject
${FIELD_LOG_DETAIL_THINGTOKEN}    ThingToken
${FIELD_LOG_DETAIL_OPERATIONSTATUS}    OperationStatus
${FIELD_LOG_DETAIL_OPERATIONSTATUS_CODE}    Code
${FIELD_LOG_DETAIL_OPERATIONSTATUS_DESCRIPTION}    Description
${FIELD_LOG_DETAIL_ACTIVITYLOG}    activityLog
${FIELD_LOG_DETAIL_ACTIVITYLOG_STARTTIME}    startTime
${FIELD_LOG_DETAIL_ACTIVITYLOG_ENDTIME}    endTime
${FIELD_LOG_DETAIL_ACTIVITYLOG_PROCESSTIME}    processTime
${FIELD_LOG_DETAIL_COMMAND}    Command 
${FIELD_LOG_DETAIL_STATUS}    Status
${FIELD_LOG_DETAIL_ORDERREF}    OrderRef 
${VALUE_LOG_DETAIL_LOGLEVEL}    INFO  
${VALUE_LOG_DETAIL_CUSTOM2}    ${NONE}
${VALUE_LOG_DETAIL_VERSION}    v1
#-------------------------------------------- requestObject and responseObject Control Thing --------------------------------------------#
#requestObject
${VALUE_LOG_DETAIL_REQUESTOBJECT_APP_CONTROL}    "{"url":"[valuePathUrl]","method":"[method]","headers":{"x-ais-username":"AisPartner","x-ais-orderref":"[tid]","x-ais-orderdesc":"[Orderdesc]","x-ais-accesstoken":"[AccessToken]","x-ais-accountkey":"[AccountId]"},"body":[body]}"    
${VALUE_LOG_DETAIL_REQUESTOBJECT_NOTENDPOINT_CONTROL}    "{"headers":{"x-ais-username":"AisPartner","x-ais-orderref":"[tid]","x-ais-orderdesc":"[Orderdesc]","x-ais-accesstoken":"[AccessToken]"},"body":"[body]"}"
${VALUE_LOG_DETAIL_REQUESTOBJECT_APP_CONTROL_ENDPOINT_DESIRE}    "{"RoutingKey":"[valuePathUrl]","Payload":"[body]""},"headers":{"timestamp_in_ms":"[tid]]","x-ais-orderref":"[tid]","x_protocol":"CONTROL"}"    

#responseObject
${VALUE_LOG_DETAIL_RESPONSEOBJECT_APP_CONTROL}    "{"OperationStatus":{"Code":"[Code]","Description":"[Description]"}}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_APP_CONTROL_MISSINGTHINGGROUP}    "{\"ModelState\":null,\"OperationStatus\":{\"Code\":\"[Code]\",\"Description\":\"[Description]\"}}"
${VALUE_LOG_DETAIL_RESPONSEOBJECT_NOTHAVEDETAIL_ERROR}    "{\"OperationStatus\":{\"Code\":\"[Code]\",\"Description\":\"[Description]\"}}"
#-------------------------------------------- Field Summary Log --------------------------------------------#
${VALUE_SUMMARY}    Summary 
${FIELD_LOG_SUMMARY_SYSTEMTIMESTAP}    systemTimestamp   
${FIELD_LOG_SUMMARY_LOGTYPE}    logType  
${FIELD_LOG_SUMMARY_NAMESPACE}    namespace
${FIELD_LOG_SUMMARY_APPLICATIONNAME}    applicationName
${FIELD_LOG_SUMMARY_CONTAINERID}    containerId
${FIELD_LOG_SUMMARY_SESSIONID}    sessionId
${FIELD_LOG_SUMMARY_TID}    tid 
${FIELD_LOG_SUMMARY_IDENTITY}    identity 
${FIELD_LOG_SUMMARY_CMDNAME}    cmdName  
${FIELD_LOG_SUMMARY_RESULTCODE}    resultCode  
${FIELD_LOG_SUMMARY_RESULTDESC}    resultDesc
${FIELD_LOG_SUMMARY_CUSTOM}    custom
${FIELD_LOG_SUMMARY_CUSTOMDATA}    customData
${FIELD_LOG_SUMMARY_ENDPOINTSUMMARY}    endPointSummary
${FIELD_LOG_SUMMARY_REQTIMESTAP}    reqTimestamp 
${FIELD_LOG_SUMMARY_RESTIMESTAMP}    resTimestamp  
${FIELD_LOG_SUMMARY_USAGETIME}    usageTime 

${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THING}    Thing
${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGS}    Things
${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGGROUP}    ThingGroup
${VALUE_LOG_SUMMARY_CMDNAME_CONTROL_THINGGROUPS}    ThingGroups



