# Check if OpenSSH is installed
function Check-OpenSSH {
    Get-WindowsCapability -Online | Where-Object { $_.Name -like "OpenSSH*" }
}

# Install OpenSSH
function Install-OpenSSH {
    Write-Output "Installing OpenSSH Client and Server..."
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Write-Output "OpenSSH installed successfully!"
}

# Configure Windows Firewall for SSH
function Configure-Firewall {
    Write-Output "Configuring Windows Firewall for SSH..."
    New-NetFirewallRule -DisplayName "Allow SSH" -Direction Inbound -Protocol TCP -LocalPort 1289 -Action Allow
    Write-Output "Firewall rule added for SSH."
}

# Start and configure OpenSSH Server
function Setup-SSHServer {
    Write-Output "Setting up OpenSSH Server..."
    Start-Service sshd
    Set-Service -Name sshd -StartupType Automatic
    Write-Output "OpenSSH Server is running and set to start automatically."
}

# Generate SSH Key
function Generate-SSHKey {
    $keyPath = Read-Host "Enter key filename (default: id_rsa)"
    if (-not $keyPath) { $keyPath = "id_rsa" }
    $keyPath = Join-Path $HOME\.ssh $keyPath
    ssh-keygen.exe -t rsa -b 4096 -f $keyPath
    Write-Output "SSH key generated at $keyPath"
}

# Connect to a Server
function Connect-ToServer {
    $host = Read-Host "Enter username@host"
    ssh.exe $host
}

# Transfer a File
function Transfer-File {
    $src = Read-Host "Enter source file path"
    $dest = Read-Host "Enter destination (username@host:path)"
    scp.exe $src $dest
}

# Main Menu
function Show-Menu {
    while ($true) {
        Clear-Host
        Write-Host "=== AXION OpenSSH Helper Menu  ==="
        
        $opensshStatus = Check-OpenSSH
        if ($opensshStatus -match "Installed") {
            Write-Host "1. Configure Firewall for SSH"
            Write-Host "2. Setup OpenSSH Server"
            Write-Host "3. Generate SSH Key"
            Write-Host "4. Connect to a Server"
            Write-Host "5. Transfer a File"
            Write-Host "6. Exit"
            $choice = Read-Host "Choose an option"

            switch ($choice) {
                1 { Configure-Firewall }
                2 { Setup-SSHServer }
                3 { Generate-SSHKey }
                4 { Connect-ToServer }
                5 { Transfer-File }
                6 { Write-Output "Goodbye!"; break }
                default { Write-Output "Invalid choice, please try again." }
            }
        } else {
            Write-Host "1. Install OpenSSH"
            Write-Host "2. Exit"
            $choice = Read-Host "Choose an option"

            switch ($choice) {
                1 { Install-OpenSSH }
                2 { Write-Output "Goodbye!"; break }
                default { Write-Output "Invalid choice, please try again." }
            }
        }
    }
}

# Run the Menu
Show-Menu
