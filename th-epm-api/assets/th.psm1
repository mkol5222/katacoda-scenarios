
Function Convert-FromUnixDate ($UnixDate) {
    return [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddMilliseconds($UnixDate))
 }

# get Infinity Portal token based on API keys
# token is also stored as $Script:cpPortalToken
function New-CPPortalSession ($key, $secret) {
    $body = @{
        clientId  = $key;
        accessKey = $secret
    } | ConvertTo-Json
    $res = Invoke-RestMethod -Uri "https://cloudinfra-gw.portal.checkpoint.com/auth/external" `
        -Headers @{"Content-Type" = "application/json" } `
        -Body $body -Method Post
    $Script:cpPortalToken = $res.data.token
    return $Script:cpPortalToken
}

# to be wrapped for specific queries
function Get-CPTHGraphQLResponse ($query, $variables) {

    $body = @{
        query     = $query;
        variables = $variables
    } | ConvertTo-Json -Depth 99

    $headers = @{
        'Content-Type'  = 'application/json';
        'Authorization' = "Bearer $Script:cpPortalToken"
    }

    $res = Invoke-RestMethod `
        -Uri "https://cloudinfra-gw.portal.checkpoint.com/app/threathunting/prod-gcp-apollo/" `
        -Body $body `
        -Headers $headers `
        -Method Post
    
    return $res.data
}
function Get-CPTHQueryProcessNameIs ($processName) {
    $fromTsStr = ((Get-Date).AddDays(-7)).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffK")
    $toTsStr = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffK")
  
    $query = @'
  query searchRecords($indicators: [Indicator]!, $queryParam: QueryParam, $includeRecordBase: Boolean!, $includeRecordProcess: Boolean!, $includeRecordFile: Boolean!, $includeRecordNetwork: Boolean!, $includeRecordRegistry: Boolean!, $includeRecordInject: Boolean!, $includeRecordEmail: Boolean!, $includeRecordRemoteLogon: Boolean!, $includeRecordScript: Boolean!, $includeDetectionEvent: Boolean!, $includeMitre: Boolean!, $includeShadowIT: Boolean!, $includeAdvancedActivity: Boolean!, $includeIndirectExecution: Boolean!, $includeRemoteExecution: Boolean!, $includeGWStats: Boolean!, $includeMTA: Boolean!, $includeLAAS: Boolean!) {
    searchRecords(indicators: $indicators, queryParam: $queryParam) {
      pagination {
        maxResults
        pageToken
        __typename
      }
      metadata {
        totalRows
        jobId
        __typename
      }
      records {
        ... on EPRecord {
          DataSource
          UUID
          MachineName
          UserName
          OSName
          HostType
          OSVersion
          ProductVersion
          DomainName
          EPGUID
          HostIps
          HostMacs
          Base @include(if: $includeRecordBase) {
            RecordType
            Pid
            CreationTime
            PidCreationTime
            OpTimeUTC
            ProcessDir
            ProcessName
            ProcessPath
            ProcessMD5
            ProcessSigner
            ProcessArgs
            ProcessClassification
            ParentProcessDir
            ProcessTerminationTime
            ParentProcessName
            ParentProcessMD5
            ParentProcessSigner
            ParentProcessClassification
            LogSource
            Browser
            BrowserVersion
            ProcessReputationInfo {
              ReputationType
              Resource
              ProcessClassification
              ProcessRepPositives
              ProcessRepTotal
              ProcessRepRisk
              ProcessRepConfidence
              ProcessRepSeverity
              ProcessRepMalwareFamily
              ProcessRepMalwareTypes
              ProcessRepProtectionName
              VTLink
              __typename
            }
            ParentProcessReputationInfo {
              ReputationType
              Resource
              ProcessClassification
              ProcessRepPositives
              ProcessRepTotal
              ProcessRepRisk
              ProcessRepConfidence
              ProcessRepSeverity
              ProcessRepMalwareFamily
              ProcessRepMalwareTypes
              ProcessRepProtectionName
              VTLink
              __typename
            }
            __typename
          }
          Process @include(if: $includeRecordProcess) {
            ProcessArgs
            ProcessInvalidSigner
            ProcessPPid
            ProcessPCreationTime
            ProcessPPidCreationTime
            ProcessOp
            ProcessIntegrityLevel
            ProcessAccount
            ProcessLogonSession
            ParentProcessIntegrityLevel
            ParentProcessArgs
            __typename
          }
          Email @include(if: $includeRecordEmail) {
            EmailFrom
            EmailTo
            EmailType
            EmailSubject
            EmailServerName
            EmailMessageId
            EmailCC
            EmailBCC
            EmailAttachments
            EmailURLs
            __typename
          }
          File @include(if: $includeRecordFile) {
            FileDir
            FileName
            FileMD5
            FileSize
            FileType
            FileNewDir
            FileNewFileName
            FileOpMask
            FileOp
            FileContent
            FilePath
            FileSigner
            EmailFrom
            EmailTo
            EmailType
            EmailSubject
            EmailServerName
            EmailMessageId
            EmailCC
            EmailBCC
            OriginalFileClassification
            FileReputationInfo {
              ReputationType
              Resource
              FileClassification
              FileRepPositives
              FileRepTotal
              FileRepRisk
              FileRepConfidence
              FileRepSeverity
              FileRepMalwareFamily
              FileRepMalwareTypes
              FileRepProtectionName
              VTLink
              __typename
            }
            __typename
          }
          Network @include(if: $includeRecordNetwork) {
            NetworkProtocol
            NetworkDomain
            NetworkHttpMethod
            NetworkReferer
            NetworkUserAgent
            NetworkResponseStatusCode
            NetworkSrcIP
            NetworkSrcPort
            NetworkDestIP
            NetworkDestPort
            NetworkIsListen
            NetworkURL
            NetworkDisplayedUrl
            NetworkBytesSent
            NetworkBytesReceived
            NetworkType
            NetworkConnectionDirection
            FileName
            FileMD5
            EmailFrom
            EmailTo
            EmailType
            EmailSubject
            EmailServerName
            EmailMessageId
            EmailCC
            EmailBCC
            NetworkIsIframe
            URLReputationInfo {
              ReputationType
              Resource
              URLClassification
              URLRepTotal
              URLRepPositives
              URLRepRisk
              URLRepConfidence
              URLRepSeverity
              URLRepMalwareFamily
              URLRepProtectionName
              URLRepRegistrant
              VTLink
              __typename
            }
            DomainReputationInfo {
              ReputationType
              Resource
              DomainClassification
              DomainRepTotal
              DomainRepPositives
              DomainRepRisk
              DomainRepConfidence
              DomainRepSeverity
              DomainRepMalwareFamily
              DomainRepProtectionName
              DomainRepRegistrant
              VTLink
              __typename
            }
            DestIPReputationInfo {
              ReputationType
              Resource
              IPClassification
              IPRepTotal
              IPRepPositives
              IPRepRisk
              IPRepConfidence
              IPRepSeverity
              IPRepMalwareFamily
              IPRepGeoLocation
              VTLink
              __typename
            }
            NetworkIsRemoteIpConnection
            __typename
          }
          Registry @include(if: $includeRecordRegistry) {
            RegistryKey
            RegistryValue
            RegistryNewData
            RegistryOldData
            RegistryOpMask
            RegistryOp
            __typename
          }
          Inject @include(if: $includeRecordInject) {
            InjectDstPid
            InjectDstCreationTime
            InjectClassification
            InjectDstDir
            InjectDstName
            InjectHookOperation
            __typename
          }
          Script @include(if: $includeRecordScript) {
            ScriptData
            __typename
          }
          RemoteLogon @include(if: $includeRecordRemoteLogon) {
            RemoteAttackerMachineName
            RemoteOwnerUserName
            RemoteOwnerDomainName
            RemoteAttackerIpAddress
            RemoteIpPort
            RemoteLogonType
            EventType
            RemoteEventID
            RemoteEventDescription
            RemoteStatusDescription
            RemoteSubStatusDescription
            RemoteNumberOfConnections
            LogonId
            LinkedLogonId
            UserSID
            LogonOrigin
            __typename
          }
          DetectionEvent @include(if: $includeDetectionEvent) {
            DetectionIncidentId
            DetectionAttackStatus
            DetectionEnforcementMode
            DetectionMalwareAction
            DetectionTriggeredBy
            DetectionThirdPartyVendorName
            DetectionMalwareFamily
            DetectionProtectionName
            DetectionProtectionType
            DetectionIncidentConfidence
            DetectionIncidentSeverity
            DetectionAttackTriggerProc
            DetectionMaliciousPath
            DetectionMaliciousFileDir
            DetectionMaliciousFileName
            DetectionMaliciousDomainName
            DetectionTriggerMD5
            DetectionEntryPointProc
            DetectionAttackRoot
            DetectionCreatingProcDir
            DetectionCreatingProcName
            DetectionCreatingProcMD5
            DetectionCreatingProcSigner
            DetectionCreatingProcPid
            DetectionCreatingProcCreationTime
            DetectionPolicyAutoRemidiation
            DetectionGeneralInfo
            DetectionDescription
            DetectionRemediationPolicy
            DetectionFirstEPNet
            DetectionFirstEPURLReferrer
            DetectionFirstEPFileName
            DetectionFirstEPFileHash
            DetectionAttackUserDomain
            DetectionAttackUserName
            DetectionImpersonatedDomain
            DetectionImpersonatedType
            DetectionImpersonatedBrand
            DetectionEmailMsgID
            DetectionEmailSubject
            DetectionEmailFrom
            DetectionEmailTo
            DetectionEmailAttachmentName
            DetectionEmailEmbeddedURL
            DetectionEmailDateOfDelivery
            __typename
          }
          AdvancedActivity @include(if: $includeAdvancedActivity) {
            ActivityType
            ActivityName
            ActivityDetails
            ActivityTargetProcessDir
            ActivityTargetProcessName
            ActivityTargetProcessArgs
            ActivityTargetPid
            ActivityTargetCreationTime
            __typename
          }
          IndirectExecution @include(if: $includeIndirectExecution) {
            ExecutionType
            ExecutionName
            ExecutionDetails
            ExecutionTargetProcessDir
            ExecutionTargetProcessName
            ExecutionTargetProcessArgs
            ExecutionTargetPid
            ExecutionTargetCreationTime
            ExecutionRemoteSourceMachine
            ExecutionRemoteTargetUserName
            ExecutionRemoteTargetUserDomain
            __typename
          }
          RemoteExecution @include(if: $includeRemoteExecution) {
            RemoteExecutionSourceIpAddress
            RemoteExecutionSourcePort
            RemoteExecutionSourceMachineName
            RemoteExecutionDestinationIpAddress
            RemoteExecutionDestinationPort
            RemoteExecutionUserName
            RemoteExecutionDomainName
            RemoteExecutionUserSID
            RemoteExecutionLogonId
            RemoteExecutionType
            __typename
          }
          MitreInfo @include(if: $includeMitre) {
            tacticID
            tacticName
            techniqueID
            techniqueName
            __typename
          }
          ShadowITInfo @include(if: $includeShadowIT) {
            applicationName
            categoryName
            subCategoryName
            __typename
          }
          AggregationResults {
            aggregationName
            aggregateResult
            __typename
          }
          __typename
        }
        ... on GWStatsRecord @include(if: $includeGWStats) {
          DataSource
          UUID
          HostType
          MachineName
          UserName
          OSName
          OSVersion
          Base {
            RecordType
            OpTimeUTC
            GatewayName
            __typename
          }
          Network {
            NetworkType
            NetworkURL
            NetworkProtocol
            NetworkDomain
            NetworkSrcIP
            NetworkSrcPort
            NetworkDestIP
            NetworkDestPort
            NetworkConnectionDirection
            NetworkReferer
            NetworkResponseStatusCode
            NetworkUserAgent
            NetworkHttpMethod
            FileMD5
            URLReputationInfo {
              ReputationType
              Resource
              URLClassification
              URLRepTotal
              URLRepPositives
              URLRepRisk
              URLRepConfidence
              URLRepSeverity
              URLRepMalwareFamily
              URLRepProtectionName
              URLRepRegistrant
              VTLink
              __typename
            }
            DomainReputationInfo {
              ReputationType
              Resource
              DomainClassification
              DomainRepTotal
              DomainRepPositives
              DomainRepRisk
              DomainRepConfidence
              DomainRepSeverity
              DomainRepMalwareFamily
              DomainRepProtectionName
              DomainRepRegistrant
              VTLink
              __typename
            }
            DestIPReputationInfo {
              ReputationType
              Resource
              IPClassification
              IPRepTotal
              IPRepPositives
              IPRepRisk
              IPRepConfidence
              IPRepSeverity
              IPRepMalwareFamily
              IPRepGeoLocation
              VTLink
              __typename
            }
            __typename
          }
          File @include(if: $includeRecordFile) {
            FileName
            FileMD5
            FileSize
            FileReputationInfo {
              ReputationType
              Resource
              FileClassification
              FileRepPositives
              FileRepTotal
              FileRepRisk
              FileRepConfidence
              FileRepSeverity
              FileRepMalwareFamily
              FileRepMalwareTypes
              FileRepProtectionName
              VTLink
              __typename
            }
            __typename
          }
          DetectionEvent @include(if: $includeDetectionEvent) {
            DetectionAttackStatus
            DetectionEnforcementMode
            DetectionMalwareAction
            DetectionTriggeredBy
            DetectionMalwareFamily
            DetectionProtectionName
            DetectionIncidentConfidence
            DetectionIncidentSeverity
            DetectionMaliciousPath
            DetectionMaliciousFileName
            DetectionMaliciousDomainName
            DetectionTriggerMD5
            DetectionConnectionCount
            DetectionRemediationPolicy
            DetectionDescription
            __typename
          }
          MitreInfo @include(if: $includeMitre) {
            tacticID
            tacticName
            techniqueID
            techniqueName
            __typename
          }
          ShadowITInfo @include(if: $includeShadowIT) {
            applicationName
            categoryName
            subCategoryName
            __typename
          }
          __typename
        }
        ... on LAASRecord @include(if: $includeLAAS) {
          DataSource
          UUID
          HostType
          MachineName
          UserName
          OSName
          OSVersion
          Base {
            RecordType
            OpTimeUTC
            GatewayBlade
            GatewayName
            GatewayPolicyMgmt
            GatewayPolicyDate
            GatewayPolicyName
            GatewayPolicyRuleName
            GatewayPolicyRuleNumber
            GatewayPolicyRuleAction
            __typename
          }
          Network {
            NetworkType
            NetworkURL
            NetworkProtocol
            NetworkDomain
            NetworkSrcIP
            NetworkSrcPort
            NetworkDestIP
            NetworkDestPort
            NetworkConnectionDirection
            NetworkReferer
            NetworkResponseStatusCode
            NetworkUserAgent
            NetworkHttpMethod
            NetworkBytesSent
            NetworkBytesReceived
            URLReputationInfo {
              ReputationType
              Resource
              URLClassification
              URLRepTotal
              URLRepPositives
              URLRepRisk
              URLRepConfidence
              URLRepSeverity
              URLRepMalwareFamily
              URLRepProtectionName
              URLRepRegistrant
              VTLink
              __typename
            }
            DomainReputationInfo {
              ReputationType
              Resource
              DomainClassification
              DomainRepTotal
              DomainRepPositives
              DomainRepRisk
              DomainRepConfidence
              DomainRepSeverity
              DomainRepMalwareFamily
              DomainRepProtectionName
              DomainRepRegistrant
              VTLink
              __typename
            }
            DestIPReputationInfo {
              ReputationType
              Resource
              IPClassification
              IPRepTotal
              IPRepPositives
              IPRepRisk
              IPRepConfidence
              IPRepSeverity
              IPRepMalwareFamily
              IPRepGeoLocation
              VTLink
              __typename
            }
            __typename
          }
          File @include(if: $includeRecordFile) {
            FileName
            FileMD5
            FileSize
            FileReputationInfo {
              ReputationType
              Resource
              FileClassification
              FileRepPositives
              FileRepTotal
              FileRepRisk
              FileRepConfidence
              FileRepSeverity
              FileRepMalwareFamily
              FileRepMalwareTypes
              FileRepProtectionName
              VTLink
              __typename
            }
            __typename
          }
          DetectionEvent @include(if: $includeDetectionEvent) {
            DetectionAttackStatus
            DetectionEnforcementMode
            DetectionMalwareAction
            DetectionTriggeredBy
            DetectionMalwareFamily
            DetectionProtectionName
            DetectionIncidentConfidence
            DetectionIncidentSeverity
            DetectionMaliciousPath
            DetectionMaliciousFileName
            DetectionMaliciousDomainName
            DetectionTriggerMD5
            DetectionConnectionCount
            DetectionRemediationPolicy
            DetectionDescription
            DetectionSuppressedLogs
            __typename
          }
          MitreInfo @include(if: $includeMitre) {
            tacticID
            tacticName
            techniqueID
            techniqueName
            __typename
          }
          ShadowITInfo @include(if: $includeShadowIT) {
            applicationName
            categoryName
            subCategoryName
            __typename
          }
          __typename
        }
        ... on MTARecord @include(if: $includeMTA) {
          DataSource
          OSName
          HostType
          Base {
            AssetType
            OpTimeSecondsUTC
            Domain
            OpTimeUTC
            RecordType
            OSVersion
            HostType
            MachineName
            UserName
            __typename
          }
          DetectionEvent @include(if: $includeDetectionEvent) {
            DetectionEventType
            DetectionAttackStatus
            DetectionEnforcementMode
            DetectionMalwareAction
            DetectionTriggeredBy
            DetectionMalwareFamily
            DetectionProtectionName
            DetectionProtectionType
            DetectionIncidentConfidence
            DetectionIncidentSeverity
            DetectionMaliciousFileName
            DetectionMaliciousDomainName
            DetectionTriggerMD5
            DetectionTriggerURL
            DetectionDescription
            DetectionEmailMsgID
            DetectionEmailSubject
            DetectionEmailFrom
            DetectionEmailTo
            DetectionEmailAttachmentName
            DetectionEmailDateOfDelivery
            DetectionMaliciousPath
            __typename
          }
          File @include(if: $includeRecordFile) {
            FileName
            FileMD5
            FileSha1
            FileType
            FileSize
            OriginalFileClassification
            FileReputationInfo {
              ReputationType
              Resource
              FileClassification
              FileRepPositives
              FileRepTotal
              FileRepRisk
              FileRepConfidence
              FileRepSeverity
              FileRepMalwareFamily
              FileRepMalwareTypes
              FileRepProtectionName
              VTLink
              __typename
            }
            __typename
          }
          Network @include(if: $includeRecordNetwork) {
            NetworkSrcIP
            NetworkURL
            NetworkAction
            NetworkDomain
            NetworkType
            URLReputationInfo {
              ReputationType
              Resource
              URLClassification
              URLRepTotal
              URLRepPositives
              URLRepRisk
              URLRepConfidence
              URLRepSeverity
              URLRepMalwareFamily
              URLRepProtectionName
              URLRepRegistrant
              VTLink
              __typename
            }
            DomainReputationInfo {
              ReputationType
              Resource
              DomainClassification
              DomainRepTotal
              DomainRepPositives
              DomainRepRisk
              DomainRepConfidence
              DomainRepSeverity
              DomainRepMalwareFamily
              DomainRepProtectionName
              DomainRepRegistrant
              VTLink
              __typename
            }
            DestIPReputationInfo {
              ReputationType
              Resource
              IPClassification
              IPRepTotal
              IPRepPositives
              IPRepRisk
              IPRepConfidence
              IPRepSeverity
              IPRepMalwareFamily
              IPRepGeoLocation
              VTLink
              __typename
            }
            __typename
          }
          Email {
            EmailRule
            EmailStatus
            EmailClassification
            EmailReason
            EmailId
            EmailTo
            EmailFrom
            EmailSrcIP
            EmailStatus
            EmailSubject
            EmailQueueId
            EmailReplyTo
            EmailMessageId
            EmailAttachments
            EmailURLsCount
            EmailRecipientsNum
            EmailSourceCountry
            EmailInspectionType
            EmailConfidence
            __typename
          }
          __typename
        }
        __typename
      }
      __typename
    }
  }
      
'@
    

    $varsJson = @'
{
  "indicators": [
    {
      "fieldArr": [
        "explorer.exe"
      ],
      "fieldType": "ProcessName",
      "operator": "Is",
      "escaped": true
    }
  ],
  "queryParam": {
    "dateRange": {
      "from": "2021-09-19T22:00:00.000Z",
      "to": "2021-09-20T21:59:59.999Z"
    },
    "pagination": {
      "maxResults": 50,
      "pageToken": null
    },
    "aggregations": {
      "selectDistinct": false
    },
    "jobId": null,
    "useRepCache": false,
    "orderBy": {
      "field": "OpTimeUTC",
      "ascDesc": "DESC"
    },
    "recordTypes": [
      "Process"
    ],
    "dataSourceTypes": [
      "endpoint"
    ]
  },
  "includeRecordBase": true,
  "includeRecordProcess": true,
  "includeRecordFile": false,
  "includeRecordEmail": false,
  "includeRecordNetwork": false,
  "includeRecordRegistry": false,
  "includeRecordInject": false,
  "includeRecordRemoteLogon": false,
  "includeRecordScript": false,
  "includeDetectionEvent": false,
  "includeAdvancedActivity": false,
  "includeIndirectExecution": false,
  "includeRemoteExecution": false,
  "includeMTA": false,
  "includeGWStats": false,
  "includeLAAS": false,
  "includeMitre": true,
  "includeShadowIT": true
}
'@

    $variables = $varsJson | ConvertFrom-Json

    $fromTsStr = ((Get-Date).AddDays(-7)).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffK")
    $toTsStr = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffK")
    
    $variables.queryParam.dateRange.from = $fromTsStr
    $variables.queryParam.dateRange.to = $toTsStr
    $variables.indicators[0].fieldArr[0] = $processName

    $res = Get-CPTHGraphQLResponse $query $variables
    return $res
}

