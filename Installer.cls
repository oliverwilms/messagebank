Class MessageBank.Installer
{

XData setup
{
<Manifest>
  <Default Name="Namespace" Value="MESSAGEBANK"/>
  <Default Name="app" Value="messagebank" />

  <Namespace Name="${Namespace}" Code="MBKCODE" Data="MBKDATA" Create="yes" Ensemble="1">
    <Configuration>
      <Database Name="MBKCODE" Dir="/voldata/irisdb/MBKCODE" Create="yes" MountRequired="true" Resource="%DB_MBKCODE" PublicPermissions="" MountAtStartup="true"/>
      <Database Name="MBKDATA" Dir="/voldata/irisdb/MBKDATA" Create="yes" MountRequired="true" Resource="%DB_MBKDATA" PublicPermissions="" MountAtStartup="true"/>
      <GlobalMapping Global="HS.Local.VFC75.*" From="DMLSS_DBR"/>  <!-- store Message Bank IP address -->
    </Configuration>
  </Namespace>
  
  <Log Text="Configuring Ensemble Globals for MESSAGEBANK namespace." Level="0"/>
  <RunInstall Class="MessageBank.Installer" Method="EnableAutoStart"/>
  <If Condition='(##class(Security.Applications).Exists("/mbrest")=0)'>
	<Log Text="Creating web application /mbrest" Level="0"/>
	<RunInstall Class="MessageBank.Installer" Method="CreateWebAppREST"/>
  </If>
  <User Username="_SYSTEM" PasswordVar="Password" Roles="%All" Enabled="true"/>
</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

/// Use CPF Merge for Server IP
ClassMethod ConfigECP(ByRef pVars, pVerbose As %String = 1) As %Status
{
	If pVerbose {
		Write "Begin ConfigECP",!
		zw pVars
	}
	Set ECPProperties("Address") = $Get(pVars("Address"),"11.22.33.44")
	Set ECPProperties("MirrorConnection") = $Get(pVars("MirrorConnection"),1)
	Set ECPProperties("Port") = $Get(pVars("Port"),51773)
	Set pECPServerName = $Get(pVars("ServerName"),"DMLSS_DBR")
	Set tSC = ##class(Config.ECPServers).Create(pECPServerName,.ECPProperties)
	If pVerbose {
		zw ECPProperties
		Write $system.Status.GetOneErrorText(tSC),!
	}
	//
	Set pDatabaseName = $Get(pVars("DatabaseName"),"DMLSS_DBR")
	Set pMirrorName = $Get(pVars("MirrorName"),"IRISMIRROR")
	Set pMirrorPath = $Get(pVars("MirrorPath"),"DMLSS_DB")
	Set DBProperties("Server") = pECPServerName
	Set DBProperties("Directory") = ":mirror:"_pMirrorName_":"_pMirrorPath
	Set tSC = ##class(Config.Databases).Create(pDatabaseName,.DBProperties)
	If pVerbose {
		zw DBProperties
		Write $system.Status.GetOneErrorText(tSC),!
	}
	Set pResourceName = "%DB_"_pMirrorPath
	Set pDescription = "Resource for Remote DB"
	Set tSC = ##class(Security.Resources).Create(pResourceName,pDescription)
	If pVerbose {
		Write $system.Status.GetOneErrorText(tSC),!
	}
	Quit $$$OK
}

ClassMethod CreateWebAppREST(pVars, pLogLevel, tInstaller) As %Status
{
	/*
	Set Namespace = tInstaller.Evaluate("${Namespace}")
	Do tInstaller.PushNS("%SYS")
	Do ##class(Security.System).GetInstallationSecuritySetting(.security)
	If (security="None") {
		Set cspProperties("AutheEnabled") = $$$AutheUnauthenticated
	} Else {
		Set cspProperties("AutheEnabled") = $$$AutheCache // Password
	}
	*/
	Set cspName = "/mbrest"
	
	Set cspProperties("NameSpace") = $Get(Namespace,"MESSAGEBANK")
	Set cspProperties("Enabled") = 1
	Set cspProperties("AutheEnabled") = $$$AutheUnauthenticated
	Set cspProperties("AutheEnabled") = $$$AutheCache // Password
	Set cspProperties("DeepSeeEnabled") = 1
	Set cspProperties("iKnowEnabled") = 0
	Set cspProperties("DispatchClass") = "MessageBank.REST"
	Set cspProperties("Resource") = ""
	Set cspProperties("ServeFiles") = 1
	Set tSC = ##class(Security.Applications).Create(cspName,.cspProperties)
	//Do tInstaller.PopNS()
	If $$$ISERR(tSC) Throw ##class(%Installer.Exception).CreateFromStatus(tSC)
	Quit $$$OK
}

/// Configure Message Bank Link AND AutoStart Production
ClassMethod EnableAutoStart(ByRef pVars, pLogLevel, tInstaller) As %Status
{
	Set myNamespace = $Namespace
	Set $Namespace = pVars("Namespace")
	If pVars("AutoStart") '= "" {
		Set ^Ens.AutoStart = pVars("AutoStart")
		Set ^Ens.AutoStart("StartupPriority") = 0
	}
	ZN myNamespace
	Quit $$$OK
}

ClassMethod AWSConfigIRIS(ByRef pVars, pLogLevel As %String = "", tInstaller) As %Status
{
	Set myNamespace = $Namespace
	ZN "%SYS"
	If $Get(pLogLevel) = "" Set pLogLevel = 1
	Set tSC = ..ConfigECP(.pVars,pLogLevel)
	If (tSC '= $$$OK) {
		Write "ECP Config failed.",!
		Write "Check if Data Server allows connection from this host.",!
		Write $system.Status.GetOneErrorText(tSC),!
		ZN myNamespace
		Quit tSC
	}
	//zw pVars
	ZN myNamespace
	Set pVars("AutoStart") = "MessageBank.Production"
	Set pVars("Namespace") = "MESSAGEBANK"
	Set pVars("User") = "HS_Services"
	Set pVars("Password") = "abc123"
	Set tSC = ..setup(.pVars)
	If (tSC '= $$$OK) {
		Write "Setup failed.",!
		Write $system.Status.GetOneErrorText(tSC),!
	}
	ZN myNamespace
	Quit tSC
}

}
