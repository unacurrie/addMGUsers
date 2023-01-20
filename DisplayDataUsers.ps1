$users = Get-Content .\data\users.json | ConvertFrom-Json
foreach ($user in $users) {
  $user.name
}