function Get-CPTHDetectionEvents {
    $query = @'
    query searchRecords($indicators: [Indicator]!, $queryParam: QueryParam, $includeRecordBase: Boolean!, $includeRecordProcess: Boolean!, $includeRecordFile: Boolean!, $includeRecordNetwork: Boolean!, $includeRecordRegistry: Boolean!, $includeRecordInject: Boolean!, $includeRecordEmail: Boolean!, $includeRecordRemoteLogon: Boolean!, $includeRecordScript: Boolean!, $includeDetectionEvent: Boolean!, $includeMitre: Boolean!, $includeShadowIT: Boolean!, $includeAdvancedActivity: Boolean!, $includeIndirectExecution: Boolean!, $includeRemoteExecution: Boolean!, $includeGWStats: Boolean!, $includeMTA: Boolean!, $includeLAAS: Boolean!) {
        searchRecords(indicators: $indicators, queryParam: $queryParam) {
          pagination {
            maxResults
            pageToken
            __typename
          }
          metadata {
            totalRows
            jobId
            __typename
          }
          records {
            ... on EPRecord {
              DataSource
              UUID
              MachineName
              UserName
              OSName
              HostType
              OSVersion
              ProductVersion
              DomainName
              EPGUID
              HostIps
              HostMacs
              Base @include(if: $includeRecordBase) {
                RecordType
                Pid
                CreationTime
                PidCreationTime
                OpTimeUTC
                ProcessDir
                ProcessName
                ProcessPath
                ProcessMD5
                ProcessSigner
                ProcessArgs
                ProcessClassification
                ParentProcessDir
                ProcessTerminationTime
                ParentProcessName
                ParentProcessMD5
                ParentProcessSigner
                ParentProcessClassification
                LogSource
                Browser
                BrowserVersion
                ProcessReputationInfo {
                  ReputationType
                  Resource
                  ProcessClassification
                  ProcessRepPositives
                  ProcessRepTotal
                  ProcessRepRisk
                  ProcessRepConfidence
                  ProcessRepSeverity
                  ProcessRepMalwareFamily
                  ProcessRepMalwareTypes
                  ProcessRepProtectionName
                  VTLink
                  __typename
                }
                ParentProcessReputationInfo {
                  ReputationType
                  Resource
                  ProcessClassification
                  ProcessRepPositives
                  ProcessRepTotal
                  ProcessRepRisk
                  ProcessRepConfidence
                  ProcessRepSeverity
                  ProcessRepMalwareFamily
                  ProcessRepMalwareTypes
                  ProcessRepProtectionName
                  VTLink
                  __typename
                }
                __typename
              }
              Process @include(if: $includeRecordProcess) {
                ProcessArgs
                ProcessInvalidSigner
                ProcessPPid
                ProcessPCreationTime
                ProcessPPidCreationTime
                ProcessOp
                ProcessIntegrityLevel
                ProcessAccount
                ProcessLogonSession
                ParentProcessIntegrityLevel
                ParentProcessArgs
                __typename
              }
              Email @include(if: $includeRecordEmail) {
                EmailFrom
                EmailTo
                EmailType
                EmailSubject
                EmailServerName
                EmailMessageId
                EmailCC
                EmailBCC
                EmailAttachments
                EmailURLs
                __typename
              }
              File @include(if: $includeRecordFile) {
                FileDir
                FileName
                FileMD5
                FileSize
                FileType
                FileNewDir
                FileNewFileName
                FileOpMask
                FileOp
                FileContent
                FilePath
                FileSigner
                EmailFrom
                EmailTo
                EmailType
                EmailSubject
                EmailServerName
                EmailMessageId
                EmailCC
                EmailBCC
                OriginalFileClassification
                FileReputationInfo {
                  ReputationType
                  Resource
                  FileClassification
                  FileRepPositives
                  FileRepTotal
                  FileRepRisk
                  FileRepConfidence
                  FileRepSeverity
                  FileRepMalwareFamily
                  FileRepMalwareTypes
                  FileRepProtectionName
                  VTLink
                  __typename
                }
                __typename
              }
              Network @include(if: $includeRecordNetwork) {
                NetworkProtocol
                NetworkDomain
                NetworkHttpMethod
                NetworkReferer
                NetworkUserAgent
                NetworkResponseStatusCode
                NetworkSrcIP
                NetworkSrcPort
                NetworkDestIP
                NetworkDestPort
                NetworkIsListen
                NetworkURL
                NetworkDisplayedUrl
                NetworkBytesSent
                NetworkBytesReceived
                NetworkType
                NetworkConnectionDirection
                FileName
                FileMD5
                EmailFrom
                EmailTo
                EmailType
                EmailSubject
                EmailServerName
                EmailMessageId
                EmailCC
                EmailBCC
                NetworkIsIframe
                URLReputationInfo {
                  ReputationType
                  Resource
                  URLClassification
                  URLRepTotal
                  URLRepPositives
                  URLRepRisk
                  URLRepConfidence
                  URLRepSeverity
                  URLRepMalwareFamily
                  URLRepProtectionName
                  URLRepRegistrant
                  VTLink
                  __typename
                }
                DomainReputationInfo {
                  ReputationType
                  Resource
                  DomainClassification
                  DomainRepTotal
                  DomainRepPositives
                  DomainRepRisk
                  DomainRepConfidence
                  DomainRepSeverity
                  DomainRepMalwareFamily
                  DomainRepProtectionName
                  DomainRepRegistrant
                  VTLink
                  __typename
                }
                DestIPReputationInfo {
                  ReputationType
                  Resource
                  IPClassification
                  IPRepTotal
                  IPRepPositives
                  IPRepRisk
                  IPRepConfidence
                  IPRepSeverity
                  IPRepMalwareFamily
                  IPRepGeoLocation
                  VTLink
                  __typename
                }
                NetworkIsRemoteIpConnection
                __typename
              }
              Registry @include(if: $includeRecordRegistry) {
                RegistryKey
                RegistryValue
                RegistryNewData
                RegistryOldData
                RegistryOpMask
                RegistryOp
                __typename
              }
              Inject @include(if: $includeRecordInject) {
                InjectDstPid
                InjectDstCreationTime
                InjectClassification
                InjectDstDir
                InjectDstName
                InjectHookOperation
                __typename
              }
              Script @include(if: $includeRecordScript) {
                ScriptData
                __typename
              }
              RemoteLogon @include(if: $includeRecordRemoteLogon) {
                RemoteAttackerMachineName
                RemoteOwnerUserName
                RemoteOwnerDomainName
                RemoteAttackerIpAddress
                RemoteIpPort
                RemoteLogonType
                EventType
                RemoteEventID
                RemoteEventDescription
                RemoteStatusDescription
                RemoteSubStatusDescription
                RemoteNumberOfConnections
                LogonId
                LinkedLogonId
                UserSID
                LogonOrigin
                __typename
              }
              DetectionEvent @include(if: $includeDetectionEvent) {
                DetectionIncidentId
                DetectionAttackStatus
                DetectionEnforcementMode
                DetectionMalwareAction
                DetectionTriggeredBy
                DetectionThirdPartyVendorName
                DetectionMalwareFamily
                DetectionProtectionName
                DetectionProtectionType
                DetectionIncidentConfidence
                DetectionIncidentSeverity
                DetectionAttackTriggerProc
                DetectionMaliciousPath
                DetectionMaliciousFileDir
                DetectionMaliciousFileName
                DetectionMaliciousDomainName
                DetectionTriggerMD5
                DetectionEntryPointProc
                DetectionAttackRoot
                DetectionCreatingProcDir
                DetectionCreatingProcName
                DetectionCreatingProcMD5
                DetectionCreatingProcSigner
                DetectionCreatingProcPid
                DetectionCreatingProcCreationTime
                DetectionPolicyAutoRemidiation
                DetectionGeneralInfo
                DetectionDescription
                DetectionRemediationPolicy
                DetectionFirstEPNet
                DetectionFirstEPURLReferrer
                DetectionFirstEPFileName
                DetectionFirstEPFileHash
                DetectionAttackUserDomain
                DetectionAttackUserName
                DetectionImpersonatedDomain
                DetectionImpersonatedType
                DetectionImpersonatedBrand
                DetectionEmailMsgID
                DetectionEmailSubject
                DetectionEmailFrom
                DetectionEmailTo
                DetectionEmailAttachmentName
                DetectionEmailEmbeddedURL
                DetectionEmailDateOfDelivery
                __typename
              }
              AdvancedActivity @include(if: $includeAdvancedActivity) {
                ActivityType
                ActivityName
                ActivityDetails
                ActivityTargetProcessDir
                ActivityTargetProcessName
                ActivityTargetProcessArgs
                ActivityTargetPid
                ActivityTargetCreationTime
                __typename
              }
              IndirectExecution @include(if: $includeIndirectExecution) {
                ExecutionType
                ExecutionName
                ExecutionDetails
                ExecutionTargetProcessDir
                ExecutionTargetProcessName
                ExecutionTargetProcessArgs
                ExecutionTargetPid
                ExecutionTargetCreationTime
                ExecutionRemoteSourceMachine
                ExecutionRemoteTargetUserName
                ExecutionRemoteTargetUserDomain
                __typename
              }
              RemoteExecution @include(if: $includeRemoteExecution) {
                RemoteExecutionSourceIpAddress
                RemoteExecutionSourcePort
                RemoteExecutionSourceMachineName
                RemoteExecutionDestinationIpAddress
                RemoteExecutionDestinationPort
                RemoteExecutionUserName
                RemoteExecutionDomainName
                RemoteExecutionUserSID
                RemoteExecutionLogonId
                RemoteExecutionType
                __typename
              }
              MitreInfo @include(if: $includeMitre) {
                tacticID
                tacticName
                techniqueID
                techniqueName
                __typename
              }
              ShadowITInfo @include(if: $includeShadowIT) {
                applicationName
                categoryName
                subCategoryName
                __typename
              }
              AggregationResults {
                aggregationName
                aggregateResult
                __typename
              }
              __typename
            }
            ... on GWStatsRecord @include(if: $includeGWStats) {
              DataSource
              UUID
              HostType
              MachineName
              UserName
              OSName
              OSVersion
              Base {
                RecordType
                OpTimeUTC
                GatewayName
                __typename
              }
              Network {
                NetworkType
                NetworkURL
                NetworkProtocol
                NetworkDomain
                NetworkSrcIP
                NetworkSrcPort
                NetworkDestIP
                NetworkDestPort
                NetworkConnectionDirection
                NetworkReferer
                NetworkResponseStatusCode
                NetworkUserAgent
                NetworkHttpMethod
                FileMD5
                URLReputationInfo {
                  ReputationType
                  Resource
                  URLClassification
                  URLRepTotal
                  URLRepPositives
                  URLRepRisk
                  URLRepConfidence
                  URLRepSeverity
                  URLRepMalwareFamily
                  URLRepProtectionName
                  URLRepRegistrant
                  VTLink
                  __typename
                }
                DomainReputationInfo {
                  ReputationType
                  Resource
                  DomainClassification
                  DomainRepTotal
                  DomainRepPositives
                  DomainRepRisk
                  DomainRepConfidence
                  DomainRepSeverity
                  DomainRepMalwareFamily
                  DomainRepProtectionName
                  DomainRepRegistrant
                  VTLink
                  __typename
                }
                DestIPReputationInfo {
                  ReputationType
                  Resource
                  IPClassification
                  IPRepTotal
                  IPRepPositives
                  IPRepRisk
                  IPRepConfidence
                  IPRepSeverity
                  IPRepMalwareFamily
                  IPRepGeoLocation
                  VTLink
                  __typename
                }
                __typename
              }
              File @include(if: $includeRecordFile) {
                FileName
                FileMD5
                FileSize
                FileReputationInfo {
                  ReputationType
                  Resource
                  FileClassification
                  FileRepPositives
                  FileRepTotal
                  FileRepRisk
                  FileRepConfidence
                  FileRepSeverity
                  FileRepMalwareFamily
                  FileRepMalwareTypes
                  FileRepProtectionName
                  VTLink
                  __typename
                }
                __typename
              }
              DetectionEvent @include(if: $includeDetectionEvent) {
                DetectionAttackStatus
                DetectionEnforcementMode
                DetectionMalwareAction
                DetectionTriggeredBy
                DetectionMalwareFamily
                DetectionProtectionName
                DetectionIncidentConfidence
                DetectionIncidentSeverity
                DetectionMaliciousPath
                DetectionMaliciousFileName
                DetectionMaliciousDomainName
                DetectionTriggerMD5
                DetectionConnectionCount
                DetectionRemediationPolicy
                DetectionDescription
                __typename
              }
              MitreInfo @include(if: $includeMitre) {
                tacticID
                tacticName
                techniqueID
                techniqueName
                __typename
              }
              ShadowITInfo @include(if: $includeShadowIT) {
                applicationName
                categoryName
                subCategoryName
                __typename
              }
              __typename
            }
            ... on LAASRecord @include(if: $includeLAAS) {
              DataSource
              UUID
              HostType
              MachineName
              UserName
              OSName
              OSVersion
              Base {
                RecordType
                OpTimeUTC
                GatewayBlade
                GatewayName
                GatewayPolicyMgmt
                GatewayPolicyDate
                GatewayPolicyName
                GatewayPolicyRuleName
                GatewayPolicyRuleNumber
                GatewayPolicyRuleAction
                __typename
              }
              Network {
                NetworkType
                NetworkURL
                NetworkProtocol
                NetworkDomain
                NetworkSrcIP
                NetworkSrcPort
                NetworkDestIP
                NetworkDestPort
                NetworkConnectionDirection
                NetworkReferer
                NetworkResponseStatusCode
                NetworkUserAgent
                NetworkHttpMethod
                NetworkBytesSent
                NetworkBytesReceived
                URLReputationInfo {
                  ReputationType
                  Resource
                  URLClassification
                  URLRepTotal
                  URLRepPositives
                  URLRepRisk
                  URLRepConfidence
                  URLRepSeverity
                  URLRepMalwareFamily
                  URLRepProtectionName
                  URLRepRegistrant
                  VTLink
                  __typename
                }
                DomainReputationInfo {
                  ReputationType
                  Resource
                  DomainClassification
                  DomainRepTotal
                  DomainRepPositives
                  DomainRepRisk
                  DomainRepConfidence
                  DomainRepSeverity
                  DomainRepMalwareFamily
                  DomainRepProtectionName
                  DomainRepRegistrant
                  VTLink
                  __typename
                }
                DestIPReputationInfo {
                  ReputationType
                  Resource
                  IPClassification
                  IPRepTotal
                  IPRepPositives
                  IPRepRisk
                  IPRepConfidence
                  IPRepSeverity
                  IPRepMalwareFamily
                  IPRepGeoLocation
                  VTLink
                  __typename
                }
                __typename
              }
              File @include(if: $includeRecordFile) {
                FileName
                FileMD5
                FileSize
                FileReputationInfo {
                  ReputationType
                  Resource
                  FileClassification
                  FileRepPositives
                  FileRepTotal
                  FileRepRisk
                  FileRepConfidence
                  FileRepSeverity
                  FileRepMalwareFamily
                  FileRepMalwareTypes
                  FileRepProtectionName
                  VTLink
                  __typename
                }
                __typename
              }
              DetectionEvent @include(if: $includeDetectionEvent) {
                DetectionAttackStatus
                DetectionEnforcementMode
                DetectionMalwareAction
                DetectionTriggeredBy
                DetectionMalwareFamily
                DetectionProtectionName
                DetectionIncidentConfidence
                DetectionIncidentSeverity
                DetectionMaliciousPath
                DetectionMaliciousFileName
                DetectionMaliciousDomainName
                DetectionTriggerMD5
                DetectionConnectionCount
                DetectionRemediationPolicy
                DetectionDescription
                DetectionSuppressedLogs
                __typename
              }
              MitreInfo @include(if: $includeMitre) {
                tacticID
                tacticName
                techniqueID
                techniqueName
                __typename
              }
              ShadowITInfo @include(if: $includeShadowIT) {
                applicationName
                categoryName
                subCategoryName
                __typename
              }
              __typename
            }
            ... on MTARecord @include(if: $includeMTA) {
              DataSource
              OSName
              HostType
              Base {
                AssetType
                OpTimeSecondsUTC
                Domain
                OpTimeUTC
                RecordType
                OSVersion
                HostType
                MachineName
                UserName
                __typename
              }
              DetectionEvent @include(if: $includeDetectionEvent) {
                DetectionEventType
                DetectionAttackStatus
                DetectionEnforcementMode
                DetectionMalwareAction
                DetectionTriggeredBy
                DetectionMalwareFamily
                DetectionProtectionName
                DetectionProtectionType
                DetectionIncidentConfidence
                DetectionIncidentSeverity
                DetectionMaliciousFileName
                DetectionMaliciousDomainName
                DetectionTriggerMD5
                DetectionTriggerURL
                DetectionDescription
                DetectionEmailMsgID
                DetectionEmailSubject
                DetectionEmailFrom
                DetectionEmailTo
                DetectionEmailAttachmentName
                DetectionEmailDateOfDelivery
                DetectionMaliciousPath
                __typename
              }
              File @include(if: $includeRecordFile) {
                FileName
                FileMD5
                FileSha1
                FileType
                FileSize
                OriginalFileClassification
                FileReputationInfo {
                  ReputationType
                  Resource
                  FileClassification
                  FileRepPositives
                  FileRepTotal
                  FileRepRisk
                  FileRepConfidence
                  FileRepSeverity
                  FileRepMalwareFamily
                  FileRepMalwareTypes
                  FileRepProtectionName
                  VTLink
                  __typename
                }
                __typename
              }
              Network @include(if: $includeRecordNetwork) {
                NetworkSrcIP
                NetworkURL
                NetworkAction
                NetworkDomain
                NetworkType
                URLReputationInfo {
                  ReputationType
                  Resource
                  URLClassification
                  URLRepTotal
                  URLRepPositives
                  URLRepRisk
                  URLRepConfidence
                  URLRepSeverity
                  URLRepMalwareFamily
                  URLRepProtectionName
                  URLRepRegistrant
                  VTLink
                  __typename
                }
                DomainReputationInfo {
                  ReputationType
                  Resource
                  DomainClassification
                  DomainRepTotal
                  DomainRepPositives
                  DomainRepRisk
                  DomainRepConfidence
                  DomainRepSeverity
                  DomainRepMalwareFamily
                  DomainRepProtectionName
                  DomainRepRegistrant
                  VTLink
                  __typename
                }
                DestIPReputationInfo {
                  ReputationType
                  Resource
                  IPClassification
                  IPRepTotal
                  IPRepPositives
                  IPRepRisk
                  IPRepConfidence
                  IPRepSeverity
                  IPRepMalwareFamily
                  IPRepGeoLocation
                  VTLink
                  __typename
                }
                __typename
              }
              Email {
                EmailRule
                EmailStatus
                EmailClassification
                EmailReason
                EmailId
                EmailTo
                EmailFrom
                EmailSrcIP
                EmailStatus
                EmailSubject
                EmailQueueId
                EmailReplyTo
                EmailMessageId
                EmailAttachments
                EmailURLsCount
                EmailRecipientsNum
                EmailSourceCountry
                EmailInspectionType
                EmailConfidence
                __typename
              }
              __typename
            }
            __typename
          }
          __typename
        }
      }      
'@

    $varsJson = @'
    {
        "indicators": [
          {
            "fieldArr": [
              ""
            ],
            "fieldType": "DetectionAttackStatus",
            "operator": "Exists",
            "escaped": true
          }
        ],
        "queryParam": {
          "dateRange": {
            "from": "2021-09-19T22:00:00.000Z",
            "to": "2021-09-20T21:59:59.999Z"
          },
          "pagination": {
            "maxResults": 50,
            "pageToken": null
          },
          "aggregations": {
            "selectDistinct": false
          },
          "jobId": null,
          "useRepCache": false,
          "orderBy": {
            "field": "OpTimeUTC",
            "ascDesc": "DESC"
          },
          "recordTypes": [
            "DetectionEvent"
          ],
          "dataSourceTypes": [
            "endpoint"
          ]
        },
        "includeRecordBase": true,
        "includeRecordProcess": false,
        "includeRecordFile": false,
        "includeRecordEmail": false,
        "includeRecordNetwork": false,
        "includeRecordRegistry": false,
        "includeRecordInject": false,
        "includeRecordRemoteLogon": false,
        "includeRecordScript": false,
        "includeDetectionEvent": true,
        "includeAdvancedActivity": false,
        "includeIndirectExecution": false,
        "includeRemoteExecution": false,
        "includeMTA": false,
        "includeGWStats": false,
        "includeLAAS": false,
        "includeMitre": true,
        "includeShadowIT": true
      }
'@
    $variables = $varsJson | ConvertFrom-Json

    $fromTsStr = ((Get-Date).AddDays(-7)).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffK")
    $toTsStr = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffK")

    $variables.queryParam.dateRange.from = $fromTsStr
    $variables.queryParam.dateRange.to = $toTsStr

    $res = Get-CPTHGraphQLResponse $query $variables
    return $res;
}
