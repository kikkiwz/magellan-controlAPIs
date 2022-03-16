*** Variables ***
#-------------------------------------------- Signin --------------------------------------------#	
#path url signin
${URL_SIGNIN}    /api/v1/auth/signin
#header Signin
${HEADER_X_AIS_ORDERREF_SIGNIN}    Signin_
${HEADER_X_AIS_ORDERREF_SIGNIN_FAIL}    Signinfail_
${HEADER_X_AIS_ORDERDESC_SIGNIN}    User Authentication
#response description
${VALUE_DESCRIPTION_SINGNIN_SUCCESS}    SignInProcess is Success
#request name
${SINGNIN}    Signin	
#-------------------------------------------- CreatePartner --------------------------------------------#	
#path url CreatePartner
${URL_CREATEPARTNER}    /api/v1/Partner/CreatePartner

#header CreatePartner
${HEADER_X_AIS_ORDERREF_CREATEPARTNER}    CreatePartner_
${HEADER_X_AIS_ORDERREF_CREATEPARTNER_FAIL}    CreatePartnerfail_
${HEADER_X_AIS_ORDERDESC_CREATEPARTNER}    CreatePartner

#value Create Partner
${VALUE_PARTNERNAME}    SC_
${VALUE_MERCHANTCONTACT}    Jida_TestMerchantContact@ais.co.th
${VALUE_CPID}    SC_Automate@ais.co.th
${VALUE_ACCOUNTNAME}    SC_Automate
${VALUE_CONFIGGROUPNAME}    Sensor_TestThingGroupName

#response description
${VALUE_DESCRIPTION_CREATEPARTNER_SUCCESS}    CreatePartner is Success

#request name
${CREATEPARTNER}    CreatePartner
${CREATEPARTNER_OTHERROLE}    CreatePartnerOtherRole


#-------------------------------------------- RemovePartner --------------------------------------------#	
#path url remove
${URL_REMOVEPARTNER}    /api/v1/Partner/RemovePartner

#header RemovePartner
${HEADER_X_AIS_ORDERREF_REMOVEPARTNER}    RemovePartner_
${HEADER_X_AIS_ORDERREF_REMOVEPARTNER_FAIL}    RemovePartnerfail_
${HEADER_X_AIS_ORDERDESC_REMOVEPARTNER}    RemovePartner

#request name
${REMOVEPARTNER}    RemovePartner
${REMOVEPARTNER_OTHERROLE}    RemovePartnerOtherRole

#response description
${VALUE_DESCRIPTION_REMOVEPARTNER_SUCCESS}    RemovePartner is Success

#-------------------------------------------- CreateAccount --------------------------------------------#
#path url CreateAccount
${URL_CREATEACCOUNT}    /api/v1/Account/CreateAccount

#header CreateAccount
${HEADER_X_AIS_ORDERREF_CREATEACCOUNT}    CreateAccount_
${HEADER_X_AIS_ORDERREF_CREATEACCOUNT_FAIL}    CreateAccountfail_
${HEADER_X_AIS_ORDERDESC_CREATEACCOUNT}    CreateAccount

#value CreateAccount
${VALUE_ACCOUNTCODE}    AccountCode_

#response description
${VALUE_DESCRIPTION_CREATEACCOUNT_SUCCESS}    CreateAccount is Success

#request name
${CREATEACCOUNT}    CreateAccount
${CREATEACCOUNT_OTHERROLE}    CreateAccountOtherRole

#-------------------------------------------- RemoveAccont --------------------------------------------#
#path url RemoveAccount
${URL_REMOVEACCOUNT}    /api/v1/Account/RemoveAccount

#header InquiryAccount
${HEADER_X_AIS_ORDERREF_REMOVEACCOUNT}    RemoveAccount_
${HEADER_X_AIS_ORDERREF_REMOVEACCOUNT_FAIL}    RemoveAccountfail_
${HEADER_X_AIS_ORDERDESC_REMOVEACCOUNT}    RemoveAccount

