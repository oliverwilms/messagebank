Class MessageBank.REST Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

Parameter HandleCorsRequest = 1;

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/:FILENAME" Method="POST" Call="UploadFile" />
<Route Url="/UploadFile/:FILENAME" Method="POST" Call="UploadFile" />
<Route Url="/UploadFile/:FILENAME" Method="GET" Call="TEST" />
<Route Url="/UploadFileNew/:FILENAME" Method="POST" Call="UploadFile" />
<Route Url="/BaseLogId" Method="GET" Call="GetBaseLogId" />
<Route Url="/BaseMsgId" Method="GET" Call="GetBaseMsgId" />
<Route Url="/Bases" Method="GET" Call="GetBases" />
<Route Url="/CheckErrors/:BaseLogId" Method="GET" Call="CheckErrors" />
<Route Url="/CheckErrors" Method="GET" Call="CheckErrors" />
<Route Url="/CheckMessages/:BaseMsgId" Method="GET" Call="CheckMessages" />
<Route Url="/CheckMessages" Method="GET" Call="CheckMessages" />
<Route Url="/DateTime" Method="GET" Call="GetDateTime" />
<Route Url="/DocumentId" Method="GET" Call="GetDocumentId" />
<Route Url="/ProductionStatus" Method="GET" Call="GetProductionStatus" />
<Route Url="/Production/Item/Enable/:ConfigItemName" Method="GET" Call="GetProdItemEnable" />
<Route Url="/ProdItemEnable/:ConfigItemName" Method="GET" Call="GetProdItemEnable" />
<Route Url="/Production/Start" Method="GET" Call="GetProductionStart" />
<Route Url="/Production/Stop" Method="GET" Call="GetProductionStop" />
</Routes>
}

