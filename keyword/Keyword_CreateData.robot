*** Keywords ***
Signin
    [Arguments]    ${url}    ${username}    ${password}
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_SIGNIN}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_SIGNIN}    Accept=${HEADER_ACCEPT}  
    ${data}=    Evaluate    {"username": "${username}","password": "${password}"}   
	${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_SIGNIN}    ${headers}    ${data}
	#Log To Console    Response Signin : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${SINGNIN}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	#accessToken
	${accessToken}=    Get From Dictionary    ${res}     ${FIELD_ACCESSTOKEN}
	#Log To Console    ${accessToken}
	[return]    ${accessToken}

ValidateToken
    [Arguments]    ${url}    ${accessToken}
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_VALIDATETOKEN}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_VALIDATETOKEN}    Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
	
    ${data}=    Evaluate    {"AccessToken": "${accessToken}"}   
	${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_VALIDATETOKEN}    ${headers}    ${data}
	#Log To Console    Response ValidateToken : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${VALIDATETOKEN}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
Create Partner
    [Arguments]    ${url}    ${accessToken}
    #Generate Random number
    ${random_number}=    generate random string    6    [NUMBERS]
	#PartnerName
	${PartnerName}=    Set Variable    ${VALUE_PARTNERNAME}${random_number}
	#MerchantContact
	${MerchantContact}=    Set Variable    ${VALUE_MERCHANTCONTACT}
	#CPID
	${CPID}=    Set Variable    ${VALUE_CPID}
	
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEPARTNER}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATEPARTNER}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
				
    ${data}=    Evaluate    {"PartnerName": "${PartnerName}","PartnerType": ["Supplier","Customer"],"PartnerDetail": {"MerchantContact": "${MerchantContact}","CPID": "${CPID}"},"Property": {"RouteEngine": "false"}}   
    #Log To Console    ${data}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATEPARTNER}    ${headers}    ${data}
    Log To Console    Response Create Partner : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATEPARTNER}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_PartnerId
    ${PartnerInfo}=    Get From Dictionary    ${res}     ${FIELD_PARTNERINFO}   
    # Log To Console    ${PartnerInfo}	
	${GetResponse_PartnerId}=    Get From Dictionary    ${PartnerInfo}     ${FIELD_PARTNERID}    
	# Log To Console    ${GetResponse_PartnerId}	
	${GetResponse_CustomerId}=    Get From Dictionary    ${PartnerInfo}     ${FIELD_CUSTOMERID}
    ${PartnerType}=    Set Variable     ${PartnerInfo['PartnerType']}
	${setPartnerTypeArr}=    Set Variable    '${PartnerType}[0]', '${PartnerType}[1]' 
    ${Property}=    Set Variable     ${PartnerInfo['Property']}
	${RouteEngine}=    Set Variable    ${Property['RouteEngine']}
    #AccountName
    ${AccountName}=    Set Variable    ${VALUE_ACCOUNTNAME}${random_number}
    #Log To Console    ${AccountName}
    #ConfigGroupName
    ${ConfigGroupName}=    Set Variable    ${VALUE_CONFIGGROUPNAME}${random_number}
    #Log To Console    ${ConfigGroupName}
    [Return]    ${GetResponse_PartnerId}    ${AccountName}    ${ConfigGroupName}    ${PartnerName}    ${GetResponse_CustomerId}    ${setPartnerTypeArr}    ${RouteEngine}    ${MerchantContact}    ${CPID}   

Create Account
    [Arguments]    ${url}    ${accessToken}    ${PartnerId}    ${AccountName}
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATEACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}
    #Log To Console    ${headers}
    ${randomSensorApp}=    Evaluate    random.randint(100, 999)    random
    ${data}=    Evaluate    {"PartnerID": "${PartnerId}","AccountName": "${AccountName}${randomSensorApp}"}

    #Log To Console    ${data}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATEACCOUNT}    ${headers}    ${data}
	Log To Console    Response Create Account : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATEACCOUNT}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_AccountName
    ${PartnerInfo}=    Get From Dictionary    ${res}     ${FIELD_PARTNERINFO}   
    #Log To Console    ${PartnerInfo}	
	${AccountInfo}=    Get From Dictionary    ${PartnerInfo}     ${FIELD_ACCOUNTINFO}  
	#Log To Console    ${AccountInfo}	
	${GetResponse_AccountName}=    Get From Dictionary    ${AccountInfo}[0]     ${FIELD_ACCOUNTNAME}    
	#Log To Console    ${GetResponse_AccountName}
	#GetResponse_AccountId
	${GetResponse_AccountId}=        Get From Dictionary    ${AccountInfo}[0]     ${FIELD_ACCOUNTID}    
    #Log To Console    ${GetResponse_AccountId} 
	
	[return]    ${GetResponse_AccountId}     ${GetResponse_AccountName}    

Create Account Code
    [Arguments]    ${url}    ${accessToken}    ${PartnerId}    ${AccountName}
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATEACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}
    #Log To Console    ${headers}
    ${random_number}=    generate random string    6    [NUMBERS]
    #AccountCode
    ${AccountCode}=    Set Variable    ${VALUE_ACCOUNTCODE}${random_number}

    ${data}=    Evaluate    {"PartnerID": "${PartnerId}","AccountName": "${AccountName}${random_number}","AccountCode": "${AccountCode}"}

    #Log To Console    ${data}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATEACCOUNT}    ${headers}    ${data}
	Log To Console    Response Create Account : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATEACCOUNT}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_AccountName
    ${PartnerInfo}=    Get From Dictionary    ${res}     ${FIELD_PARTNERINFO}   
    #Log To Console    ${PartnerInfo}	
	${AccountInfo}=    Get From Dictionary    ${PartnerInfo}     ${FIELD_ACCOUNTINFO}  
	#Log To Console    ${AccountInfo}	
	${GetResponse_AccountName}=    Get From Dictionary    ${AccountInfo}[0]     ${FIELD_ACCOUNTNAME}    
	#Log To Console    ${GetResponse_AccountName}
	#GetResponse_AccountId
	${GetResponse_AccountId}=        Get From Dictionary    ${AccountInfo}[0]     ${FIELD_ACCOUNTID}    
    #Log To Console    ${GetResponse_AccountId} 
    #GetResponse_AccountCode
	${GetResponse_AccountCode}=        Get From Dictionary    ${AccountInfo}[0]     ${FIELD_ACCOUNTCODE}    
    #Log To Console    ${GetResponse_AccountCode} 
	
	[return]    ${GetResponse_AccountId}     ${GetResponse_AccountName}    ${GetResponse_AccountCode}    

Create Thing
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${AccountName}
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATETHING}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATETHING}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}    Accept=${HEADER_ACCEPT}
    #Log To Console    ${headers}
    #random_IM
    ${randomIM1}=    Evaluate    random.randint(10000000, 99999999)    random
    ${randomIM2}=    Evaluate    random.randint(1000000, 9999999)    random
    ${random_IM}=    Set Variable    ${randomIM1} ${randomIM2}
    #Log To Console    ${random_IM}
    #random_ICCID
    ${randomICCID1}=    Evaluate    random.randint(1000000, 9999999)    random
    ${randomICCID2}=    Evaluate    random.randint(100000, 999999)    random
    ${random_ICCID}=    Set Variable    ${randomICCID1} ${randomICCID2}
    #Log To Console    ${random_ICCID}
    #ThingName
    ${random_number}=    generate random string    6    [NUMBERS]
	${ThingName}=    Set Variable    ${VALUE_THINGNAME}${random_number}
    #Log To Console    ${ThingName} 

    ${data}=    Evaluate    {"ThingName": "${ThingName}","IMEI": "${random_IM}","IMSI": "${random_IM}","ICCID": "${random_ICCID}","RouteUrl": ${VALUE_ROUTEURL},"RouteInfo": {"MIMO_ID": ${VALUE_ROUTEINFO_MIMO_ID},"MIMO_SerialNo": ${VALUE_ROUTEINFO_MIMO_SERIALNO}},"RouteFlag": {"ThingName": ${VALUE_ROUTEFLAG_THINGNAME},"ThingToken": ${VALUE_ROUTEFLAG_THINGTOKEN},"IMEI": ${VALUE_ROUTEFLAG_IMEI},"ICCID": ${VALUE_ROUTEFLAG_ICCID},"RouteInfo": ${VALUE_ROUTEFLAG_ROUTEINFO}}}   
    #Log To Console    ${data}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATETHING}    ${headers}    ${data}
	#Log To Console    Response Create Thing : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATETHING}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_ThingID
    ${ThingInfo}=    Get From Dictionary    ${res}     ${FIELD_THINGINFO}   
    #Log To Console    ${ThingInfo}	
	${GetResponse_ThingID}=    Get From Dictionary    ${ThingInfo}     ${FIELD_THINGID}    
	#Log To Console    ${GetResponse_ThingID}
	${GetResponse_IMSI}=    Get From Dictionary    ${ThingInfo}     ${FIELD_IMSI}    
	#Log To Console    ${GetResponse_IMSI}
	${GetResponse_ThingToken}=    Get From Dictionary    ${ThingInfo}     ${FIELD_THINGTOKEN}  
	#Log To Console    ${GetResponse_ThingToken}
	
	[return]    ${GetResponse_ThingID}    ${GetResponse_IMSI}    ${GetResponse_ThingToken}
	