#response description
${VALUE_DESCRIPTION_REMOVEACCOUNT_SUCCESS}    RemoveAccount is Success

#request name
${REMOVEACCOUNT}    RemoveAccount
${REMOVEACCOUNT_OTHERROLE}    RemoveAccountOtherRole
#-------------------------------------------- CreateThing --------------------------------------------#	
#path url CreateThing
${URL_CREATETHING}    /api/v1/Thing/CreateThing

#header CreateThing
${HEADER_X_AIS_ORDERREF_CREATETHING}    CreateThing_
${HEADER_X_AIS_ORDERDESC_CREATETHING}    CreateThing

#value Create CreateThing
${VALUE_THINGNAME}    Sensor_TestThingName
${VALUE_ROUTEURL}    ["http://10.12.3.4:2019/api/information/AddInformation"]
${VALUE_ROUTEINFO_MIMO_ID}    "606edada"
${VALUE_ROUTEINFO_MIMO_SERIALNO}    5466758878
${VALUE_ROUTEFLAG_THINGNAME}    "true"
${VALUE_ROUTEFLAG_THINGTOKEN}    "true"
${VALUE_ROUTEFLAG_IMEI}    "true"
${VALUE_ROUTEFLAG_ICCID}    "true"
${VALUE_ROUTEFLAG_ROUTEINFO}    "true"

#response description
${VALUE_DESCRIPTION_CREATETHING_SUCCESS}    CreateThing is Success    

#request name
${CREATETHING}    CreateThing
#-------------------------------------------- RemoveThing --------------------------------------------#	
#path url remove
${URL_REMOVETHING}    /api/v1/Thing/RemoveThing

#header RemoveThing
${HEADER_X_AIS_ORDERREF_REMOVETHING}    RemoveThing_
${HEADER_X_AIS_ORDERDESC_REMOVETHING}    RemoveThing

#request name
${REMOVETHING}    RemoveThing

#response description
${VALUE_DESCRIPTION_REMOVETHING_SUCCESS}    RemoveThing is Success

#-------------------------------------------- CreateThingStateInfo --------------------------------------------#	
#path url CreateThingStateInfo
${URL_CREATETHINGSTATEINFO}    /api/v1/Thing/CreateThingStateInfo

#header CreateThingStateInfo
${HEADER_X_AIS_ORDERREF_CREATETHINGSTATEINFO}    CreateThingStateInfo_
${HEADER_X_AIS_ORDERREF_CREATETHINGSTATEINFO_FAIL}    CreateThingStateInfofail_
${HEADER_X_AIS_ORDERDESC_CREATETHINGSTATEINFO}    CreateThingStateInfo

#value Create ThingStateInfo
${VALUE_SENSORKEY}    Temp
${VALUE_SENSORKEY_POINT}    SC.1234
${VALUE_SENSORKEY_CHARGING}    AA
${VALUE_TYPE_REPORT}    Report
${VALUE_TYPE_DESIRE}    Desire
${VALUE_TYPE_DESIRE_INVALID}    desire

#response description
${VALUE_DESCRIPTION_CREATETHINGSTATEINFO_SUCCESS}    CreateThingStateInfo is Success

#request name
${CREATETHINGSTATEINFO}    CreateThingStateInfo
${CREATETHINGSTATEINFO_OTHERROLE}    CreateThingStateInfoOtherRole

#-------------------------------------------- RemoveThingStateInfo --------------------------------------------#	
#path url remove
${URL_REMOVETHINGSTATEINFO}    /api/v1/Thing/RemoveThingStateInfo

#header RemoveThingStateInfo
${HEADER_X_AIS_ORDERREF_REMOVETHINGSTATEINFO}    RemoveThingStateInfo_
${HEADER_X_AIS_ORDERREF_REMOVETHINGSTATEINFO_FAIL}    RemoveThingStateInfofail_
${HEADER_X_AIS_ORDERDESC_REMOVETHINGSTATEINFO}    RemoveThingStateInfo

