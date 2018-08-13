#approve request
Get-CMApprovalRequest -ApplicationName "Java8" -User "CLASSROOM\User01" | Approve-CMApprovalRequest
#deny request
#Get-CMApprovalRequest -ApplicationName "Java8" -User "CLASSROOM\User01" | Deny-CMApprovalRequest