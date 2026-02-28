# To create a playbook for AME Beta v0.8.4
# You zip up the contents of src, containing a playbook.conf and playbook.png as well as Configuration and Executables folder
# Configuration folder requires a main.yml file outlining the playbook details
# The zip file must be encrypted with password "malte"
# Then, rename the .7z file to .apbx. Presto, you now have a valid playbook ready to rock
# Though AME also checks for valid signing signatures, and if your playbook is forked from another playbook and changed
# The app will load is as malicious. You may ignore this or change the id information
# 
# The required password may change in the future
# For now the AME Beta app will display the necessary password if you give it a valid .apbx file that is missing the password
# So just zip up the contents of src with 7zip, rename the file to .apbx, then feed it to AME to find the required password
# Or look it up on the docs

$sourceDir = "./src/*"
$tempZip = "revios.7z"
$finalFile = "revios.apbx"
$password = "malte"
$testExe = "./src/Executables/OfflineApps/vc_redist.x64.exe"

# Delete old files
if (Test-Path $tempZip) { Remove-Item $tempZip -Force }
if (Test-Path $finalFile) { Remove-Item $finalFile -Force }

# Check for offline exe files required for installation
# Run install script if exe files are not present
if (!(Test-Path $testExe)) {
    Write-Host "Offline exe files not downloaded, running download script" -ForegroundColor Green
    . ./src/Executables/OfflineApps/getapps.ps1
} else {
    Write-Host "Offline exe files found, skipping download script" -ForegroundColor Green
}

# Archive and Encrypt
Write-Host "Archiving and encrypting files..." -ForegroundColor Cyan
& 7z a $tempZip $sourceDir "-p$password" -mhe=on

# Rename to .apbx
if (Test-Path $tempZip) {
    Write-Host "Renaming $tempZip to $finalFile..." -ForegroundColor Cyan
    Rename-Item -Path $tempZip -NewName $finalFile -Force
    Write-Host "Playbook created!" -ForegroundColor Yellow
} else {
    Write-Error "The 7z file was not created. Check if 7-Zip is installed and in your PATH." -ForegroundColor Red
}