ClassMethod DebugTEST(strMessage As %String = "") As %Status
{
	Set ^TESTapi($I(^TESTapi)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage
	Quit $$$OK
}

ClassMethod StatusToText(pStatus As %Status) As %String
{
	Set tReturn = $System.Status.GetOneErrorText(pStatus)
	Quit tReturn
}

ClassMethod DebugStatus(pStatus As %Status) As %Status
{
	Set tStatus = ..StatusToText(pStatus)
	Quit ..DebugTEST(tStatus)
}

ClassMethod GetBaseLogId() As %Status
{
	Do ..DebugTEST("MessageBank.REST - GetBaseLogId")
	Set tBaseLogId = 0
	// Get base log event ID
	Set query = "SELECT TOP 1 ID FROM Ens_Util.Log ORDER BY ID DESC"
	//Set tSC = ##class(Ensemble).ExecuteQueryOneValue(query,.tBaseLogId)
	Set tBaseLogId = 1 + tBaseLogId
	Do ..DebugTEST("tBaseLogId = "_tBaseLogId)
	Set data = {}
	Set data.BaseLogId = tBaseLogId
	Write data.%ToJSON()
	Quit $$$OK
}

ClassMethod GetBaseMsgId(pBegin As %String = "", pEnd As %String = "", pDEBUG As %String = 0) As %Status
{
	Do ..DebugTEST("MessageBank.REST - GetBaseMsgId")
	If (pEnd = "") {
		Set tDelim = $Extract(pBegin,1)
		Set pEnd = $Piece(pBegin,tDelim,3)
		Set pBegin = $Piece(pBegin,tDelim,2)
	}
	Kill pMsgBankCount
	Set strSELECT = "SELECT TimeCreated,TimeBanked,NodeId,Status,SourceConfigName,TargetConfigName"
	Set strFROM = " FROM Ens_Enterprise_MsgBank.MessageHeader"
	Set strWHERE = " WHERE TimeBanked BETWEEN '"_pBegin_"' AND '"_pEnd_"'"
	Set strORDER = " ORDER BY TimeBanked"
	Set pQuery = strSELECT_strFROM_strWHERE_strORDER
	Write:pDEBUG pQuery,!
	Set rs = ##class(%ResultSet).%New()
	Set tSC = rs.Prepare(pQuery)
	//Do ##class(Debug).DebugStatus(tSC)
	If $$$ISERR(tSC) { Quit tSC }
	Set tSC = rs.Execute()
	//Do ##class(Debug).DebugStatus(tSC)
	If $$$ISERR(tSC) { Quit tSC }
	Set (tMyMsgBegin,tMyMsgEnd) = ""
	Set a = "{"  // open
	Set c = ","  // comma
	Set cs = ": "  // colon + space
	Set q = """"  // quote
	Set z = "}"  // close
	While rs.Next() {
		If ($Increment(pMsgBankCount) = 1) Set tMyMsgBegin = $Get(rs.Data("TimeBanked"))
		//Set tMyMsgEnd = $Get(rs.Data("TimeBanked"))
		If ($Get(rs.Data("NodeId")) '= "") {
			If ($Increment(pMsgBankCount("NodeId",$Get(rs.Data("NodeId")))) = 1) {
				Set pMsgBankCount("NodeId",$Get(rs.Data("NodeId")),"Begin") = $Get(rs.Data("TimeBanked"))
			}
			Set pMsgBankCount("NodeId",$Get(rs.Data("NodeId")),"End") = $Get(rs.Data("TimeBanked"))
		}
		If ($Get(rs.Data("Status")) '= "") {
			If ($Increment(pMsgBankCount("Status",$Get(rs.Data("Status")))) = 1) {
				Set pMsgBankCount("Status",$Get(rs.Data("Status")),"Begin") = $Get(rs.Data("TimeBanked"))
			}
			Set pMsgBankCount("Status",$Get(rs.Data("Status")),"End") = $Get(rs.Data("TimeBanked"))
		}
		If ($Get(rs.Data("SourceConfigName")) '= "") {
			If ($Increment(pMsgBankCount("Source",$Get(rs.Data("SourceConfigName")))) = 1) {
				Set pMsgBankCount("Source",$Get(rs.Data("SourceConfigName")),"Begin") = $Get(rs.Data("TimeBanked"))
			}
			Set pMsgBankCount("Source",$Get(rs.Data("SourceConfigName")),"End") = $Get(rs.Data("TimeBanked"))
		}
		If ($Get(rs.Data("TargetConfigName")) '= "") {
			If ($Increment(pMsgBankCount("Target",$Get(rs.Data("TargetConfigName")))) = 1) {
				Set pMsgBankCount("Target",$Get(rs.Data("TargetConfigName")),"Begin") = $Get(rs.Data("TimeBanked"))
			}
			Set pMsgBankCount("Target",$Get(rs.Data("TargetConfigName")),"End") = $Get(rs.Data("TimeBanked"))
		}
	}
	Set tMyMsgEnd = $Get(rs.Data("TimeBanked"))
	Do rs.Close()
	Set rs = ""
	//Do ##class(Debug).DebugTEST("pMsgBankCount = "_pMsgBankCount)
	Set pMsgBankCount = $Get(pMsgBankCount,0)

	If pDEBUG zw pMsgBankCount
	Write a,!
	Write q_"nodes"_q_cs_"[",!
	Set tSC = ..WriteArray(.pMsgBankCount,"NodeId")
	Write "],",!
	Write q_"Status"_q_cs_"[",!
	Set tSC = ..WriteArray(.pMsgBankCount,"Status")
	Write "],",!
	Write q_"SourceConfigNames"_q_cs_"[",!
	Set tSC = ..WriteArray(.pMsgBankCount,"Source")
	Write "],",!
	Write q_"TargetConfigNames"_q_cs_"[",!
	Set tSC = ..WriteArray(.pMsgBankCount,"Target")
	Write "],",!
	Write q_"first"_q_cs_q_tMyMsgBegin_q_c,!
	Write q_"last"_q_cs_q_tMyMsgEnd_q_c,!
	Write q_"total"_q_cs_$Get(pMsgBankCount,0),!
	Write z
	Quit $$$OK
}

ClassMethod JsonValue(pValue As %String = "") As %String
{
	If pValue?1.N Quit pValue
	Set q = """"
	Quit q_pValue_q
}

ClassMethod WriteArray(ByRef pArray, pAA As %String = "", pDEBUG As %String = 0) As %Status
{
	If (pAA = "") Quit $$$OK
	//If pDEBUG,(pAA '= "") ZW pArray(pAA)
	/*
	pArray("NodeId",420)=614
	pArray("NodeId",420,"Begin")="2020-11-18 18:50:48.19"
	pArray("NodeId",420,"End")="2020-11-19 21:01:30.521"
	*/
	Set a = "{"  // open
	Set c = ","  // comma
	Set cs = ": "  // colon + space
	Set q = """"  // quote
	Set z = "}"  // close
	Set (tMyMsgBegin,tMyMsgEnd) = ""
	Set tFirst = 1
	Set bb = ""
	For {
		Set bb = $Order(pArray(pAA,bb),1,tTarget)
		If (bb = "") { Quit }
		If (tFirst = 0) Write c
		Set tFirst = 0
		Write a,!
		Write q_"id"_q_cs_q_..JsonValue(bb)_q_c,!
		Write q_"begin"_q_cs_q_$Get(pArray(pAA,bb,"Begin"))_q_c,!
		Write q_"end"_q_cs_q_$Get(pArray(pAA,bb,"End"))_q_c,!
		Write q_"count"_q_cs_$Get(tTarget,0),!
		Write z,!
	}
	Quit $$$OK
}

}
