
Import-Module OperationsManager
New-SCOMManagementGroupConnection -ComputerName SCOMMS

$Class = Get-SCOMClass -Name "Microsoft.SQLServer.Windows.Database"

# $Instances = Get-SCOMClassInstance -Class $Class 
# $Instances

# Interestingly, a database that is offline will list as IsAvaile = True and Health State = Error

$Instances = Get-SCOMClassInstance -Class $Class | Select Name, *.MachineName, *.InstanceName, *.Collation, HealthState, IsAvailable
$instances

<#
PS C:\Users\graham\Source\Repos\PowerShell_SCOM\HealthStates> $Class = Get-SCOMClass -Name "Microsoft.SQLServer*" | Select Name, DisplayName
PS C:\Users\graham\Source\Repos\PowerShell_SCOM\HealthStates> $Class

Name                                                             DisplayName
----                                                             -----------
Microsoft.SQLServer.Windows.FdSpaceMonitoringGroup               MSSQL on Windows: FILESTREAM Space Monitoring Group
Microsoft.SQLServer.Windows.DBFilegroup                          MSSQL on Windows: DB Filegroup
Microsoft.SQLServer.Core.Container                               MSSQL: Generic DB Memory-Optimized Data Container
Microsoft.SQLServer.Core.DistributedAvailabilityGroup            SQL Server Distributed Availability Group
Microsoft.SQLServer.Windows.DBFile                               MSSQL on Windows: DB File
Microsoft.SQLServer.Windows.AlwaysOnSeed                         MSSQL on Windows: Always On Seed
Microsoft.SQLServer.Core.SQLMonitoringPool                       SQL Server Monitoring Pool
Microsoft.SQLServer.Core.AvailabilityDatabaseHealth              Generic SQL Server Availability Database Health
Microsoft.SQLServer.Core.DBLogFile                               MSSQL: Generic DB Log File
Microsoft.SQLServer.Core.InMemoryOLTPScopeGroup                  MSSQL: Generic Memory-Optimized Data Scope Group
Microsoft.SQLServer.Windows.LocalDiscoverySeed                   MSSQL on Windows: Local Discovery Seed
Microsoft.SQLServer.Core.InMemoryOLTPResourcePoolGroup           MSSQL: Generic Memory-Optimized Data Resource Pool Group
Microsoft.SQLServer.Core.AvailabilityGroupGroup                  MSSQL: Group of Availability Groups
Microsoft.SQLServer.Windows.DatabaseReplicaWarningUserPolicy     MSSQL on Windows: Database Replica Warning Policy
Microsoft.SQLServer.Windows.DatabaseWarningUserPolicy            MSSQL on Windows: Database Warning Policy
Microsoft.SQLServer.Core.DBEngineExpressGroup                    MSSQL: Generic SQL Server Express DB Engine Group
Microsoft.SQLServer.Windows.DBLogFile                            MSSQL on Windows: DB Log File
Microsoft.SQLServer.Windows.UserResourcePool                     MSSQL on Windows: User Resource Pool
Microsoft.SQLServer.Windows.AvailabilityReplicaErrorUserPolicy   MSSQL on Windows: Availability Replica Critical Policy
Microsoft.SQLServer.Windows.AvailabilityGroupHealth              MSSQL on Windows: Availability Group Health
Microsoft.SQLServer.Windows.DefaultPool                          MSSQL on Windows: Default Resource Pool
Microsoft.SQLServer.Core.DatabaseReplica                         Generic SQL Server Database Replica
Microsoft.SQLServer.Windows.SqlVersionAgnosticGroup              MSSQL on Windows: Group for disabling discovery of previous SQL Servers
Microsoft.SQLServer.Windows.ResourcePoolGroup                    MSSQL on Windows: Resource Pool Group
Microsoft.SQLServer.Windows.DBFilegroupFd                        MSSQL on Windows: DB FILESTREAM Filegroup
Microsoft.SQLServer.Windows.Container                            MSSQL on Windows: DB Memory-Optimized Data Container
Microsoft.SQLServer.Windows.MonitoringPoolAlertCollection        MSSQL on Windows: Monitoring Pool Alert Collection
Microsoft.SQLServer.Windows.InMemoryOLTPScopeGroup               MSSQL on Windows: Memory-Optimized Data Scope Group
Microsoft.SQLServer.Core.AvailabilityReplicaGroup                MSSQL: Group of Generic Availability Replicas
Microsoft.SQLServer.Core.AllDBEngineRelatedRootObjectsGroup      MSSQL: All SQL Server Related Root Objects Group
Microsoft.SQLServer.Core.File                                    MSSQL: Generic File
Microsoft.SQLServer.Core.ResourcePool                            MSSQL: Generic Resource Pool
Microsoft.SQLServer.Windows.Discovery.SmartAdminFeatureGroup     MSSQL on Windows: SmartAdmin Feature Group
Microsoft.SQLServer.Windows.LocalDatabase                        MSSQL on Windows: Local DB
Microsoft.SQLServer.Windows.DBEngine                             MSSQL on Windows: DB Engine
Microsoft.SQLServer.Windows.AlwaysOnPolicy                       MSSQL on Windows: Always On Custom User Policy
Microsoft.SQLServer.Core.DatabaseReplicaGroup                    MSSQL: Group of Generic Database Replicas
Microsoft.SQLServer.Windows.LocalAgentJob                        MSSQL on Windows: Local Agent Job
Microsoft.SQLServer.Windows.InMemoryOLTPResourcePoolGroup        MSSQL on Windows: Memory-Optimized Data Resource Pool Group
Microsoft.SQLServer.Windows.LocalClusteredDBEngineDiscoverySeed  MSSQL on Windows: Local Clustered DB Engine Seed
Microsoft.SQLServer.Windows.AvailabilityReplicaWarningUserPolicy MSSQL on Windows: Availability Replica Warning Policy
Microsoft.SQLServer.Windows.InternalPool                         MSSQL on Windows: Internal Resource Pool
Microsoft.SQLServer.Windows.ResourcePool                         MSSQL on Windows: Resource Pool
Microsoft.SQLServer.Windows.Discovery.SqlAgentFeatureGroup       MSSQL on Windows: Agent Feature Group
Microsoft.SQLServer.Windows.UserDefinedPool                      MSSQL on Windows: User-Defined Resource Pool
Microsoft.SQLServer.Core.Filegroup                               MSSQL: Generic Filegroup Abstract
Microsoft.SQLServer.Core.AlwaysOnSeed                            Generic SQL Server Always On Seed
Microsoft.SQLServer.Windows.Agent                                MSSQL on Windows: Agent
Microsoft.SQLServer.Windows.DBFilegroupFx                        MSSQL on Windows: DB Memory-Optimized Data Filegroup
Microsoft.SQLServer.Windows.Discovery.SqlResurcePoolFeatureGroup MSSQL on Windows: Resource Pool Feature Group
Microsoft.SQLServer.Windows.AvailabilityReplicaGroup             MSSQL on Windows: Group of Windows Availability Replicas
Microsoft.SQLServer.Windows.LocalAgent                           MSSQL on Windows: Local Agent
Microsoft.SQLServer.Windows.AvailabilityGroupErrorUserPolicy     MSSQL on Windows: Availability Group Critical Policy
Microsoft.SQLServer.Windows.DatabaseReplicaGroup                 MSSQL on Windows: Group of Windows Database Replicas
Microsoft.SQLServer.Core.DBEngineGroup                           MSSQL: Generic DB Engine Group
Microsoft.SQLServer.Core.AvailabilityGroupHealth                 Generic SQL Server Availability Group Health
Microsoft.SQLServer.Windows.AvailabilityDatabaseHealth           SQL Server Availability Database Health
Microsoft.SQLServer.Windows.Database                             MSSQL on Windows: Database
Microsoft.SQLServer.Core.DBFile                                  MSSQL: Generic DB File
Microsoft.SQLServer.Windows.AvailabilityGroupWarningUserPolicy   MSSQL on Windows: Availability Group Warning Policy
Microsoft.SQLServer.Core.MonitoringPoolAlertCollection           MSSQL: Generic Monitoring Pool Alert Collection
Microsoft.SQLServer.Windows.Policy                               MSSQL on Windows: Custom User Policy
Microsoft.SQLServer.Windows.LocalDBEngine                        MSSQL on Windows: Local DB Engine
Microsoft.SQLServer.Windows.FxSpaceMonitoringGroup               MSSQL on Windows: In-Memory OLTP Space Monitoring Group
Microsoft.SQLServer.Core.AvailabilityGroup                       SQL Server Availability Group
Microsoft.SQLServer.Core.DBEngine                                MSSQL: Generic DB Engine
Microsoft.SQLServer.Windows.FilegroupsGroup                      MSSQL on Windows: All SQL Server Filegroups Group
Microsoft.SQLServer.IS.Windows.LocalInstance                     MSSQL on Windows Integration Services: Local Instance
Microsoft.SQLServer.Windows.DBEngineSeed                         MSSQL on Windows: DB Engine Seed
Microsoft.SQLServer.Windows.Discovery.SqlFeatureGroup            MSSQL on Windows: Abstract Feature Group
Microsoft.SQLServer.Core.DBFilegroupFx                           MSSQL: Generic DB Memory-Optimized Data Filegroup
Microsoft.SQLServer.Windows.DBEngineExpressGroup                 MSSQL on Windows: SQL Server Express DB Engine Group
Microsoft.SQLServer.Core.TemplateSeed                            MSSQL: Template Seed
Microsoft.SQLServer.Core.Agent                                   MSSQL: Generic Agent
Microsoft.SQLServer.Windows.AvailabilityReplica                  MSSQL on Windows: Availability Replica
Microsoft.SQLServer.IS.Windows.LocalSeed                         MSSQL on Windows Integration Services: Local Seed
Microsoft.SQLServer.Core.AlwaysOnHighAvailabilityGroup           MSSQL: Group of High Availability Groups
Microsoft.SQLServer.Windows.AgentJob                             MSSQL on Windows: Agent Job
Microsoft.SQLServer.Core.Database                                MSSQL: Generic DB
Microsoft.SQLServer.IS.Windows.IntegrationServicesGroup          MSSQL on Windows Integration Services: SQL Server Integration Services Group
Microsoft.SQLServer.Windows.DatabaseReplica                      MSSQL on Windows: Database Replica
Microsoft.SQLServer.Core.DBFilegroupFd                           MSSQL: Generic DB FILESTREAM Filegroup
Microsoft.SQLServer.Windows.AllSQLServerObjectsGroup             MSSQL on Windows: All SQL Server Objects Group
Microsoft.SQLServer.Core.DBFilegroup                             MSSQL: Generic DB Filegroup
Microsoft.SQLServer.Core.ServerRolesGroup                        MSSQL: Generic Server Roles Group
Microsoft.SQLServer.Core.AgentJob                                MSSQL: Generic Agent Job
Microsoft.SQLServer.Windows.DatabaseErrorUserPolicy              MSSQL on Windows: Database Critical Policy
Microsoft.SQLServer.Core.AlwaysOnPolicy                          Generic SQL Server Always On Custom User Policy
Microsoft.SQLServer.Windows.Discovery.InMemoryOltpFeatureGroup   MSSQL on Windows: In-Memory OLTP Feature Group
Microsoft.SQLServer.Core.SQLServerAlertsScopeGroup               SQL Server Alerts Scope Group
Microsoft.SQLServer.Core.AvailabilityDatabase                    SQL Server Availability Database
Microsoft.SQLServer.Windows.DBEngineGroup                        MSSQL on Windows: DB Engine Group
Microsoft.SQLServer.Core.Policy                                  MSSQL: Generic Custom User Policy
Microsoft.SQLServer.Windows.DatabaseReplicaErrorUserPolicy       MSSQL on Windows: Database Replica Critical Policy
Microsoft.SQLServer.Windows.ComputersGroup                       MSSQL on Windows: SQL Server Computers
Microsoft.SQLServer.Core.AvailabilityReplica                     Generic SQL Server Availability Replica

#>