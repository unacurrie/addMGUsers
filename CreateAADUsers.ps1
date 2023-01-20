# start from new connection and if no connection exists just SilentlyContinue
Disconnect-MgGraph -ErrorAction SilentlyContinue

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
    $username = ($user.name.Replace(' ', ''))
    $firstName = ($user.name -split ' ', 0)[0]
    New-MgUser `
      -DisplayName $user.name `
      -PasswordProfile $userPW `
      -AccountEnabled `
      -MailNickname $firstName `
      -Mail "$username@blanknessplc.onmicrosoft.com" `
      -UserPrincipalName "$username@blanknessplc.onmicrosoft.com" `
      -UsageLocation GB
  }
}

createUsers
