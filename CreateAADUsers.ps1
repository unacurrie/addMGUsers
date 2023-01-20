# start from new connection and if no connection exists just SilentlyContinue
# Disconnect-MgGraph -ErrorAction SilentlyContinue
#
Connect-MgGraph

function createPW {
  $randomPW = Invoke-RestMethod "https://www.passwordrandom.com/query?command=password"
  $password = @{ password = $randomPW }
  return $password
}

function createUsers {

  $mgusers = Get-MgUser
  $users = Get-Content .\data\users.json | ConvertFrom-Json

  foreach ($user in $users) {
    $userPW = createPW
    $mgusers | ForEach-Object {
      if ($user.name -match $_.DisplayName) {
        continue
      }
    }
    New-MgUser `
      -DisplayName $user.name `
      -PasswordProfile $userPW `
      -AccountEnabled `
      -MailNickname ($user.name -split ' ', 0)[0] `
      -Mail "$($user.name.Replace(' ', ''))@blanknessplc.onmicrosoft.com" `
      -UserPrincipalName "$($user.name.Replace(' ', ''))@blanknessplc.onmicrosoft.com" `
      -UsageLocation GB
  }
}

createUsers