#value
# ${VALUE_STATETYPE}    Report 
# ${VALUE_STATEKEY}    Temp 
${VALUE_SENSORKEY_NOTFOUND}    BB 

#request name
${REMOVETHINGSTATEINFO}    RemoveThingStateInfo
${REMOVETHINGSTATEINFO_OTHERROLE}    RemoveThingStateInfoOtherRole

#response description
${VALUE_DESCRIPTION_REMOVETHINGSTATEINFO_SUCCESS}    RemoveThingStateInfo is Success

#-------------------------------------------- ActivateThing Core --------------------------------------------#	
#path url ActivateThing Core
${URL_ACTIVATETHING_CORE}    /api/v1/Thing/ActivateThing

#header ActivateThing
${HEADER_X_AIS_ORDERREF_ACTIVATETHING_CORE}    ActivateThing_
${HEADER_X_AIS_ORDERREF_ACTIVATETHING_CORE_FAIL}    ActivateThingfail_
${HEADER_X_AIS_ORDERDESC_ACTIVATETHING_CORE}    ActivateThing

#response description
${VALUE_DESCRIPTION_ACTIVATETHING_CORE_SUCCESS}    ActivateThing is Success

#request name
${ACTIVATETHING_CORE}    ActivateThingCore

#-------------------------------------------- CreateGroup --------------------------------------------#	
#path url CreateGroup
${URL_CREATEGROUP}    /api/v1/Group/CreateGroup

#header CreateGroup
${HEADER_X_AIS_ORDERREF_CREATEGROUP}    CreateGroup_
${HEADER_X_AIS_ORDERREF_CREATEGROUP_FAIL}    CreateGroupfail_
${HEADER_X_AIS_ORDERDESC_CREATEGROUP}    CreateGroup
 
#value CreateGroup
${VALUE_THINGGROUPNAME}    ThingGroupName
${VALUE_QUASARCONTENTTYPE}    None
${VALUE_QUASARREFRESHTIME}    0

#response description
${VALUE_DESCRIPTION_CREATEGROUP_SUCCESS}    CreateGroup is Success    

#request name
${CREATEGROUP}    CreateGroup
${CREATEGROUP_OTHERROLE}    CreateGroupOtherRole

#-------------------------------------------- RemoveGroup --------------------------------------------#	
#path url remove
${URL_REMOVEGROUP}    /api/v1/Group/RemoveGroup
	
#header RemoveGroup
${HEADER_X_AIS_ORDERREF_REMOVEGROUP}    RemoveGroup_
${HEADER_X_AIS_ORDERREF_REMOVEGROUP_FAIL}    RemoveGroupfail_
${HEADER_X_AIS_ORDERDESC_REMOVEGROUP}    RemoveGroup

#request name
${REMOVEGROUP}    RemoveGroup
${REMOVEGROUP_OTHERROLE}    RemoveGroupOtherRole

#response description
${VALUE_DESCRIPTION_REMOVEGROUP_SUCCESS}    RemoveGroup is Success

#-------------------------------------------- Control Thing --------------------------------------------#	
#path url Control
${URL_CREATECONTROLTHING}    /api/v1/Control/Thing
#header CreateControlthing
${HEADER_X_AIS_ORDERREF_CREATECONTROLTHING}    CreateControlthing_
${HEADER_X_AIS_ORDERDESC_CREATECONTROLAPI}    CreateControlAPI

