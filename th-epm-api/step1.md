Check app folder
`find ~/app`{{execute}}

Download PowerShell
`curl -O -L https://github.com/PowerShell/PowerShell/releases/download/v7.1.5/powershell_7.1.5-1.ubuntu.16.04_amd64.deb` {{execute}}

Install PowerShell
`apt -f install -y; apt install -y liblttng-ust0; dpkg -i powershell_7.1.5-1.ubuntu.16.04_amd64.deb` {{execute}}

Start PowerShell
`pwsh`  {{execute}}

