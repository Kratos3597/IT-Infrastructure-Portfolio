$Password = ConvertTo-SecureString "<TEMP PASSWORD>" -AsPlainText -Force

New-ADGroup -Name "<Group Name>"

New-ADOrganizationalUnit -Name "<OU Name>"

New-ADUser `
    -SamAccountName "<Username>" `
    -Name "<Full Name>" `
    -Enabled $true `
    -AccountPassword $Password `
    -EmailAddress "<Email>" `
    -DisplayName "<Display Name>" `
    -GivenName "<First Name>" `
    -Surname "<Surname>" `
    -City "<City>" `
    -State "<State>" `
    -Office "<Office>" `
    -Description "<Description>" `
    -Path "OU=<OU Name>,DC=<Domain>,DC=<Local or com>"