#request name
${CREATECONTROLTHING}    CreateControlthing
${VALUE_DESCRIPTION_CREATECONTROLTHING_SUCCESS}    ControlOneThing is Success
${ThingId_TST_F1_0_2_003}    5f719410226bf9000127a1eexx
#-------------------------------------------- Control ThingS --------------------------------------------#
#path url Control
${URL_CREATECONTROLTHINGS}    /api/v1/Control/Things
#header CreateControlthing
${HEADER_X_AIS_ORDERREF_CREATECONTROLTHINGS}    CreateControlthings_
#request name
${CREATECONTROLTHINGS}    CreateControlthings
${VALUE_DESCRIPTION_CREATECONTROLTHINGS_SUCCESS}    ControlManyThings is Success
#-------------------------------------------- Control ThingGroup --------------------------------------------#
#path url Control
${URL_CREATECONTROLTHINGGROUP}    /api/v1/Control/ThingGroup
#header CreateControlthing
${HEADER_X_AIS_ORDERREF_CREATECONTROLTHINGGROUP}    CreateControlThinGroup_
#request name
${CREATECONTROLTHINGGROUP}    CreateCreateControlThinGroup
${VALUE_DESCRIPTION_CREATECONTROLTHINGGROUP_SUCCESS}    ControlOneGroup is Success
#-------------------------------------------- Control ThingGroups --------------------------------------------#
#path url Control
${URL_CREATECONTROLTHINGGROUPS}    /api/v1/Control/ThingGroups
#header CreateControlthing
${HEADER_X_AIS_ORDERREF_CREATECONTROLTHINGGROUPS}    CreateControlThinGroups_
#request name
${CREATECONTROLTHINGGROUPS}    CreateCreateControlThinGroups
${VALUE_DESCRIPTION_CREATECONTROLTHINGGROUPS_SUCCESS}    ControlManyGroups is Success
#-------------------------------------------------------------------------------------------------------#
#-------------------------------------------- CreateAThing --------------------------------------------#	
#path url CreateAThing
${URL_CREATEATHING}    /api/v1/Things

#header CreateAThing
${HEADER_X_AIS_ORDERREF_CREATEATHING}    CreateAThing_
${HEADER_X_AIS_ORDERDESC_CREATEATHING}    CreateAThing

#value Create CreateAThing
# ${VALUE_THINGNAME}    Sensor_TestThingName

#response description
${VALUE_DESCRIPTION_CREATEATHING_SUCCESS}    The requested operation was successfully.

#request name
${CREATEATHING}    CreateAThing

#request name
${VALUE_ATHINGNAME}    ThingName
${VALUE_SUPPLIERID}    SupplierId
${VALUE_SUPPLIERNAME}    SupplierName

${VALUE_THINGSTATE_IDLE}    Idle
${VALUE_THINGSTATE_PENDING}    Pending
${VALUE_THINGSTATE_MENUFACTURING}    Menufacturing
${VALUE_THINGSTATE_ACTIVATED}    Activated
${VALUE_CONNECTIVITYTYPE_NBIOT}    NBIOT
${VALUE_CONNECTIVITYTYPE_SIM3G}    SIM3G
${VALUE_CONNECTIVITYTYPE_SIM4G}    SIM4G
${VALUE_CONNECTIVITYTYPE_SIM5G}    SIM5G
${VALUE_CONNECTIVITYTYPE_WIFIOrWIMAX}    "WIFI or WIMAX
${VALUE_CONNECTIVITYTYPE_WIMAX}    WIMAX
${VALUE_CONNECTIVITYTYPE_WIFI}    WIFI
#-------------------------------------------- RemoveAThing --------------------------------------------#	
#path url remove
${URL_REMOVEATHING}    /api/v1/Things/

#header RemoveThing
${HEADER_X_AIS_ORDERREF_REMOVEATHING}    RemoveAThing_
${HEADER_X_AIS_ORDERDESC_REMOVEATHING}    RemoveAThing 

#request name
${REMOVEATHING}    RemoveAThing

#response description
${VALUE_DESCRIPTION_REMOVEATHING_SUCCESS}    The requested operation was successfully.
#-------------------------------------------- ImportThing --------------------------------------------#	
#path url ImportThing
${URL_IMPORTTHING}    /api/v1/Things/Import

