Class MessageBank.Installer
{

XData setup
{
<Manifest>
  <Default Name="Namespace" Value="MESSAGEBANK"/>
  <Default Name="app" Value="messagebank" />

  <Namespace Name="${Namespace}" Code="${Namespace}" Data="${Namespace}" Create="yes" Ensemble="1">
    <Configuration>
      <Database Name="MBKCODE" Dir="/voldata/irisdb/MBKCODE" Create="yes" MountRequired="true" Resource="%DB_MBKCODE" PublicPermissions="" MountAtStartup="true"/>
      <Database Name="MBKDATA" Dir="/voldata/irisdb/MBKDATA" Create="yes" MountRequired="true" Resource="%DB_MBKDATA" PublicPermissions="" MountAtStartup="true"/>
    </Configuration>
  </Namespace>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

}
