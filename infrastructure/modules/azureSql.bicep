@description('Specifies region for all resources')
param location string

@description('Specifies sql admin login')
param sqlAdministratorLogin string

@description('Specifies sql admin password')
@secure()
param sqlAdministratorPassword string

param adminIdentitySid string
param tenant string

@description('Specifies database name')
param databaseName string


resource sqlserver 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: 'sqlserver${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorPassword
    version: '12.0'
  }

  resource database 'databases@2020-08-01-preview' = {
    name: databaseName
    location: location
    sku: {
      name: 'Basic'
    }
    properties: {
      collation: 'SQL_Latin1_General_CP1_CI_AS'
      maxSizeBytes: 1073741824
    }
  }

  resource firewallRule 'firewallRules@2020-11-01-preview' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }
  
  resource administrators 'administrators@2022-05-01-preview' = {
    name: 'ActiveDirectory'
    properties: {
      administratorType: 'ActiveDirectory'
      login: 'webappAppLogin'
      sid: adminIdentitySid
      tenantId: tenant
    }
  }

}

output appConfigConnectionString string = listKeys(sqlserver.id, sqlserver.apiVersion).value[0].connectionString
