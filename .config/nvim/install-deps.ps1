# install-deps.ps1
#
# This script installs the required dependencies for your Neovim configuration on Windows.
# It uses the Winget package manager, which is built into modern versions of Windows.
#
# To run this script:
# 1. Save it as `install-deps.ps1`.
# 2. Right-click the Start menu and select "PowerShell (Admin)" or "Terminal (Admin)".
# 3. Navigate to the directory where you saved this file (e.g., `cd C:\Users\okamoto\Downloads`).
# 4. Run the command: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process`
# 5. Run the script: `.\install-deps.ps1`

Write-Host "Starting dependency installation for Neovim..." -ForegroundColor Green

# List of packages to install
$packages = @{
    "Git.Git"           = "Git (for plugin management)";
    "Kitware.CMake"     = "CMake (for building native plugins)";
    "BurntSushi.Ripgrep"= "Ripgrep (for Telescope fuzzy finding)";
}

# Loop through and install each package
foreach ($id in $packages.Keys) {
    $name = $packages[$id]
    Write-Host ""
    Write-Host "Checking for $name..." -ForegroundColor Cyan

    # Check if the package is already installed
    $installed = winget list --id $id -n 1 | Select-String -Quiet $id
    if ($installed) {
        Write-Host "$name is already installed." -ForegroundColor Green
    } else {
        Write-Host "Installing $name..." -ForegroundColor Yellow
        winget install -e --id $id --source winget --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully installed $name." -ForegroundColor Green
        } else {
            Write-Host "Failed to install $name. Please try installing it manually." -ForegroundColor Red
            # Optional: exit the script if a dependency fails
            # exit 1
        }
    }
}

Write-Host ""
Write-Host "------------------------------------------------------------------" -ForegroundColor Green
Write-Host "✅ All required tools have been installed."
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Install a Nerd Font for icons to display correctly."
Write-Host "   - Go to: https://www.nerdfonts.com/font-downloads"
Write-Host "   - Download a font (e.g., FiraCode, JetBrainsMono, CaskaydiaCove)."
Write-Host "   - Unzip and right-click the font files -> 'Install for all users'."
Write-Host "2. Configure your terminal (Windows Terminal, WezTerm, etc.) to use the new font."
Write-Host "3. Restart your terminal and Neovim for all changes to take effect."
Write-Host "------------------------------------------------------------------" -ForegroundColor Green

# --- Create Symbolic Link ---
Write-Host ""
Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
Write-Host "Attempting to create a symbolic link for the Neovim configuration."
Write-Host "This will allow you to keep your config in this directory and link it to Neovim's expected location."
Write-Host "------------------------------------------------------------------"

# Source is the directory where this script is located
$SourcePath = $PSScriptRoot

# Target is the standard Neovim config location on Windows
$TargetPath = "$env:LOCALAPPDATA\nvim"

Write-Host "Source: $SourcePath"
Write-Host "Target: $TargetPath"

# Check if the target path exists
if (Test-Path $TargetPath) {
    # Check if it's already a link
    $isLink = (Get-Item $TargetPath -Force).LinkType -ne $null
    if ($isLink) {
        Write-Host "Symbolic link already exists at the target location. No action needed." -ForegroundColor Green
    } else {
        # It's a directory or file, so back it up
        $BackupPath = "$TargetPath.bak"
        Write-Host "Existing configuration found at target location. Backing it up to '$BackupPath'..." -ForegroundColor Yellow
        if (Test-Path $BackupPath) {
            Remove-Item -Recurse -Force $BackupPath
            Write-Host "Removed existing backup at '$BackupPath'."
        }
        Move-Item -Path $TargetPath -Destination $BackupPath
        Write-Host "Backup complete. Creating new symbolic link."
        New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully created symbolic link." -ForegroundColor Green
        } else {
            Write-Host "Failed to create symbolic link. You may need to run this script as an Administrator." -ForegroundColor Red
        }
    }
} else {
    # Target doesn't exist, so just create the link
    Write-Host "No existing configuration found at target. Creating symbolic link."
    New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully created symbolic link." -ForegroundColor Green
    } else {
        Write-Host "Failed to create symbolic link. You may need to run this script as an Administrator." -ForegroundColor Red
    }
}