Create ThingStateInfo
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${ThingId}    ${type}    ${SensorKey}
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATETHINGSTATEINFO}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATETHINGSTATEINFO}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}    Accept=${HEADER_ACCEPT}
    #Log To Console    ${headers}
    #random_Sensor
    ${random_Sensor}=    Evaluate    random.randint(100, 999)    random
    ${SensorValue}=    Set Variable    SC.${random_Sensor}
    #Log To Console    ${random_Sensor}
    # ${setThingId}=    Set Variable    ["${ThingId}"]

    ${data}=    Evaluate    {"ThingId": ${ThingId},"Type": "${type}", "Sensor": {"${SensorKey}": "${SensorValue}"}}
    # Log To Console    ${data}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATETHINGSTATEINFO}    ${headers}    ${data}
	#Log To Console    Response Create ThingStateInfo : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATETHINGSTATEINFO}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	[return]    ${type}    ${SensorKey}    ${SensorValue}  

Create ControlThing
    [Arguments]    ${url}    ${accessToken}    ${ThingId}    ${AccountId}    ${SensorKey}    ${random_Sensor}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATECONTROLTHING}${current_timestamp}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}
	#Log To Console    ${headers}
	#{"${VALUE_SENSORKEY}": "${random_Sensor_App}"}  
	#random_Sensor_Report
	${random_Sensor_App}=    Evaluate    random.randint(100, 999)    random
	#Set Global Variable    ${randomSensorApp}    ${random_Sensor_App}
			 
    ${data}=    Evaluate    {"ThingId": "${ThingId}", "Sensors": {"${SensorKey}": "${random_Sensor_App}"}}   
    #Log To Console    Response Create ControlThing : ${res}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${CONTROLAPIS}    ${URL_CREATECONTROLTHING}    ${headers}    ${data}
	#Log To Console    ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATECONTROLTHING}    ${FIELD_OPERATIONSTATUS_LOWCASE}    ${FIELD_CODE_LOWCASE}    ${FIELD_DESCRIPTION_LOWCASE}
		
	[return]    ${random_Sensor_App}  
	
Create ConfigGroup
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${ThingId}
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATECONFIGGROUP}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATECONFIGGROUP}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}    Accept=${HEADER_ACCEPT}
    #Log To Console    ${headers}
    #"ConfigInfo": {"RefreshTime": "On","Max": "99"}
    #ConfigName
    ${random_number}=    generate random string    6    [NUMBERS]
	${ConfigGroupName}=    Set Variable    ${VALUE_CONFIGGROUPNAME}${random_number}
    # Log To Console    ConfigGroupName is : ${ConfigGroupName}	

    ${data}=    Evaluate    {"ConfigName": "${ConfigGroupName}","ThingId": ${ThingId}, "ConfigInfo": {"${VALUE_CONFIGINFO_KEY_REFRESHTIME}": "${VALUE_CONFIGINFO_KEY_REFRESHTIME_VALUE}","${VALUE_CONFIGINFO_KEY_MAX}": "${VALUE_CONFIGINFO_KEY_MAX_VALUE}"}}
    # Log To Console    ${data}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATECONFIGGROUP}    ${headers}    ${data}
	#Log To Console    Response Create ConfigGroup : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATECONFIGGROUP}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_ConfigGroupInfo
    ${ConfigGroupInfo}=    Get From Dictionary    ${res}     ${FIELD_CONFIGGROUPINFO}   
    #Log To Console    ${ConfigGroupInfo}	
	${GetResponse_ConfigGroupId}=    Get From Dictionary    ${ConfigGroupInfo}     ${FIELD_CONFIGGROUPID}    
    #Log To Console    GetResponse_ConfigGroupId${GetResponse_ConfigGroupId}	
	[return]    ${GetResponse_ConfigGroupId}    ${ConfigGroupName}

Create Group
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${GetResponse_ThingIDArr}    
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEGROUP}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATEGROUP}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}

	#ThingGroupName
    ${random_number}=    generate random string    6    [NUMBERS]
	${ThingGroupName}=    Set Variable    ${VALUE_THINGGROUPNAME}${random_number}
    #Log To Console    ${ThThingGroupNameingName} 

    ${data}=    Evaluate    {"ThingGroupName": "${ThingGroupName}", "ThingId": ${GetResponse_ThingIDArr}, "CustomDetails": { "QuasarContentType" : "${VALUE_QUASARCONTENTTYPE}","QuasarRefreshTime" : ${VALUE_QUASARREFRESHTIME} } }
    # Log To Console    ${data}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATEGROUP}    ${headers}    ${data}
	Log To Console    Response Create Group : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATEGROUP}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_GroupID
    ${GroupInfo}=    Get From Dictionary    ${res}     ${FIELD_GROUPINFO}     
    #Log To Console    ${GroupInfo}	
	${GetResponse_GroupID}=    Get From Dictionary    ${GroupInfo}     ${FIELD_GROUPID}    
	#Log To Console    ${GetResponse_GroupID}
	
	[return]    ${GetResponse_GroupID}    ${ThingGroupName}    ${GetResponse_ThingIDArr}

GeneratePullMessage
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${GetResponse_ThingIDArr}    ${SensorKey}    ${type}    
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_GENERATEPULLMESSAGE}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_GENERATEPULLMESSAGE}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}

	#PullMessageName
    ${random_number}=    generate random string    6    [NUMBERS]
	${PullMessageName}=    Set Variable    ${VALUE_PULLMESSAGENAME}${random_number}
    # Log To Console    PullMessageName is : ${PullMessageName}	

    # 2021-08-13T12:59:44.000Z
    ${Future_Date}=    Value Add date now    ${YYYYMMDDTHMSZ_NOW}    ${NUMBERFUTUREDATEPULLMESSAGE} 
    # Log To Console    Future_Date is : ${Future_Date}

    ${data}=    Evaluate    {"ThingId": "${GetResponse_ThingIDArr}[0]","PullMessageName": "${PullMessageName}","Sensors": ["${SensorKey}"],"Type": "${type}","ExpireDate": "${Future_Date}"}
    # Log To Console    ${data}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_GENERATEPULLMESSAGE}    ${headers}    ${data}
	Log To Console    Response GeneratePullMessage : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${GENERATEPULLMESSAGE}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_PullMessageId
    ${BackupDataInfo}=    Get From Dictionary    ${res}     ${FIELD_BACKUPDATAINFO}   
    #Log To Console    ${PullMessageId}	
	${GetResponse_PullMessageId}=    Get From Dictionary    ${BackupDataInfo}     ${FIELD_PULLMESSAGEID}    
	# Log To Console    ${GetResponse_PullMessageId}
	
	[return]    ${GetResponse_PullMessageId}    ${PullMessageName}    ${Future_Date}

Create Purchase
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${type}    ${CustomerId}    ${ChargingStatus}    ${PurchaseKey}    ${PurchaseValue}    ${PurchaseType}    ${PurchaseState}    ${ReserveDateTime}    ${ReserveVolume}    ${RemainingReserve}    
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEPURCHASE}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATEPURCHASE}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}

	#PurchaseName
    ${random_number}=    generate random string    6    [NUMBERS]
	${PurchaseName}=    Set Variable    ${VALUE_PURCHASENAME}${random_number}
    # Log To Console    PurchaseName is : ${PurchaseName}	

    ${dataValue}=    Set Variable If    '${type}'=='${TYPE_CREATEPURCHASE_PURCHASEINFO}'    {"CustomerId":"${CustomerId}","PurchaseInfo":{"PurchaseKey":"${PurchaseKey}","PurchaseValue":"${PurchaseValue}","PurchaseName":"${PurchaseName}","PurchaseType":"${PurchaseType}","PurchaseState":"${PurchaseState}"},"ChargingStatus":"${ChargingStatus}"}
    ...    '${type}'=='${TYPE_CREATEPURCHASE_RESERVEQUOTAINFO}'    {"CustomerId":"${CustomerId}","ChargingStatus":"${ChargingStatus}","ReserveQuotaInfo":{"ReserveDateTime":"${ReserveDateTime}","ReserveVolume":${ReserveVolume},"RemainingReserve":${RemainingReserve}}}
    ...    '${type}'=='${TYPE_CREATEPURCHASE_PURCHASEINFORESERVEQUOTAINFO}'    {"CustomerId":"${CustomerId}","PurchaseInfo":{"PurchaseKey":"${PurchaseKey}","PurchaseValue":"${PurchaseValue}","PurchaseName":"${PurchaseName}","PurchaseType":"${PurchaseType}","PurchaseState":"${PurchaseState}"},"ChargingStatus":"${ChargingStatus}","ReserveQuotaInfo":{"ReserveDateTime":"${ReserveDateTime}","ReserveVolume":${ReserveVolume},"RemainingReserve":${RemainingReserve}}}
    
    ${data}=    Evaluate    ${dataValue}
    # Log To Console    ${data}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATEPURCHASE}    ${headers}    ${data}
	Log To Console    Response Create Purchase : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATEPURCHASE}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
	
	#GetResponse_CustomerId
    ${PurchaseInfo}=    Get From Dictionary    ${res}     ${FIELD_PURCHASEINFO}   
    #Log To Console    ${PullMessageId}	
	${GetResponse_CustomerId}=    Get From Dictionary    ${PurchaseInfo}     ${FIELD_CUSTOMERID}    
	# Log To Console    ${GetResponse_CustomerId}

	[return]    ${GetResponse_CustomerId}    ${PurchaseName}

