do {
    Clear-Host
    $host.UI.RawUI.WindowTitle = "Oscar's PowerShell Laboratory"

    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "      WELCOME TO OSCAR'S LABORATORY      " -ForegroundColor Yellow
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Quick Hardware Information"
    Write-Host "2. Top 10 Processes by RAM Usage"
    Write-Host "3. List User Directory Folders"
    Write-Host "4. Search Local Large Files (>500MB)"
    Write-Host "5. RESTART Windows Explorer (RAM Cleanup)"
    Write-Host "6. AUDIT: Explorer Loaded Modules"
    Write-Host "7. Exit"
    Write-Host ""

    $opcion = Read-Host "Select an option (1-7)"

    switch ($opcion) {
        "1" { 
            Write-Host "-- System Summary --" -ForegroundColor Magenta
            Get-ComputerInfo | Select-Object CsName, CsModel, OsName | Format-List
        }
        "2" {
            Write-Host "-- Top 10 RAM Consumers --" -ForegroundColor Magenta
            Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 Name, @{Name="RAM(MB)";Expression={[math]::round($_.WorkingSet / 1MB, 2)}} | Format-Table -AutoSize
        }
        "3" {
            Write-Host "-- User Profile Folders --" -ForegroundColor Magenta
            Get-ChildItem ~ -Directory | Select-Object Name, LastWriteTime | Format-Table -AutoSize
        }
        "4" {
            Write-Host "-- Searching Local Large Files (>500MB) --" -ForegroundColor Magenta
            Get-ChildItem -Path $HOME -Recurse -File -ErrorAction SilentlyContinue | 
                Where-Object { $_.Length -gt 500MB -and $_.FullName -notlike "*DRIVE*" } | 
                Select-Object Name, @{Name="GB";Expression={[math]::round($_.Length / 1GB, 2)}}, FullName | Format-Table -AutoSize
        }
        "5" {
            Write-Host "Restarting Explorer... your screen will flicker." -ForegroundColor Yellow
            Stop-Process -Name explorer -Force
            Write-Host "Explorer refreshed successfully." -ForegroundColor Green
        }
        "6" {
            Write-Host "-- Explorer Module Audit --" -ForegroundColor Magenta
            Write-Host "Loaded .dll libraries:" -ForegroundColor Gray
            Get-Process explorer | Select-Object -ExpandProperty Modules | 
                Select-Object ModuleName, @{Name="Path";Expression={$_.FileName}} -First 30 | Format-Table -AutoSize
        }
        "7" {
            Write-Host "Closing application. Goodbye!" -ForegroundColor Green
        }
        Default { 
            Write-Host "Invalid option. Please try again." -ForegroundColor Red 
        }
    }
    if ($opcion -ne "7") { 
        Write-Host ""
        Read-Host "Press Enter to return to menu..." 
    }
} while ($opcion -ne "7")