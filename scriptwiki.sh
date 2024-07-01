function Show-Menu {
    param (
        [string]$Title = 'Menu'
    )

    Clear-Host
    Write-Host "================ $Title ================"
    Write-Host "1: Debian"
    Write-Host "2: Ubuntu"
    Write-Host "3: Kali Linux"
    Write-Host "Q: Quit"
}

function Get-UserSelection {
    param (
        [string]$Prompt = 'Please make a selection'
    )

    $selection = Read-Host $Prompt
    return $selection
}

function Get-DiskSize {
    param (
        [string]$Prompt = 'Enter disk size in GB'
    )

    $size = Read-Host $Prompt
    return $size
}

function Show-Progress {
    param (
        [string]$Message = 'Processing',
        [int]$Duration = 10
    )

    $chars = ('|', '/', '-', '\')
    $i = 0
    $end = (Get-Date).AddSeconds($Duration)
    while ((Get-Date) -lt $end) {
        $char = $chars[$i % $chars.Length]
        Write-Host -NoNewline "$Message $char`r"
        Start-Sleep -Milliseconds 250
        $i++
    }
    Write-Host "$Message ... Done!"
}

function Show-ASCII-Art {
    param (
        [string]$Art = ''
    )

    Write-Host $Art
}

function Install-Git {
    Show-Progress -Message "Installing Git"
    Start-Process "https://github.com/git-for-windows/git/releases/download/v2.33.0.windows.2/Git-2.33.0-64-bit.exe" -ArgumentList "/SILENT" -Wait
    Show-Progress -Message "Configuring Posh-Git"
    Install-Module posh-git -Scope CurrentUser -Force
    Import-Module posh-git
    Add-PoshGitToProfile -AllHosts
}

function Clone-WikiJS-Repo {
    param (
        [string]$RepoURL = 'https://github.com/Requarks/wiki.git',
        [string]$Destination = "$env:USERPROFILE\wiki"
    )

    Show-Progress -Message "Cloning Wiki.js repository"
    git clone $RepoURL $Destination
}

function Install-WSL {
    param (
        [string]$distro,
        [int]$sizeGB
    )

    # Activer le sous-système Windows pour Linux (WSL)
    Show-Progress -Message "Activating WSL"
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    # Activer la plateforme de machine virtuelle
    Show-Progress -Message "Activating Virtual Machine Platform"
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    # Redémarrer le système pour appliquer les modifications
    Write-Host "Redémarrez votre système pour appliquer les modifications, puis exécutez à nouveau ce script."
    pause

    # Mettre à jour le noyau WSL2
    Show-Progress -Message "Updating WSL2 Kernel"
    Start-Process "https://aka.ms/wsl2kernel" -Wait

    # Définir WSL2 comme version par défaut
    Show-Progress -Message "Setting WSL2 as default"
    wsl --set-default-version 2

    # Créer un disque virtuel (VHDX) de la taille spécifiée
    Show-Progress -Message "Creating VHDX of $sizeGB GB"
    $vhdxPath = "$env:USERPROFILE\$distro.vhdx"
    New-VHD -Path $vhdxPath -SizeBytes ($sizeGB * 1GB) -Dynamic

    # Attacher le disque virtuel
    Show-Progress -Message "Mounting VHDX"
    Mount-VHD -Path $vhdxPath

    # Initialiser le disque virtuel
    Show-Progress -Message "Initializing Disk"
    Initialize-Disk -Number (Get-Disk | Where-Object PartitionStyle -Eq "RAW").Number

    # Créer une partition et formater en ext4
    Show-Progress -Message "Creating and Formatting Partition"
    New-Partition -DiskNumber (Get-Disk | Where-Object PartitionStyle -Eq "RAW").Number -UseMaximumSize | Format-Volume -FileSystem ext4 -NewFileSystemLabel $distro

    # Démonter le disque virtuel
    Show-Progress -Message "Dismounting VHDX"
    Dismount-VHD -Path $vhdxPath

    # Installer la distribution Linux sélectionnée
    Show-Progress -Message "Installing $distro"
    wsl --install -d $distro

    # Configurer la distribution pour utiliser le disque virtuel
    Show-Progress -Message "Configuring $distro"
    wsl --set-version $distro 2
    wsl --export $distro $distro.tar
    wsl --unregister $distro
    wsl --import $distro $env:USERPROFILE\$distro $vhdxPath $distro.tar --version 2

    # Lancer la distribution
    Show-Progress -Message "Launching $distro"
    wsl -d $distro

    # Mettre à jour le système
    Show-Progress -Message "Updating $distro"
    wsl -d $distro -- sudo apt update; sudo apt full-upgrade -y

    # Installer des outils supplémentaires
    Show-Progress -Message "Installing additional tools"
    wsl -d $distro -- sudo apt install -y curl wget vim

    # Configuration de SSH (optionnel)
    Show-Progress -Message "Configuring SSH"
    wsl -d $distro -- sudo apt install -y openssh-client bash-completion
    wsl -d $distro -- sudo bash -c "echo 'alias magic=\"sudo apt update; sudo apt dist-upgrade --autoremove -y\"' >> /etc/bash.bashrc"
    wsl -d $distro -- sudo bash -c "echo 'HISTTIMEFORMAT=\"%Y-%m-%d %T \"' >> /etc/bash.bashrc"

    # Afficher la version de la distribution installée
    Show-Progress -Message "Displaying $distro version"
    wsl -d $distro -- lsb_release -a
}

$asciiArt = @"
  __        __   _                            _          ____  _             _ 
  \ \      / /__| | ___ ___  _ __ ___   ___  | |_ ___   |  _ \(_)_ __   __ _| |
   \ \ /\ / / _ \ |/ __/ _ \| '_ ` _ \ / _ \ | __/ _ \  | | | | | '_ \ / _` | |
    \ V  V /  __/ | (_| (_) | | | | | |  __/ | || (_) | | |_| | | | | | (_| | |
     \_/\_/ \___|_|\___\___/|_| |_| |_|\___|  \__\___/  |____/|_|_| |_|\__,_|_|
"@

do {
    Show-ASCII-Art -Art $asciiArt
    Show-Menu -Title "Sélectionnez le système d'exploitation à installer"
    $selection = Get-UserSelection -Prompt "Please make a selection"

    switch ($selection) {
        '1' {
            $distro = "Debian"
        }
        '2' {
            $distro = "Ubuntu"
        }
        '3' {
            $distro = "kali-linux"
        }
        'Q' {
            Write-Host "Quitting..."
            exit
        }
        default {
            Write-Host "Invalid selection, please try again."
            continue
        }
    }

    $sizeGB = Get-DiskSize -Prompt "Enter disk size in GB"

    Install-Git
    Clone-WikiJS-Repo

    Install-WSL -distro $distro -sizeGB $sizeGB

    Write-Host "Installation terminée. Appuyez sur une touche pour quitter."
    pause
    exit
} until ($selection -eq 'Q')