Import Thing
    [Arguments]    ${url}    ${accessToken}    ${data}

	#Ex. ${data}=    Evaluate    { "ConnectivityType": "${VALUE_CONNECTIVITYTYPE_SIM3G}", "ThingName": "${ThingName}", "ThingIdentifier": "${ThingIdentifier}", "ThingSecret": "${ThingSecret}", "IMEI": "${IMEI}" }
	# Log To Console    ${data}

    ${data_count}=    Get Length    ${data}
    # Log To Console    ${data_count}
	@{valArrData}=    Create List
	FOR    ${i}    IN RANGE    ${data_count}

        ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
        ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_IMPORTTHING}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_IMPORTTHING}  
        #Log To Console    ${headers}

        # #SupplierId SupplierName
        # ${random_number}=    generate random string    6    [NUMBERS]
        # ${SupplierId}=    Set Variable    ${VALUE_SUPPLIERID}${random_number}
        # #Log To Console    ${SupplierId}
        # ${SupplierName}=    Set Variable    ${VALUE_SUPPLIERNAME}${random_number}
        # #Log To Console    ${SupplierName}

        ${body}=    Evaluate    { "ConnectivityType": "${data[${i}]['ConnectivityType']}", "ThingName": "${data[${i}]['ThingName']}", "ThingIdentifier": "${data[${i}]['ThingIdentifier']}", "ThingSecret": "${data[${i}]['ThingSecret']}"}

        Append To List    ${valArrData}    ${body}        #Add data to array set at valArrData
		
    #Exit For Loop
	END
    
	# Log To Console    ${valArrData}
	${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${CENTRICAPIS}    ${URL_IMPORTTHING}    ${headers}    ${valArrData}
	Log To Console    Response Import Thing : ${res}
	
	${data_countRes}=    Get Length    ${res}
    # Log To Console    ${data_countRes}
	FOR    ${i}    IN RANGE    ${data_countRes} 
		#status StatusDespcription
    	${status}=    Get From Dictionary    ${res}[${i}]     ${FIELD_STATUS}
		# Log To Console    status${status}
		${StatusDespcription}=    Set Variable   ${res}[${i}][${FIELD_STATUSDESCRIPTION}]
		# Log To Console    StatusDespcription${StatusDespcription}
	    Run keyword And Continue On Failure    Response ResultCode Should Have Success    ${status}    ${StatusDespcription}    ${IMPORTTHING}
	#Exit For Loop
	END
	[return]    ${res}

Mapping IMEI
    [Arguments]    ${url}    ${accessToken}    ${data}

	#Ex. ${data}=    Evaluate    { "ConnectivityType": "${VALUE_CONNECTIVITYTYPE_SIM3G}", "ThingName": "${ThingName}", "ThingIdentifier": "${ThingIdentifier}", "ThingSecret": "${ThingSecret}", "IMEI": "${IMEI}" }
	# Log To Console    ${data}

    ${data_count}=    Get Length    ${data}
    # Log To Console    ${data_count}
	@{valArrData}=    Create List
	FOR    ${i}    IN RANGE    ${data_count}

        ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
        ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_MAPPINGIMEI}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_MAPPINGIMEI}  
        #Log To Console    ${headers}

        #SupplierId SupplierName
        # ${random_number}=    generate random string    6    [NUMBERS]
        # ${SupplierId}=    Set Variable    ${VALUE_SUPPLIERID}${random_number}
        #Log To Console    ${SupplierId}
        # ${SupplierName}=    Set Variable    ${VALUE_SUPPLIERNAME}${random_number}
        #Log To Console    ${SupplierName}

        ${body}=    Evaluate    { "ConnectivityType": "${data[${i}]['ConnectivityType']}", "ThingName": "${data[${i}]['ThingName']}", "ThingIdentifier": "${data[${i}]['ThingIdentifier']}", "ThingSecret": "${data[${i}]['ThingSecret']}", "IMEI": "${data[${i}]['IMEI']}"}

        Append To List    ${valArrData}    ${body}        #Add data to array set at valArrData
		
    #Exit For Loop
	END
    
	# Log To Console    ${valArrData}
	${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${CENTRICAPIS}    ${URL_MAPPINGIMEI}    ${headers}    ${valArrData}
	Log To Console    Response Mapping IMEI : ${res}
    
	${data_countRes}=    Get Length    ${res}
    # Log To Console    ${data_countRes}
	FOR    ${i}    IN RANGE    ${data_countRes} 
		#status StatusDespcription
    	${status}=    Get From Dictionary    ${res}[${i}]     ${FIELD_STATUS}
		# Log To Console    status${status}
		${StatusDespcription}=    Set Variable   ${res}[${i}][${FIELD_STATUSDESCRIPTION}]
		# Log To Console    StatusDespcription${StatusDespcription}
	    Run keyword And Continue On Failure    Response ResultCode Should Have Success    ${status}    ${StatusDespcription}    ${MAPPINGIMEI}
	#Exit For Loop
	END
	[return]    ${res}


Assign Things To Workers
    [Arguments]    ${url}    ${ServerIP}    ${ServerPort}    ${ServerDomain}    ${WorkerState}    
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEAWORKER}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATEAWORKER}
	#Log To Console    ${headers}
	
	#ThingName
    ${random_number}=    generate random string    6    [NUMBERS]
	${WorkerName}=    Set Variable    ${VALUE_WORKNAME}${random_number}
    #Log To Console    ${ThingName} 
	
    ${data}=    Evaluate    { "WorkerName": "${WorkerName}", "ServerProperties": { "ServerIP": "${ServerIP}", "ServerPort": "${ServerPort}", "ServerDomain": "${ServerDomain}" }, "WorkerState": "${WorkerState}" }  
    # Log To Console    ${data}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${CENTRICAPIS}    ${URL_CREATEAWORKER}    ${headers}    ${data}
	# Log To Console    ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATEAWORKER}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DEVELOPERMESSAGE}
	
	#GetResponse_ThingID
    ${WorkersInfo}=    Get From Dictionary    ${res}     ${FIELD_WORKERSINFO}   
    #Log To Console    ${WorkersInfo}	
	${GetResponse_WorkerID}=    Get From Dictionary    ${WorkersInfo}     ${FIELD_WORKERID}    
	#Log To Console    ${GetResponse_WorkerID}
	
	[return]    ${GetResponse_WorkerID}    ${WorkerName}    ${ServerIP}    ${ServerPort}    ${ServerDomain}    ${WorkerState}

Create A Whitelist
    [Arguments]    ${url}    ${accessToken}    ${data}    ${OwnerType}    ${OwnerId}    ${ThingIdentifierArr}
	
	#${OwnerType}    ${OwnerId}    ${ThingIdentifier}
    # [{"OwnerType": "NONE","OwnerId": "string","ThingIdentifier": ["string"]}]
    # {"OwnerType": "${OwnerType}","OwnerId": "${OwnerId}","ThingIdentifier": ${ThingIdentifier}}
    # ${data}=    Evaluate    [{"OwnerType": "${OwnerType}","OwnerId": "${OwnerId}","ThingIdentifier": ${ThingIdentifier}}]
    # Log To Console    ${data}

    ${data_count}=    Get Length    ${data}
    # Log To Console    ${data_count}
	@{valArr Data}=    Create List
	FOR    ${i}    IN RANGE    ${data_count}

        ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
        ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEAWHITELIST}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATEAWHITELIST}
        #Log To Console    ${headers}

        ${body}=    Evaluate    {"OwnerType": "${OwnerType}","OwnerId": "${OwnerId}","ThingIdentifier": ${ThingIdentifierArr}}

        Append To List    ${valArrData}    ${body}        #Add data to array set at valArrData
		
    #Exit For Loop
	END

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${CENTRICAPIS}    ${URL_CREATEAWHITELIST}    ${headers}    ${valArrData}
	Log To Console    Response Create A Whitelist : ${res}
    
    ${data_countRes}=    Get Length    ${res}
    # Log To Console    ${data_countRes}
	FOR    ${i}    IN RANGE    ${data_countRes} 
		#status StatusDespcription
    	${status}=    Get From Dictionary    ${res}[${i}]     ${FIELD_STATUS}
		# Log To Console    status${status}
		${StatusDespcription}=    Set Variable   ${res}[${i}][${FIELD_STATUSDESCRIPTION}]
		# Log To Console    StatusDespcription${StatusDespcription}
        Run keyword And Continue On Failure    Response ResultCode Should Have Success    ${status}    ${StatusDespcription}    ${CREATEAWHITELIST}
	#Exit For Loop
	END

	[return]    

