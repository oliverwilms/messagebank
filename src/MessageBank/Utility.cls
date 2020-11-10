Class MessageBank.Utility
{

ClassMethod GetHostIPAddr(Output pSC As %Status) As %String
{
	Set pSC = $$$OK
	//Set tHostIPAddr = $P($zu(54,13,$zu(54,0)),",")
	Set tHostinfoPath = "/hostinfo/"
	Set tHostinfoFile = "host.config"
	Set tFile = tHostinfoPath_tHostinfoFile
	If ##class(%File).DirectoryExists(tHostinfoPath) {
		If ##class(%File).Exists(tFile) {
			Set tF = ##class(%File).%New(tFile)
			If $IsObject(tF) {
				Set tSC = tF.Open("R")
				If $$$ISOK(tSC) {
					Set tHostIPAddr = tF.Read()
					Do tF.Close()
					Set tF = ""
				} Else {
					//Set pSC = $SYSTEM.Status.Error($$$GeneralError,tFile_" unknown error 1")
				}
			} Else {
				//Set pSC = $SYSTEM.Status.Error($$$GeneralError,tFile_" unknown error 2")
			}
		} Else {
			//Set pSC = $SYSTEM.Status.Error($$$GeneralError,tHostinfoFile_" not found")
		}
	} Else {
		//Set pSC = $SYSTEM.Status.Error($$$GeneralError,tHostinfoPath_" not found")
	}
	Quit $Get(tHostIPAddr)
}

}
