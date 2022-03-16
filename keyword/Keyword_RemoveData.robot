*** Keywords ***
Remove Partner 
    [Arguments]    ${url}    ${accessToken}    ${PartnerId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVEPARTNER}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVEPARTNER}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  		
    ${data}=    Evaluate    {"PartnerId": "${PartnerId}"}   
    ${res}=    Delete Api Request    ${url}${PROVISIONINGAPIS}    ${URL_REMOVEPARTNER}    ${headers}    ${data}
	Log To Console    RemovePartner Response : ${res}

Remove Account
    [Arguments]    ${url}    ${accessToken}    ${PartnerId}    ${AccountId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVEACCOUNT}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVEACCOUNT}    x-ais-AccessToken=Bearer ${accessToken}    Accept=${HEADER_ACCEPT}  		
    ${data}=    Evaluate    {"PartnerID": "${PartnerId}","AccountId": "${AccountId}"}   
    ${res}=    Delete Api Request    ${url}${PROVISIONINGAPIS}    ${URL_REMOVEACCOUNT}    ${headers}    ${data}
	Log To Console    RemoveAccount Response : ${res}

Remove Thing
    [Arguments]    ${url}    ${accessToken}    ${ThingID}    ${AccountId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVETHING}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVETHING}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  	
    ${data}=    Evaluate    {"ThingId": "${ThingID}"}   
    ${res}=    Delete Api Request    ${url}${PROVISIONINGAPIS}    ${URL_REMOVETHING}    ${headers}    ${data}
	Log To Console    RemoveThing Response : ${res}

Remove ThingStateInfo
    [Arguments]    ${url}    ${accessToken}    ${ThingId}    ${AccountId}    ${Type}    ${SensorKey}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVETHINGSTATEINFO}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVETHINGSTATEINFO}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
    ${data}=    Evaluate    {"ThingId": "${ThingId}","stateType": "${Type}", "stateKey": "${SensorKey}"}   
    ${res}=    Delete Api Request    ${url}${PROVISIONINGAPIS}    ${URL_REMOVETHINGSTATEINFO}    ${headers}    ${data}
	Log To Console    RemoveThingStateInfo Response : ${res}

Remove Group
    [Arguments]    ${url}    ${accessToken}    ${AccountId}    ${GroupId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-UserName=${HEADER_X_AIS_USERNAME_AISPARTNER}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVEGROUP}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVEGROUP}    x-ais-AccessToken=Bearer ${accessToken}    x-ais-AccountKey=${AccountId}        Accept=${HEADER_ACCEPT}  
	#Log To Console    ${headers}
    ${data}=    Evaluate    {"GroupId": "${GroupId}"}   
    #Log To Console    ${data}
    ${res}=    Delete Api Request    ${url}${PROVISIONINGAPIS}    ${URL_REMOVEGROUP}    ${headers}    ${data}
	Log To Console    RemoveGroup Response : ${res}

Remove A Thing
    [Arguments]    ${url}    ${ThingId}
	${current_timestamp}=    Change format date now    ${DDMMYYYYHMS_NOW}
    ${headers}=    Create Dictionary        Content-Type=${HEADER_CONTENT_TYPE}    x-ais-OrderRef=${HEADER_X_AIS_ORDERREF_REMOVEATHING}${current_timestamp}    x-ais-OrderDesc=${HEADER_X_AIS_ORDERDESC_REMOVEATHING} 
	${data}=    Set Variable    ${EMPTY} 
    ${res}=    Delete Api Request    ${url}${CENTRICAPIS}    ${URL_REMOVEATHING}${ThingId}    ${headers}    ${data}
	Log To Console    Remove A Thing : ${res}