Activate Things
    [Arguments]    ${url}    ${WorkerId}    ${ThingIdentifier}    ${ThingSecret}    ${imei}
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_ACTIVATETHINGS}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_ACTIVATETHINGS}
    #Log To Console    ${headers}

    ${data}=    Evaluate    [ { "ThingIdentifier": "${ThingIdentifier}", "ThingSecret": "${ThingSecret}", "IMEI": "${imei}" } ]
    #Log To Console    ${data}

	${replaceUrl}=    Replace String    ${URL_ACTIVATETHINGS_CENTRIC}    {WorkerId}    ${WorkerId}
	# Log To Console    ${replaceUrl}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${CENTRICAPIS}    ${replaceUrl}    ${headers}    ${data}
	# Log To Console    Response Activate Things : ${res}
	# Response ResultCode Should Have    ${res}    ${ACTIVATETHINGS_CENTRIC}    ${FIELD_OPERATIONSTATUS}    ${FIELD_STATUS}    ${FIELD_STATUSDESCRIPTION}
	${data_count}=    Get Length    ${res}
    # Log To Console    ${data_count}
    FOR    ${i}    IN RANGE    ${data_count}
        #GetResponse_ThingID
        ${status}=    Get From Dictionary    ${res}[${i}]    ${FIELD_STATUS}
        # Log To Console    ${status}
        ${StatusDespcription}=    Set Variable    ${res}[${i}][${FIELD_STATUSDESCRIPTION}]
        # Log To Console    ${StatusDespcription}
        Response ResultCode Should Have Success    ${status}    ${StatusDespcription}    ${ACTIVATETHINGS}
        #Exit For Loop
    END
    # [return]

Activate Thing Core
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${data}

	#Ex. ${data}=    Evaluate    { "ConnectivityType": "${VALUE_CONNECTIVITYTYPE_SIM3G}", "ThingName": "${ThingName}", "ThingIdentifier": "${ThingIdentifier}", "ThingSecret": "${ThingSecret}", "IMEI": "${IMEI}" }
	# Log To Console    ${data}
	# Log To Console    ${data[0]['ThingIdentifier']}
    ${data_count}=    Get Length    ${data}
    # Log To Console    ${data_count}
	@{valArrData}=    Create List
	FOR    ${i}    IN RANGE    ${data_count}

        ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
        ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_ACTIVATETHING_CORE}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_ACTIVATETHING_CORE}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}  
        #Log To Console    ${headers}

        ${body}=    Evaluate    { "ICCID": "${data[${i}]['ThingIdentifier']}", "IMSI": "${data[${i}]['ThingSecret']}", "IMEI": "${data[${i}]['IMEI']}"}

        Append To List    ${valArrData}    ${body}        #Add data to array set at valArrData
		
    #Exit For Loop
	END
    
	# Log To Console    ${valArrData}
	${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_ACTIVATETHING_CORE}    ${headers}    ${valArrData}
	Log To Console    Response Activate Thing : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${ACTIVATETHING_CORE}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
    
	${resActivateThing}=    Set Variable    ${res['${FIELD_ACTIVATETHING}']}
	${data_countRes}=    Get Length    ${resActivateThing}
    # Log To Console    ${data_countRes}
    @{GetResponse_ThingIDArr}=    Create List
	FOR    ${i}    IN RANGE    ${data_countRes} 
		#status StatusDespcription
    	${status}=    Get From Dictionary    ${resActivateThing}[${i}]     ${FIELD_STATUS}
		# Log To Console    status${status}
		Run keyword And Continue On Failure    Should Be Equal As Strings    ${status}    ${VALUE_STATUS_SUCCESS}

		#GetResponse_ThingIDArr
		${resThingId}=    Set Variable   ${resActivateThing}[${i}][${FIELD_THINGID}]
		Append To List    ${GetResponse_ThingIDArr}    ${resThingId}        #Add data to array set at valArrData
		# Log To Console    GetResponse_ThingIDArr${GetResponse_ThingIDArr}

	#Exit For Loop
	END
	[return]    ${GetResponse_ThingIDArr}    ${res}    

TransferThings
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${data}    ${AccountId2}

	#Ex. ${data}=    Evaluate    { "ConnectivityType": "${VALUE_CONNECTIVITYTYPE_SIM3G}", "ThingName": "${ThingName}", "ThingIdentifier": "${ThingIdentifier}", "ThingSecret": "${ThingSecret}", "IMEI": "${IMEI}" }
	# Log To Console    ${data}
	# Log To Console    ${data[0]['ThingIdentifier']}
    ${data_count}=    Get Length    ${data}
    # Log To Console    ${data_count}
	@{valArrData}=    Create List
	FOR    ${i}    IN RANGE    ${data_count}

        ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
        ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_TRANSFERTHINHS}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_TRANSFERTHINHS}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}    x-ais-TransferType=${HEADER_X_AIS_TRANSFERTYPE_ACCOUNTID}    x-ais-TransferValue=${AccountId2}  
        # Log To Console    Headers is : ${headers}
       
        ${body}=    Evaluate    { "ICCID": "${data[${i}]['ThingIdentifier']}", "IMSI": "${data[${i}]['ThingSecret']}", "IMEI": "${data[${i}]['IMEI']}"}

        Append To List    ${valArrData}    ${body}        #Add data to array set at valArrData
		
    #Exit For Loop
	END
    
	# Log To Console    ${valArrData}
	${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_TRANSFERTHINHS}    ${headers}    ${valArrData}
	Log To Console    Response Activate Thing : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${TRANSFERTHINHS}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
    
	${resActivateThing}=    Set Variable    ${res['${FIELD_ACTIVATETHING}']}
	${data_countRes}=    Get Length    ${resActivateThing}
    # Log To Console    ${data_countRes}
    @{GetResponse_ThingIDArr}=    Create List
	FOR    ${i}    IN RANGE    ${data_countRes} 
		#status StatusDespcription
    	${status}=    Get From Dictionary    ${resActivateThing}[${i}]     ${FIELD_STATUS}
		# Log To Console    status${status}
		Run keyword And Continue On Failure    Should Be Equal As Strings    ${status}    ${VALUE_STATUS_SUCCESS}

		#GetResponse_ThingIDArr
		${resThingId}=    Set Variable   ${resActivateThing}[${i}][${FIELD_THINGID}]
		Append To List    ${GetResponse_ThingIDArr}    ${resThingId}        #Add data to array set at valArrData
		# Log To Console    GetResponse_ThingIDArr${GetResponse_ThingIDArr}

	#Exit For Loop
	END
	[return]    ${GetResponse_ThingIDArr}    ${res}    

CreateSystemUser
    [Arguments]    ${url}    ${accessToken}    ${AccountId}   
    ${random_number}=    generate random string    6    [NUMBERS]
    ${AuthenInfo_Username}=    Set Variable    ${AUTHENINFO_USERNAME}${random_number}
    ${AuthenInfo_Password}=    Set Variable    ${AUTHENINFO_PASSWORD}
    ${UserRole}=    Set Variable    ${USERROLE_REQ} 
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary    Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATESYSTEMUSER}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATESYSTEMUSER}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}
    # Log To Console    headers:${headers}
    ${data}=    Evaluate    {"AccountId":["${AccountId}"],"AuthenInfo":{"Username":"${AuthenInfo_Username}","Password":"${AuthenInfo_Password}"},"UserRole":[${UserRole}]}
    # Log To Console    data Req :${data}

    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATESYSTEMUSER}    ${headers}    ${data}
	Log To Console    Response Create SystemUser : ${res}
	Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATESYSTEMUSER}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
    
    ${SystemUserInfo}=    Get From Dictionary    ${res}    ${FIELD_SYSTEMUSERINFO}
    ${SystemUserId}=    Set Variable    ${SystemUserInfo['SystemUserId']}
    ${AccountId}=    Set Variable    ${SystemUserInfo['AccountId'][0]}
    ${AuthenInfo}=    Set Variable    ${SystemUserInfo['AuthenInfo']}
    ${Username}=    Set Variable    ${AuthenInfo['Username']}
    
	[return]    ${SystemUserId}    ${Username}   ${AccountId}

