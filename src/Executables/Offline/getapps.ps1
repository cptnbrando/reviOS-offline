# Get the directory where the script is currently located
$CurrentDir = $PSScriptRoot

# Download list
$Files = [ordered]@{
    "RevisionTool-Setup.exe"                   =   "https://github.com/meetrevision/revision-tool/releases/latest/download/RevisionTool-Setup.exe"
    "vc_redist.x64.exe"                        =   "https://aka.ms/vs/17/release/vc_redist.x64.exe"
    "BraveBrowserStandaloneSetup.exe"          =   "https://github.com/brave/brave-browser/releases/latest/download/BraveBrowserStandaloneSetup.exe"
    "BraveBrowserStandaloneSetupArm64.exe"     =   "https://github.com/brave/brave-browser/releases/latest/download/BraveBrowserStandaloneSetupArm64.exe"
    "FirefoxBrowserStandaloneSetup.exe"        =   "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
    "FirefoxBrowserStandaloneSetupArm64.exe"   =   "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64-aarch64&lang=en-US"
}

Write-Host "Target Directory: $CurrentDir" -ForegroundColor Cyan
Write-Host "------------------------------------------"

foreach ($FileName in $Files.Keys) {
    $Url = $Files[$FileName]
    $Destination = Join-Path $CurrentDir $FileName
    
    # Check if the file already exists
    if (Test-Path -Path $Destination) {
        Write-Host "[SKIPPED] $FileName already exists." -ForegroundColor Yellow
    }
    else {
        try {
            Write-Host "[DOWNLOADING] $FileName..." -NoNewline
            
            # Using -UseBasicParsing to avoid issues on systems where IE isn't configured
            Invoke-WebRequest -Uri $Url -OutFile $Destination -ErrorAction Stop -UseBasicParsing
            
            Write-Host " DONE" -ForegroundColor Green
        }
        catch {
            Write-Host " FAILED" -ForegroundColor Red
            Write-Warning "Could not download $FileName. Error: $($_.Exception.Message)"
        }
    }
}

Write-Host "------------------------------------------"
Write-Host "Process complete." -ForegroundColor Cyan