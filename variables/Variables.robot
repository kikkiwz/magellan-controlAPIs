*** Settings ***
Resource    ../variables/Variables_CreateData.robot
Resource    ../variables/Variables_Log.robot 

*** Variables ***
${timeout}    0.5 second
${delay}    0.3
${retry}    5x   
${retry_interval}    5s
#=========== ENV =============
#STAGING	
# ${URL}    https://mg-staging.siamimo.com
# ${SIGNIN_USERNAME}    QATest_003
# ${SIGNIN_PASSOWORD}    bnZkZm5nZXJnbGtkanZlaWdqbmVvZGtsZA==
# ${URL_GET_LOG}    https://mg-staging.siamimo.com:30380/elasticsearch/application*/_search?rest_total_hits_as_int=true&ignore_unavailable=true&ignore_throttled=true&preference=1620900474581&timeout=30000ms
# ${VALUE_APPLICATIONNAME_CONTROL}    ControlAPIs
# ${VALUE_LOG_URL}    mg-iot.staging.com
#${VALUE_LOG_NAMESPACE}    Magellan 
#IOT ProvisioningAPIs
${URL}    https://mg-iot.siamimo.com
${URL_CENTRIC}    https://mgcentric-iot.siamimo.com
${URL_GET_LOG}    https://mg-iot.siamimo.com:30380/elasticsearch/application*/_search?rest_total_hits_as_int=true&ignore_unavailable=true&ignore_throttled=true&preference=1620900474581&timeout=30000ms
${VALUE_APPLICATIONNAME_CONTROL}    ControlAPIs
${VALUE_LOG_URL}    mg-iot.siamimo.com
${VALUE_LOG_NAMESPACE}    magellan
${VALUE_LOG_CONTAINERID_CONTROL}    controlapis-v22 

#=========== Usename,Pass =============
#IOT
#RootAdmin
${SIGNIN_USERNAME_ROOTADMIN}    QA_SC
${SIGNIN_PASSOWORD_ROOTADMIN}    VGVzdDEyMzQ=
#SupplierAdmin
${SIGNIN_USERNAME_SUPPLIERADMIN}    sctest_supplierddmin
${SIGNIN_PASSOWORD_SUPPLIERADMIN}    dGVzdDEyMzQ=
#CustomerAdmin
${SIGNIN_USERNAME_CUSTOMERADMIN}    sctest_customeradmin
${SIGNIN_PASSOWORD_CUSTOMERADMIN}    dGVzdDEyMzQ=
#Supplier
${SIGNIN_USERNAME_SUPPLIER}    sctest_supplier
${SIGNIN_PASSOWORD_SUPPLIER}    dGVzdDEyMzQ=
#Customer
${SIGNIN_USERNAME_CUSTOMER}    sctest_customer
${SIGNIN_PASSOWORD_CUSTOMER}    dGVzdDEyMzQ=
#=========== Sub URL =============
${PROVISIONINGAPIS}    /provisioningapis
${CONTROLAPIS}    /controlapis
${CENTRICAPIS}    /centricapis
#=========== Header =============
${HEADER_CONTENT_TYPE}    application/json
${HEADER_ACCEPT}    */* 
${HEADER_X_AIS_USERNAME_AISPARTNER}    AisPartner
${HEADER_AUTHENTICATION}    Basic ZWxhc3RpYzpSM2RoQHQhQCM=
#=========== NAME_SESSION =============
${NAME_SESSION_GET}    GET
${NAME_SESSION_POST}    POST
${NAME_SESSION_PUT}    PUT
${NAME_SESSION_DELETE}    DELETE
#=========== Status code =============
${STATUS_CODE_SUCCESS}    200
${STATUS_CODE_CREATE}    201
#=========== ResultCode =============
${VALUE_RESULTCODE_40000}    40000
${VALUE_RESULTCODE_40300}    40300
${VALUE_RESULTCODE_40400}    40400
${VALUE_RESULTCODE_40301}    40301
${VALUE_RESULTCODE_40305}    40305
${VALUE_RESULTCODE_20000}    20000
${VALUE_RESULTCODE_20100}    20100
${VALUE_RESULTCODE_50000}    50000 
#=========== ResultDesc=============
${RESULTDESC_OK}    OK
${RESULTDESC_THE_REQUEST_OPERATION_WAS_SUCCESS}    The requested operation was successfully
#status
${VALUE_STATUS_SUCCESS}     Success
${VALUE_RESULTDESC_SUCCESS}    SUCCESS
${VALUE_RESULTDESC_ACCOUNTKEY_MISSING_OR_INVALID}    The Parameter x-ais-AccountKey is Missing Or Invalid
${VALUE_RESULTDESC_THING_NOT_OBJECTID}    The ThingId field is not Object Id.
${VALUE_RESULTDESC_THING_NOT_FOUND}    The ThingId is Not Found
${VALUE_RESULTDESC_SENSORNAME_NOT_FOUND}    The Sensors is Not Found
${VALUE_RESULTDESC_THINGGROUP_MISSING}    The Parameter The ThingGroupId field is required. is Missing Or Invalid
${VALUE_RESULTDESC_THINGGROUP_NOT_OBJECTID}    The ThingGroupId field is not Object Id.
${VALUE_RESULTDESC_THINGGROUP_NOT_FOUND}    The ThingGroupId is Not Found
#=========== Field Name=============
${FIELD_BEARER}    Bearer 
${FIELD_OPERATIONSTATUS}    OperationStatus
${FIELD_CODE}    Code
${FIELD_DESCRIPTION}    Description
${FIELD_OPERATIONSTATUS_LOWCASE}    operationStatus
${FIELD_CODE_LOWCASE}    code
${FIELD_DESCRIPTION_LOWCASE}    description
${FIELD_DEVELOPERMESSAGE}    DeveloperMessage
${FIELD_STATUS}    Status 
${FIELD_STATUSDESCRIPTION}    StatusDescription
#=========== Date Time ================
${MoY}    {dt:%B} {dt.year}
${HMS}    {dt:%H}:{dt:%M}:{dt:%S}
${HM}    {dt:%H}:{dt:%M}
${MDYYYY_ADDSUB}    %m/%d/%Y
${DDMMYYYY_ADDSUB}    %d/%m/%Y
${MDYYYY_NOW}    {dt:%m}/{dt:%d}/{dt:%Y}
${DDMMYYYY_NOW}    {dt:%d}/{dt:%m}/{dt:%Y}
${DDMMYYYYHMS_NOW}    {dt:%d}{dt:%m}{dt:%Y}{dt:%H}{dt:%M}{dt:%S}
${YYYYMMDDTHMSZ}    %Y-%m-%dT%H:%M:%S.000Z
${YYYYMMDDTHMSZ_FROM_NOW}    %Y-%m-%dT%H:%M:%S.000Z
${YYYYMMDDTHMSZ_TO_NOW}    %Y-%m-%dT%H:%M:%S.999Z
${YYYYMMDDTHMSZ_NOW}    %Y-%m-%dT%H:%M:%S.000Z
${YYYYMMDDTHMS_NOW}    %Y-%m-%dT%H:%M:%SZ
${DATE_MONGODB_NOW}    %Y, %m, %d, %H, %M, %S, %f
${DATE_LBL_NOW_TH}    - ตอนนี้
${DATE_LBL_NOW_EN}    -now
${DATE_TYPE_ADD}    add
${DATE_TYPE_SUBTRACT}    subtract
${TIME_STRING_HOURS}    hours
${TIME_STRING_MINUTES}    minutes
${TIME_STRING_SECONDS}    seconds
${RANGE_SEARCH}    15