Create Route
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${ThingArr}

    # Log To Console    TESTTTTTTTTTTT:${ThingArr}
    # ${getThingId}    Set Variable    ${ThingId}[0]    
    # Headers
    ${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
	${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_CREATEROUTE}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_CREATEROUTE}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}    Accept=${HEADER_ACCEPT}  
	Log To Console    Headers is : ${headers}
		
	#ThingName
    ${random_number}=    generate random string    6    [NUMBERS]
	${ThingGroupName}=    Set Variable    ${VALUE_THINGGROUPNAME}${random_number}
    ${RouteName}=    Set Variable    ${ROUTENAME}${random_number}    
    ${RouteStatus}=    Set Variable    ${ROUTESTATUS}
    ${RouteQueueStatus}=    Set Variable    ${ROUTEQUEUESTATUS}
    ${AuthenType}=    Set Variable    ${AUTHENTYPE}
    ${RouteType}=    Set Variable    ${ROUTETYPE}
    ${RouteUrl}=    Set Variable    ${ROUTEURL}
    ${PartialSensorofThing}=    Set Variable    ${PARTIALSENSOROFTHING}
    ${CustomHeaders_Partnerref}=    Set Variable    ${CUSTOMHEADERS_PARTNERREF}
    ${PickOutSensor}=    Set Variable    ${PICKOUTSENSOR}
    ${Routeflag_ThingName}=    Set Variable    ${ROUTEFLAG_THINGNAME}
    ${Routeflag_ThingToken}=    Set Variable    ${ROUTEFLAG_THINGTOKEN}
    ${Routeflag_IMEI}=    Set Variable    ${ROUTEFLAG_IMEI}
    ${Routeflag_ICCD}=    Set Variable    ${ROUTEFLAG_ICCID}
    ${Routeflag_RouteInfo}=    Set Variable    ${ROUTEFLAG_ROUTEINFO}

	#Body
    ${data}=    Evaluate    { "RouteName": "${RouteName}", "RouteStatus": "${RouteStatus}", "RouteQueueStatus": "${RouteQueueStatus}", "AuthenType": "${AuthenType}", "RouteType": "${RouteType}", "RouteUrl": "${RouteUrl}", "PartialSensorOfThing": "${PartialSensorofThing}", "CustomHeaders": { "PartnerRef":"${CustomHeaders_Partnerref}" }, "ThingId": ${ThingArr}, "PickOutSensor": ["${PickOutSensor}"], "RouteFlag": { "ThingName": "${Routeflag_ThingName}", "ThingToken": "${Routeflag_ThingToken}", "IMEI": "${Routeflag_IMEI}", "ICCID": "${Routeflag_ICCD}", "RouteInfo": "${Routeflag_RouteInfo}" } }
    Log To Console    data is : ${data}
    #Response
    ${res}=    Run keyword And Continue On Failure    Post Api Request    ${url}${PROVISIONINGAPIS}    ${URL_CREATEROUTE}    ${headers}    ${data}
	# Log To Console    Response is : ${res}
    Run keyword And Continue On Failure    Response ResultCode Should Have    ${res}    ${CREATEROUTE}    ${FIELD_OPERATIONSTATUS}    ${FIELD_CODE}    ${FIELD_DESCRIPTION}
    
    #GetResponse_RouteID
    ${RouteInfo}=    Get From Dictionary    ${res}     ${FIELD_ROUTEINFO}     
    #Log To Console    ${RouteInfo}	
	${GetResponse_RouteID}=    Get From Dictionary    ${RouteInfo}     ${FIELD_ROUTEID}    
	#Log To Console    ${GetResponse_GroupID}
    ${GetResponse_RouteName}=    Get From Dictionary    ${RouteInfo}     ${FIELD_ROUTENAME} 

    [return]    ${GetResponse_RouteID}    ${GetResponse_RouteName}   ${ThingArr}

Request CreateData for get IMSI
    #signin return accessToken
    ${accessToken}=    Signin    ${URL}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
    ${postCreateAccount}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    ${postCreateThing}=    Create Thing    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postCreateAccount}[1]
    ${postCreateThingStateInfo}=    Create ThingStateInfo    ${URL}    ${accessToken}    ${postCreateThing}[0]    ${postCreateAccount}[0]    ${VALUE_SENSORKEY}
    
    #accessToken,PartnerId,AccountId,ThingID,IMSI,ThingToken,Type,SensorKey,random_Sensor,AccountName
    [Return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateThing}[0]    ${postCreateThing}[1]    ${postCreateThing}[2]    ${postCreateThingStateInfo}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2]    ${postCreateAccount}[1]

Request CreateData for Signin Partner and Account
    [Arguments]    ${username}    ${password}
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
    ${postCreateAccount}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    
    #accessToken,PartnerId,AccountId,AccountName,PartnerName,CustomerId
    [Return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postCreatePartner}[3]    ${postCreatePartner}[4]

Request CreateData for Signin Partner Account ImportThing and MappingIMEI
    [Arguments]        ${username}    ${password}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=    Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	
	#accessToken,PartnerId,AccountId,AccountName
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]

Request CreateData for Signin Partner Account ImportThing MappingIMEI and Signin2
    [Arguments]        ${usernameAdmin}    ${passwordAdmin}    ${username}    ${password}    ${data}    ${AccountIdOtherRole}
	${accessTokenAdmin}=    Signin    ${URL}    ${usernameAdmin}    ${passwordAdmin}
	${postImportThing}=    Import Thing    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postMappingIMEI}=    Mapping IMEI    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}

	#accessTokenAdmin,accessToken2,AccountIdOtherRole
    [return]    ${accessTokenAdmin}    ${accessToken}    ${AccountIdOtherRole}

Request CreateData for Signin Partner Account ImportThing MappingIMEI and CreateAWhitelist
    [Arguments]        ${username}    ${password}    ${data}    ${OwnerType}    ${OwnerIdType}    ${ThingIdentifierArr}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=    Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}

    ${dataOwnerId}=    Set Variable If    '${OwnerIdType}'=='${TYPE_CUSTOMER}'    ${postCreatePartner}[4]
    ...    '${OwnerIdType}'=='${TYPE_TENANT}'    ${postCreatePartner}[0]
    ...    '${OwnerIdType}'=='${TYPE_ACCOUNT}'    ${postCreateAccount}[0]

    ${postCreateAWhitelist}=    Create A Whitelist    ${URL_CENTRIC}    ${accessToken}    ${data}    ${OwnerType}    ${dataOwnerId}    ${ThingIdentifierArr}
	
	#accessToken,PartnerId,AccountId,CustomerId,AccountName,ThingIdentifierArr,OwnerType,OwnerId
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreatePartner}[4]    ${postCreateAccount}[1]    ${ThingIdentifierArr}    ${OwnerType}    ${dataOwnerId}

Request CreateData for Signin Partner Account ImportThing MappingIMEI and ActivateThingCore
    [Arguments]        ${username}    ${password}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}

	#accessToken,PartnerId,AccountId,AccountName,ThingIdArr
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]

Request CreateData for Signin Partner Account ImportThing MappingIMEI and ActivateThingCore Signin2
    [Arguments]        ${usernameAdmin}    ${passwordAdmin}    ${username}    ${password}    ${data}    ${AccountIdOtherRole}
	${accessTokenAdmin}=    Signin    ${URL}    ${usernameAdmin}    ${passwordAdmin}
	${postImportThing}=    Import Thing    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postMappingIMEI}=    Mapping IMEI    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessTokenAdmin}    ${AccountIdOtherRole}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}

	#accessTokenAdmin,ThingIdArr,accessToken2,AccountIdOtherRole
    [return]    ${accessTokenAdmin}    ${postActivateThingCore}[0]    ${accessToken}    ${AccountIdOtherRole}

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore RemoveThingFromAccount and Account2
    [Arguments]        ${username}    ${password}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    
    ${thingId}=    Set Variable    ${postActivateThingCore}[0]
    ${data_count}=    Get Length    ${thingId}
	# Log To Console    data_count${data_count}  

	FOR    ${i}    IN RANGE    ${data_count}
        ${postRemoveThingFromAccount}=    Remove ThingFromAccount    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${thingId}[${i}]    
	END

    ${postCreateAccount2}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]

	#accessToken,PartnerId,AccountId,AccountName,ThingIdArr,AccountId2
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateAccount2}[0]

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore RemoveThingFromAccount and Account2 Signin2

    [Arguments]        ${usernameAdmin}    ${passwordAdmin}    ${username}    ${password}    ${data}    ${AccountIdOtherRole}
	${accessTokenAdmin}=    Signin    ${URL}    ${usernameAdmin}    ${passwordAdmin}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessTokenAdmin}
	${postCreateAccount}=	Create Account    ${URL}    ${accessTokenAdmin}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=    Import Thing    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postMappingIMEI}=    Mapping IMEI    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessTokenAdmin}    ${postCreateAccount}[0]    ${data}

    ${thingId}=    Set Variable    ${postActivateThingCore}[0]
    ${data_count}=    Get Length    ${thingId}
	# Log To Console    data_count${data_count}  

	FOR    ${i}    IN RANGE    ${data_count}
        ${postRemoveThingFromAccount}=    Remove ThingFromAccount    ${URL}    ${accessTokenAdmin}    ${postCreateAccount}[0]    ${thingId}[${i}]    
	END

    ${postCreateAccount2}=	Create Account    ${URL}    ${accessTokenAdmin}    ${postCreatePartner}[0]    ${postCreatePartner}[1]

	${accessToken}=    Signin    ${URL}    ${username}    ${password}

	#accessTokenAdmin,ThingIdArr,accessToken2,AccountIdOtherRole,AccountId,AccountId2,PartnerId
    [return]    ${accessTokenAdmin}    ${postActivateThingCore}[0]    ${accessToken}    ${AccountIdOtherRole}    ${postCreateAccount}[0]    ${postCreateAccount2}[0]    ${postCreatePartner}[0]

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore RemoveThingFromAccount Account2 and TransferThings
    [Arguments]        ${username}    ${password}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    
    ${thingId}=    Set Variable    ${postActivateThingCore}[0]
    ${data_count}=    Get Length    ${thingId}
	# Log To Console    data_count${data_count}  

	FOR    ${i}    IN RANGE    ${data_count}
        ${postRemoveThingFromAccount}=    Remove ThingFromAccount    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${thingId}[${i}]    
	END
    ${postCreateAccount2}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    ${postTransferThings}=    TransferThings    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}    ${postCreateAccount2}[0]
    
	#accessToken,PartnerId,AccountId,AccountName,ThingIdArr,AccountId2,ThingIdArrTransferThings
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateAccount2}[0]    ${postTransferThings}[0]

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore RemoveThingFromAccount Account2 and CreateAWhitelist
    [Arguments]        ${username}    ${password}    ${data}    ${OwnerType}    ${OwnerIdType}    ${ThingIdentifierArr}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    
    ${thingId}=    Set Variable    ${postActivateThingCore}[0]
    ${data_count}=    Get Length    ${thingId}
	# Log To Console    data_count${data_count}  

	FOR    ${i}    IN RANGE    ${data_count}
        ${postRemoveThingFromAccount}=    Remove ThingFromAccount    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${thingId}[${i}]    
	END

    ${postCreateAccount2}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    
    ${dataOwnerId}=    Set Variable If    '${OwnerIdType}'=='${TYPE_CUSTOMER}'    ${postCreatePartner}[4]
    ...    '${OwnerIdType}'=='${TYPE_TENANT}'    ${postCreatePartner}[0]
    ...    '${OwnerIdType}'=='${TYPE_ACCOUNT}'    ${postCreateAccount}[0]
    
    ${postCreateAWhitelist}=    Create A Whitelist    ${URL_CENTRIC}    ${accessToken}    ${data}    ${OwnerType}    ${dataOwnerId}    ${ThingIdentifierArr}
	#accessToken,PartnerId,AccountId,AccountName,ThingIdArr,AccountId2,ThingIdentifierArr,OwnerType,OwnerId
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateAccount2}[0]    ${ThingIdentifierArr}    ${OwnerType}    ${dataOwnerId}

