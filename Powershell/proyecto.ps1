# Script de administración de Data Center en PowerShell

function Show-Menu {
    Clear-Host
    Write-Host "Herramienta de Administración de Data Center"
    Write-Host "------------------------------------------"
    Write-Host "1. Procesos"
    Write-Host "2. Usuarios"
    Write-Host "3. Backup"
    Write-Host "4. Apagar equipo"
    Write-Host "0. Salir"
}

function Manage-Processes {
    Write-Host "Gestión de Procesos"
    Write-Host "1. Listar procesos"
    Write-Host "2. 5 procesos que más consumen CPU"
    Write-Host "3. 5 procesos que más consumen memoria"
    Write-Host "4. Terminar un proceso"
    $choice = Read-Host "Seleccione una opción"

    switch ($choice) {
        1 { Get-Process | Format-Table -AutoSize }
        2 { Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | Format-Table -AutoSize }
        3 { Get-Process | Sort-Object WS -Descending | Select-Object -First 5 | Format-Table -AutoSize }
        4 {
            $processName = Read-Host "Ingrese el nombre del proceso a terminar"
            Stop-Process -Name $processName -Force
            Write-Host "Proceso $processName terminado."
        }
        default { Write-Host "Opción no válida." }
    }
}

function Manage-Users {
    Write-Host "Gestión de Usuarios"
    Write-Host "1. Listar usuarios"
    Write-Host "2. Listado de usuarios por antigüedad de contraseña"
    Write-Host "3. Cambiar contraseña de un usuario"
    $choice = Read-Host "Seleccione una opción"

    switch ($choice) {
        1 { Get-LocalUser | Format-Table -AutoSize }
        2 {
            # Listar usuarios y su antigüedad de contraseña
            Get-LocalUser | Select-Object Name, PasswordLastSet | Sort-Object PasswordLastSet | Format-Table -AutoSize
        }
        3 {
            $username = Read-Host "Ingrese el nombre del usuario"
            $newPassword = Read-Host "Ingrese la nueva contraseña" -AsSecureString
            Set-LocalUser -Name $username -Password $newPassword
            Write-Host "Contraseña de $username cambiada."
        }
        default { Write-Host "Opción no válida." }
    }
}

function Perform-Backup {
    $backupDir = Read-Host "Ingrese el directorio de destino para el backup"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupFile = "$backupDir\backup_$timestamp.zip"

    # Crear backup del directorio de usuarios
    $userDir = "C:\Users"
    if (Test-Path $userDir) {
        Compress-Archive -Path $userDir -DestinationPath $backupFile
        Write-Host "Backup realizado en $backupFile"
    } else {
        Write-Host "El directorio de usuarios no existe."
    }
}

function Shutdown-System {
    Write-Host "Apagando el equipo..."
    Stop-Computer -Force
}

do {
    Show-Menu
    $option = Read-Host "Seleccione una opción"
    
    switch ($option) {
        1 { Manage-Processes }
        2 { Manage-Users }
        3 { Perform-Backup }
        4 { Shutdown-System }
        0 { Write-Host "Saliendo..." }
        default { Write-Host "Opción no válida." }
    }

    if ($option -ne 0) {
        Read-Host "Presione Enter para continuar..."
    }

} while ($option -ne 0)