#header ImportThing
${HEADER_X_AIS_ORDERREF_IMPORTTHING}    ImportThing_
${HEADER_X_AIS_ORDERDESC_IMPORTTHING}    ImportThing

#response description
${VALUE_DESCRIPTION_IMPORTTHING_SUCCESS}    The requested operation was successfully.

#request name
${IMPORTTHING}    ImportThing

#-------------------------------------------- Mapping IMEI --------------------------------------------#	
#path url MappingIMEI
${URL_MAPPINGIMEI}    /api/v1/Things/Mapping/IMEI

#header MappingIMEI
${HEADER_X_AIS_ORDERREF_MAPPINGIMEI}    MappingIMEI_
${HEADER_X_AIS_ORDERDESC_MAPPINGIMEI}    MappingIMEI

#response description
${VALUE_DESCRIPTION_MAPPINGIMEI_SUCCESS}    The requested operation was successfully.

#request name
${MAPPINGIMEI}    MappingIMEI

#-------------------------------------------- ActivateThings Centric --------------------------------------------#	
#path url ActivateThings Centric
${URL_ACTIVATETHINGS_CENTRIC}    /api/v1/Capability/Worker/{WorkerId}/Thing/Activates

#header ActivateThings
${HEADER_X_AIS_ORDERREF_ACTIVATETHINGS_CENTRIC}    ActivateThings_
${HEADER_X_AIS_ORDERDESC_ACTIVATETHINGS_CENTRIC}    ActivateThings

#response description
${VALUE_DESCRIPTION_ACTIVATETHINGS_CENTRIC_SUCCESS}    The requested operation was successfully.

#request name
${ACTIVATETHINGS_CENTRIC}    ActivateThingsCentric
#-------------------------------------------- Other --------------------------------------------#	
#Other field
${FIELD_OPERATIONSTATUS}    OperationStatus
${FIELD_CODE}    Code
${FIELD_DESCRIPTION}    Description
${FIELD_ACCESSTOKEN}    AccessToken    
${FIELD_PARTNERINFO}    PartnerInfo
${FIELD_PARTNERINFO_LOWWERCASE}    partnerInfo   
${FIELD_PARTNERID}    PartnerId  
${FIELD_PARTNERNAME}    PartnerName
${FIELD_ACCOUNTINFO}    AccountInfo  
${FIELD_ACCOUNTNAME}    AccountName  
${FIELD_ACCOUNTID}    AccountId  
${FIELD_ACCOUNTCODE}    AccountCode 
${FIELD_THINGINFO}    ThingInfo  
${FIELD_THINGID}    ThingId 
${FIELD_THINGIDENTIFIER}    ThingIdentifier  
${FIELD_THINGSECRET}    ThingSecret  
${FIELD_IMSI}    IMSI  
${FIELD_IMEI}    IMEI
${FIELD_THINGTOKEN}    ThingToken   
${FIELD_CONFIGGROUPINFO}    ConfigGroupInfo   
${FIELD_CONFIGGROUPID}    ConfigGroupId   
${FIELD_WORKERSINFO}    WorkersInfo 
${FIELD_WORKERID}    WorkerId
${FIELD_ACTIVATETHING}    ActivateThing
${FIELD_GROUPINFO}    GroupInfo  
${FIELD_GROUPID}    GroupId 
${FIELD_BACKUPDATAINFO}    BackupDataInfo 
${FIELD_PULLMESSAGEID}    PullMessageId 
${FIELD_ROUTEINFO}    RouteInfo
${FIELD_ROUTEID}    RouteId 
${FIELD_ROUTENAME}    RouteName
${FIELD_PURCHASEINFO}    PurchaseInfo 
${FIELD_CUSTOMERID}    CustomerId
${FIELD_SYSTEMUSERINFO}    SystemUserInfo

${FIELD_ICCIDPRE}    896603
${ACCOUNTID_NULL}    Null
${ACCOUNTKEY_INVALID}    xx