Request CreateData for Signin Partner AccountCode ImportThing MappingIMEI ActivateThingCore and RemoveThingFromAccount
    [Arguments]        ${username}    ${password}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account Code    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    
    ${thingId}=    Set Variable    ${postActivateThingCore}[0]
    ${data_count}=    Get Length    ${thingId}
	# Log To Console    data_count${data_count}  

	FOR    ${i}    IN RANGE    ${data_count}
        ${postRemoveThingFromAccount}=    Remove ThingFromAccount    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${thingId}[${i}]    
	END

	#accessToken,PartnerId,AccountId,AccountName,ThingIdArr,AccountCode
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateAccount}[2]

Request CreateData for Signin Partner AccountCode ImportThing MappingIMEI ActivateThingCore and RemoveThingFromAccount Signin2
    [Arguments]        ${usernameAdmin}    ${passwordAdmin}    ${username}    ${password}    ${data}    ${AccountIdOtherRole}
	${accessTokenAdmin}=    Signin    ${URL}    ${usernameAdmin}    ${passwordAdmin}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessTokenAdmin}
	${postCreateAccount}=	Create Account Code    ${URL}    ${accessTokenAdmin}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=    Import Thing    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postMappingIMEI}=    Mapping IMEI    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessTokenAdmin}    ${postCreateAccount}[0]    ${data}

    ${thingId}=    Set Variable    ${postActivateThingCore}[0]
    ${data_count}=    Get Length    ${thingId}
	# Log To Console    data_count${data_count}  

	FOR    ${i}    IN RANGE    ${data_count}
        ${postRemoveThingFromAccount}=    Remove ThingFromAccount    ${URL}    ${accessTokenAdmin}    ${postCreateAccount}[0]    ${thingId}[${i}]    
	END

	${accessToken}=    Signin    ${URL}    ${username}    ${password}

	#accessTokenAdmin,ThingIdArr,accessToken2,AccountIdOtherRole,AccountId,PartnerId,AccountCode
    [return]    ${accessTokenAdmin}    ${postActivateThingCore}[0]    ${accessToken}    ${AccountIdOtherRole}    ${postCreateAccount}[0]   ${postCreatePartner}[0]    ${postCreateAccount}[2]

Request CreateData for Signin Partner AccountCode ImportThing MappingIMEI ActivateThingCore RemoveThingFromAccount and CreateAWhitelist
    [Arguments]        ${username}    ${password}    ${data}    ${OwnerType}    ${OwnerIdType}    ${ThingIdentifierArr}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account Code    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    
    ${thingId}=    Set Variable    ${postActivateThingCore}[0]
    ${data_count}=    Get Length    ${thingId}
	# Log To Console    data_count${data_count}  

	FOR    ${i}    IN RANGE    ${data_count}
        ${postRemoveThingFromAccount}=    Remove ThingFromAccount    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${thingId}[${i}]    
	END

    ${dataOwnerId}=    Set Variable If    '${OwnerIdType}'=='${TYPE_CUSTOMER}'    ${postCreatePartner}[4]
    ...    '${OwnerIdType}'=='${TYPE_TENANT}'    ${postCreatePartner}[0]
    ...    '${OwnerIdType}'=='${TYPE_ACCOUNT}'    ${postCreateAccount}[0]
    
    ${postCreateAWhitelist}=    Create A Whitelist    ${URL_CENTRIC}    ${accessToken}    ${data}    ${OwnerType}    ${dataOwnerId}    ${ThingIdentifierArr}

	#accessToken,PartnerId,AccountId,AccountName,ThingIdArr,AccountCode,ThingIdentifierArr,OwnerType,OwnerId
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateAccount}[2]    ${ThingIdentifierArr}    ${OwnerType}    ${dataOwnerId}


Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore and CreateThingStateInfo
    [Arguments]        ${username}    ${password}    ${data}    ${type}    ${SensorKey}    
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=    Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    ${postCreateThingStateInfo}=    Create ThingStateInfo    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]    ${type}    ${SensorKey}

	#accessToken,PartnerId,AccountId,AccountName,ThingIdArr,type,SensorKey,random_Sensor
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateThingStateInfo}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2]  

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore and CreateThingStateInfo and CreateGroup
    [Arguments]        ${username}    ${password}    ${data}    ${type}    ${SensorKey}  
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=    Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    ${postCreateThingStateInfo}=    Create ThingStateInfo    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]    ${type}    ${SensorKey}
    ${postCreateGroup}=	   Create Group    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]
    
	#accessTokenAdmin,ThingIdArr,accessToken2,AccountIdOtherRole,type,SensorKey,random_Sensor
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateThingStateInfo}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2]   ${postCreateGroup}[0]    ${postCreateGroup}[1] 


Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore and CreateThingStateInfo and RemoveThing
    [Arguments]        ${username}    ${password}    ${data}    ${type}    ${SensorKey}    
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=    Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    ${postCreateThingStateInfo}=    Create ThingStateInfo    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]    ${type}    ${SensorKey}
	${removeThingCore}=    Remove Thing    ${URL}    ${accessToken}    ${postActivateThingCore}[0][0]    ${postCreateAccount}[0]

	#accessToken,PartnerId,AccountId,AccountName,ThingIdArr,type,SensorKey,random_Sensor
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateThingStateInfo}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2]  

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore and CreateThingStateInfo and CreateGroup and Remove Group
    [Arguments]        ${username}    ${password}    ${data}    ${type}    ${SensorKey}  
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=    Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    ${postCreateThingStateInfo}=    Create ThingStateInfo    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]    ${type}    ${SensorKey}
    ${postCreateGroup}=	   Create Group    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]
	${removeGroup}=    Remove Group    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postCreateGroup}[0]
	#accessTokenAdmin,ThingIdArr,accessToken2,AccountIdOtherRole,type,SensorKey,random_Sensor
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateThingStateInfo}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2]   ${postCreateGroup}[0]    ${postCreateGroup}[1] 



Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore Signin2 and CreateThingStateInfo
    [Arguments]        ${usernameAdmin}    ${passwordAdmin}    ${username}    ${password}    ${data}    ${AccountIdOtherRole}    ${type}    ${SensorKey}  
	${accessTokenAdmin}=    Signin    ${URL}    ${usernameAdmin}    ${passwordAdmin}
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postActivateThingCore}=	   Activate Thing Core    ${URL}    ${accessTokenAdmin}    ${AccountIdOtherRole}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreateThingStateInfo}=    Create ThingStateInfo    ${URL}    ${accessToken}    ${AccountIdOtherRole}    ${postActivateThingCore}[0]    ${type}    ${SensorKey}

	#accessTokenAdmin,ThingIdArr,accessToken2,AccountIdOtherRole,type,SensorKey,random_Sensor
    [return]    ${accessTokenAdmin}    ${postActivateThingCore}[0]    ${accessToken}    ${AccountIdOtherRole}    ${postCreateThingStateInfo}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2]  




Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore CreateThingStateInfo and GeneratePullMessage
    [Arguments]        ${username}    ${password}    ${data}    ${type}    ${SensorKey}    ${typePullMessage}    
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=    Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    ${postCreateThingStateInfo}=    Create ThingStateInfo    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]    ${type}    ${SensorKey}
    ${postGeneratePullMessage}=    GeneratePullMessage    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]    ${SensorKey}    ${typePullMessage}  

	#accessToken,PartnerId,AccountId,AccountName,ThingIdArr,type,SensorKey,random_Sensor,PullMessageId,PullMessageName,ExpireDate
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateThingStateInfo}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2]    ${postGeneratePullMessage}[0]    ${postGeneratePullMessage}[1]    ${postGeneratePullMessage}[2]    

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore CreateThingStateInfo GeneratePullMessage and Signin2
    [Arguments]        ${usernameAdmin}    ${passwordAdmin}    ${username}    ${password}    ${data}    ${AccountIdOtherRole}    ${type}    ${SensorKey}    ${typePullMessage}      
	${accessTokenAdmin}=    Signin    ${URL}    ${usernameAdmin}    ${passwordAdmin}
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postActivateThingCore}=    Activate Thing Core    ${URL}    ${accessTokenAdmin}    ${AccountIdOtherRole}    ${data}
    ${postCreateThingStateInfo}=    Create ThingStateInfo    ${URL}    ${accessTokenAdmin}    ${AccountIdOtherRole}    ${postActivateThingCore}[0]    ${type}    ${SensorKey}
    ${postGeneratePullMessage}=    GeneratePullMessage    ${URL}    ${accessTokenAdmin}    ${AccountIdOtherRole}    ${postActivateThingCore}[0]    ${SensorKey}    ${typePullMessage}  
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
    
	#accessTokenAdmin,ThingIdArr,accessToken2,AccountIdOtherRole,type,SensorKey,random_Sensor,PullMessageId,PullMessageName,ExpireDate
    [return]    ${accessTokenAdmin}    ${postActivateThingCore}[0]    ${accessToken}    ${AccountIdOtherRole}    ${postCreateThingStateInfo}[0]    ${postCreateThingStateInfo}[1]    ${postCreateThingStateInfo}[2]    ${postGeneratePullMessage}[0]    ${postGeneratePullMessage}[1]    ${postGeneratePullMessage}[2]      

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore and CreateGroup
    [Arguments]        ${username}    ${password}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=	   Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    ${postCreateGroup}=	   Create Group    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]

	#accessToken,PartnerId,AccountId,AccountName,ThingIdArr,GroupId,GroupName
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateGroup}[0]    ${postCreateGroup}[1]  

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore Signin2 and CreateGroup
    [Arguments]        ${usernameAdmin}    ${passwordAdmin}    ${username}    ${password}    ${data}    ${AccountIdOtherRole}
	${accessTokenAdmin}=    Signin    ${URL}    ${usernameAdmin}    ${passwordAdmin}
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postActivateThingCore}=	   Activate Thing Core    ${URL}    ${accessTokenAdmin}    ${AccountIdOtherRole}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreateGroup}=	   Create Group    ${URL}    ${accessToken}    ${AccountIdOtherRole}    ${postActivateThingCore}[0]

	#accessTokenAdmin,ThingIdArr,accessToken2,AccountIdOtherRole,GroupId,GroupName
    [return]    ${accessTokenAdmin}    ${postActivateThingCore}[0]    ${accessToken}    ${AccountIdOtherRole}    ${postCreateGroup}[0]    ${postCreateGroup}[1] 

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore and CreateConfigGroup
    [Arguments]        ${username}    ${password}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=	   Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    ${postCreateConfigGroup}=	   Create ConfigGroup    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]

	#accessToken,PartnerId,AccountId,AccountName,ThingIdArr,ConfigGroupId,ConfigGroupName
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateConfigGroup}[0]    ${postCreateConfigGroup}[1]  

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore Signin2 and CreateConfigGroup
    [Arguments]        ${usernameAdmin}    ${passwordAdmin}    ${username}    ${password}    ${data}    ${AccountIdOtherRole}
	${accessTokenAdmin}=    Signin    ${URL}    ${usernameAdmin}    ${passwordAdmin}
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postActivateThingCore}=	   Activate Thing Core    ${URL}    ${accessTokenAdmin}    ${AccountIdOtherRole}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreateConfigGroup}=	   Create ConfigGroup    ${URL}    ${accessToken}    ${AccountIdOtherRole}    ${postActivateThingCore}[0]

	#accessTokenAdmin,ThingIdArr,accessToken2,AccountIdOtherRole,ConfigGroupId,ConfigGroupName
    [return]    ${accessTokenAdmin}    ${postActivateThingCore}[0]    ${accessToken}    ${AccountIdOtherRole}    ${postCreateConfigGroup}[0]    ${postCreateConfigGroup}[1] 

