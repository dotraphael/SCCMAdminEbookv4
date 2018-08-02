$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

#Open Report
Invoke-CMReport -ReportPath "Status Messages - Audit/Remote Control - All remote control information" -SiteCode "$SiteCode" -SrsServerName "$servername"

#Query:
$Date = (Get-Date).AddHours(-6)
gwmi -Namespace "root\sms\site_$SiteCode" -ComputerName "$servername" -query "select stat.*, ins.*, att1.*, stat.Time from SMS_StatusMessage as stat left join SMS_StatMsgInsStrings as ins on stat.RecordID = ins.RecordID left join SMS_StatMsgAttributes as att1 on stat.RecordID = att1.RecordID inner join SMS_StatMsgInsStrings as ins2 on stat.RecordID = ins2.RecordID where stat.MessageType = 768 and stat.MessageID >= 30069 and stat.MessageID <= 30087 and ins2.InsStrIndex = 2 and ins2.InsStrValue = 'WKS0001' and stat.Time >= '$($Date.ToString('yyyy/MM/dd HH:mm:ss.fff'))' order by stat.Time desc"

$remoteaccesslist = gwmi -Namespace "root\sms\site_$SiteCode" -ComputerName "$servername" -query "select stat.Time, stat.MessageID, ins.InsStrIndex, ins.InsStrValue, att1.AttributeID, att1.AttributeTime, att1.AttributeValue from SMS_StatusMessage as stat left join SMS_StatMsgInsStrings as ins on stat.RecordID = ins.RecordID left join SMS_StatMsgAttributes as att1 on stat.RecordID = att1.RecordID inner join SMS_StatMsgInsStrings as ins2 on stat.RecordID = ins2.RecordID where stat.MessageType = 768 and stat.MessageID >= 30069 and stat.MessageID <= 30087 and ins2.InsStrIndex = 2 and ins2.InsStrValue = 'WKS0001' and stat.Time >= '$($Date.ToString('yyyy/MM/dd HH:mm:ss.fff'))' order by stat.Time desc"
foreach ($remoteaccess in $remoteaccesslist) {
	$props = @{ 'Time'=$remoteaccess.stat.Time;
				'MessageID'=$remoteaccess.stat.MessageID
				'InsStrIndex'=$remoteaccess.ins.InsStrIndex
				'InsStrValue'=$remoteaccess.ins.InsStrValue
				'AttributeID'=$remoteaccess.att1.AttributeID
				'AttributeTime'=$remoteaccess.att1.AttributeTime 
			 }
	$obj = new-object -TypeName psobject -Property $props
	write-output $obj
}