Request CreateData for Signin Partner Account and CreatePurchase
    [Arguments]    ${username}    ${password}    ${type}    ${ChargingStatus}    ${PurchaseKey}    ${PurchaseValue}    ${PurchaseType}    ${PurchaseState}    ${ReserveDateTime}    ${ReserveVolume}    ${RemainingReserve}    
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
    ${postCreateAccount}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    ${postCreatePurchase}=    Create Purchase    ${URL}    ${accessToken}    ${postCreateAccount}[1]    ${type}    ${postCreatePartner}[4]    ${ChargingStatus}    ${PurchaseKey}    ${PurchaseValue}    ${PurchaseType}    ${PurchaseState}    ${ReserveDateTime}    ${ReserveVolume}    ${RemainingReserve}    

    #accessToken,PartnerId,AccountId,AccountName,PartnerName,CustomerId,PurchaseName
    [Return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePurchase}[1]

Request CreateData for Signin Partner Account CreatePurchase and Signin2
    [Arguments]        ${usernameAdmin}    ${passwordAdmin}    ${username}    ${password}    ${type}    ${ChargingStatus}    ${PurchaseKey}    ${PurchaseValue}    ${PurchaseType}    ${PurchaseState}    ${ReserveDateTime}    ${ReserveVolume}    ${RemainingReserve}    
	${accessTokenAdmin}=    Signin    ${URL}    ${usernameAdmin}    ${passwordAdmin}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessTokenAdmin}
	${postCreateAccount}=	Create Account    ${URL}    ${accessTokenAdmin}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postCreatePurchase}=    Create Purchase    ${URL}    ${accessTokenAdmin}    ${postCreateAccount}[1]    ${type}    ${postCreatePartner}[4]    ${ChargingStatus}    ${PurchaseKey}    ${PurchaseValue}    ${PurchaseType}    ${PurchaseState}    ${ReserveDateTime}    ${ReserveVolume}    ${RemainingReserve}    
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    
	#accessTokenAdmin,PartnerId,AccountId,AccountName,PartnerName,CustomerId,PurchaseName,accessToken2,AccountIdOtherRole
    [return]    ${accessTokenAdmin}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePurchase}[1]    ${accessToken}    ${VALUE_ACCOUNTID_OTHERROLE}    
    
Request CreateData for Signin and Partner 
    [Arguments]    ${username}    ${password}    
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}  
    [Return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]    ${postCreatePartner}[2]   ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePartner}[5]    ${postCreatePartner}[6]    ${postCreatePartner}[7]    ${postCreatePartner}[8]        

Request CreateData for Signin2 and Partner 
    [Arguments]    ${username}    ${password}    ${usernameOtherRole}    ${passwordOtherRole}
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken} 
    ${accessTokenOtherRole}=    Signin    ${URL}    ${usernameOtherRole}    ${passwordOtherRole}  
    [Return]    ${accessTokenOtherRole}    ${postCreatePartner}[0]    ${postCreatePartner}[1]    ${postCreatePartner}[2]   ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePartner}[5]    ${postCreatePartner}[6]    ${postCreatePartner}[7]    ${postCreatePartner}[8]    ${accessToken}     

Request CreateData for Signin CreatePartner CreateAccount 
    [Arguments]    ${username}    ${password}    
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken} 
    ${postCreateAccount}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    [Return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]    ${postCreatePartner}[2]   ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePartner}[5]    ${postCreatePartner}[6]    ${postCreatePartner}[7]    ${postCreatePartner}[8]    ${postCreateAccount}[0]    ${postCreateAccount}[1]        


Request CreateData for Signin2 CreatePartner CreateAccount 
    [Arguments]    ${username}    ${password}    ${usernameOtherRole}    ${passwordOtherRole}    
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}   
    ${accessTokenOtherRole}=    Signin    ${URL}    ${usernameOtherRole}    ${passwordOtherRole}
    ${postCreateAccount}=    Create Account    ${URL}    ${accessTokenOtherRole}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    [Return]    ${accessTokenOtherRole}    ${postCreatePartner}[0]    ${postCreatePartner}[1]    ${postCreatePartner}[2]   ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePartner}[5]    ${postCreatePartner}[6]    ${postCreatePartner}[7]    ${postCreatePartner}[8]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${accessToken}     

Request CreateData for Step Signin CreatePartner CreateAccount Sigin 
    [Arguments]    ${username}    ${password}    ${usernameOtherRole}    ${passwordOtherRole}    
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}   
    ${postCreateAccount}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    ${accessTokenOtherRole}=    Signin    ${URL}    ${usernameOtherRole}    ${passwordOtherRole}
    [Return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]    ${postCreatePartner}[2]   ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePartner}[5]    ${postCreatePartner}[6]    ${postCreatePartner}[7]    ${postCreatePartner}[8]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${accessTokenOtherRole}        
   
Request CreateData for Step Signin CreatePartner CreateAccount1 CreateAccount2  
    [Arguments]    ${username}    ${password}        
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}   
    ${postCreateAccount1}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    ${postCreateAccount2}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    [Return]    ${postCreatePartner}[0]    ${postCreatePartner}[1]    ${postCreatePartner}[2]   ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePartner}[5]    ${postCreatePartner}[6]    ${postCreatePartner}[7]    ${postCreatePartner}[8]    ${postCreateAccount1}[0]    ${postCreateAccount1}[1]    ${postCreateAccount2}[0]    ${postCreateAccount2}[1]    ${accessToken}        
   
Request CreateData for Step Signin CreatePartner Signin CreateAccount1 CreateAccount2  
    [Arguments]    ${username}    ${password}    ${usernameOtherRole}    ${passwordOtherRole}        
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}  
    ${accessTokenOtherRole}=    Signin    ${URL}    ${usernameOtherRole}    ${passwordOtherRole} 
    ${postCreateAccount1}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    ${postCreateAccount2}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    [Return]    ${postCreatePartner}[0]    ${postCreatePartner}[1]    ${postCreatePartner}[2]   ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePartner}[5]    ${postCreatePartner}[6]    ${postCreatePartner}[7]    ${postCreatePartner}[8]    ${postCreateAccount1}[0]    ${postCreateAccount1}[1]    ${postCreateAccount2}[0]    ${postCreateAccount2}[1]    ${accessToken}    ${accessTokenOtherRole}        
   
Request CreateData for Step Signin CreatePartner CreateAccount1 CreateAccount2 Signin  
    [Arguments]    ${username}    ${password}    ${usernameOtherRole}    ${passwordOtherRole}        
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}  
    ${postCreateAccount1}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    ${postCreateAccount2}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    ${accessTokenOtherRole}=    Signin    ${URL}    ${usernameOtherRole}    ${passwordOtherRole} 
    [Return]    ${postCreatePartner}[0]    ${postCreatePartner}[1]    ${postCreatePartner}[2]   ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePartner}[5]    ${postCreatePartner}[6]    ${postCreatePartner}[7]    ${postCreatePartner}[8]    ${postCreateAccount1}[0]    ${postCreateAccount1}[1]    ${postCreateAccount2}[0]    ${postCreateAccount2}[1]    ${accessToken}    ${accessTokenOtherRole}        
   
Request CreateData for Step Signin CreatePartner CreateAccount CreateThing
    [Arguments]    ${username}    ${password}
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}  
    ${postCreateAccount}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    ${postCreateThing}=    Create Thing    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postCreateAccount}[1]

    [Return]    ${postCreatePartner}[0]    ${postCreatePartner}[1]    ${postCreatePartner}[2]   ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePartner}[5]    ${postCreatePartner}[6]    ${postCreatePartner}[7]    ${postCreatePartner}[8]    ${postCreateAccount}[0]    ${postCreateAccount}[1]     ${postCreateThing}[0]     ${postCreateThing}[1]     ${postCreateThing}[2]    ${accessToken}        

Request CreateData for Step Signin CreatePartner CreateAccount CreateSystemUser 
    [Arguments]    ${username}    ${password}    
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken} 
    ${postCreateAccount}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    ${postCreateSystemUser}=    CreateSystemUser    ${URL}    ${accessToken}    ${postCreateAccount}[0]    
 
    [Return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]    ${postCreatePartner}[2]   ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePartner}[5]    ${postCreatePartner}[6]    ${postCreatePartner}[7]    ${postCreatePartner}[8]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postCreateSystemUser}[0]    ${postCreateSystemUser}[1]        

Request CreateData for Step Signin CreatePartner CreateAccount CreateSystemUser SiginOtherRole 
    [Arguments]    ${username}    ${password}    ${usernameOtherRole}    ${passwordOtherRole}    
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken} 
    ${postCreateAccount}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    ${postCreateSystemUser}=    CreateSystemUser    ${URL}    ${accessToken}    ${postCreateAccount}[0]     
    ${accessTokenOtherRole}=    Signin    ${URL}    ${usernameOtherRole}    ${passwordOtherRole}
    [Return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]    ${postCreatePartner}[2]   ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePartner}[5]    ${postCreatePartner}[6]    ${postCreatePartner}[7]    ${postCreatePartner}[8]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postCreateSystemUser}[0]    ${postCreateSystemUser}[1]    ${accessTokenOtherRole}        

Request CreateData for Step Signin CreatePartner CreateAccount CreateSystemUser SiginOtherRole for ResetPassword
    [Arguments]    ${username}    ${password}    ${usernameOtherRole}    ${passwordOtherRole}    ${AccountIdOtherRole}    
    ${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken} 
    ${postCreateAccount}=    Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
    ${postCreateSystemUser}=    CreateSystemUser    ${URL}    ${accessToken}    ${AccountIdOtherRole}     
    ${accessTokenOtherRole}=    Signin    ${URL}    ${usernameOtherRole}    ${passwordOtherRole}
    [Return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]    ${postCreatePartner}[2]   ${postCreatePartner}[3]    ${postCreatePartner}[4]    ${postCreatePartner}[5]    ${postCreatePartner}[6]    ${postCreatePartner}[7]    ${postCreatePartner}[8]    ${postCreateAccount}[1]    ${postCreateSystemUser}[0]    ${postCreateSystemUser}[1]    ${postCreateSystemUser}[2]    ${accessTokenOtherRole}        

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore
    [Arguments]        ${username}    ${password}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=	   Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    ${postCreateGroup}=	   Create Group    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]

	#accessToken,PartnerId,AccountId,AccountName,ThingIdArr,GroupId,GroupName
    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore and CreateRoute
    [Arguments]        ${username}    ${password}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=	   Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    ${postCreateRoute}=	   Create Route    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]

    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateRoute}[0]    ${postCreateRoute}[1]  
 
Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore Signin2 and CreateRoute
    [Arguments]        ${usernameAdmin}    ${passwordAdmin}    ${username}    ${password}    ${data}    ${AccountIdOtherRole}
	${accessTokenAdmin}=    Signin    ${URL}    ${usernameAdmin}    ${passwordAdmin}
	# ${postCreatePartner}=    Create Partner    ${URL}    ${accessTokenAdmin}
	# ${postCreateAccount}=	Create Account    ${URL}    ${accessTokenAdmin}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessTokenAdmin}    ${data}
	${postActivateThingCore}=	   Activate Thing Core    ${URL}    ${accessTokenAdmin}    ${AccountIdOtherRole}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
    ${postCreateRoute}=	   Create Route    ${URL}    ${accessToken}    ${AccountIdOtherRole}    ${postActivateThingCore}[0]
	#accessTokenAdmin,ThingIdArr,accessToken2,AccountIdOtherRole,GroupId,GroupName
    [return]    ${accessTokenAdmin}    ${postActivateThingCore}[0]    ${accessToken}    ${AccountIdOtherRole}    ${postCreateRoute}[0]    ${postCreateRoute}[1] 

Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore and CreateRoute1 CreateRoute2 
    [Arguments]        ${username}    ${password}    ${data}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=	   Activate Thing Core    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${data}
    ${postCreateRoute1}=	   Create Route    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]
    ${postCreateRoute2}=	   Create Route    ${URL}    ${accessToken}    ${postCreateAccount}[0]    ${postActivateThingCore}[0]

    [return]    ${accessToken}    ${postCreatePartner}[0]    ${postCreateAccount}[0]    ${postCreateAccount}[1]    ${postActivateThingCore}[0]    ${postCreateRoute2}[0]    ${postCreateRoute1}[1]  
 
Request CreateData for Signin Partner Account ImportThing MappingIMEI ActivateThingCore and CreateRoute and AccountIdOtherRole
    [Arguments]        ${username}    ${password}    ${data}    ${AccountIdOtherRole}
	${accessToken}=    Signin    ${URL}    ${username}    ${password}
	# ${postCreatePartner}=    Create Partner    ${URL}    ${accessToken}
	# ${postCreateAccount}=	Create Account    ${URL}    ${accessToken}    ${postCreatePartner}[0]    ${postCreatePartner}[1]
	${postImportThing}=	   Import Thing    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postMappingIMEI}=	   Mapping IMEI    ${URL_CENTRIC}    ${accessToken}    ${data}
	${postActivateThingCore}=	   Activate Thing Core    ${URL}    ${accessToken}    ${AccountIdOtherRole}    ${data}
    # ${postCreateRoute}=	   Create Route    ${URL}    ${accessToken}    ${AccountIdOtherRole}    ${postActivateThingCore}[0]
    
    [return]    ${accessToken}    ${postActivateThingCore}[0]  
