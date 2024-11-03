#!/bin/bash

function show_menu {
    clear
    echo "Herramienta de Administración de Data Center"
    echo "------------------------------------------"
    echo "1. Procesos"
    echo "2. Usuarios"
    echo "3. Backup"
    echo "4. Apagar equipo"
    echo "0. Salir"
}

function manage_processes {
    echo "Gestión de Procesos"
    echo "1. Listar procesos"
    echo "2. 5 procesos que más consumen CPU"
    echo "3. 5 procesos que más consumen memoria"
    echo "4. Terminar un proceso"
    read -p "Seleccione una opción: " choice

    case $choice in
        1) ps aux --sort=-%mem | less ;;
        2) ps aux --sort=-%cpu | head -n 6 ;;
        3) ps aux --sort=-%mem | head -n 6 ;;
        4) 
            read -p "Ingrese el nombre o PID del proceso a terminar: " process_name
            kill -9 $(pgrep -f "$process_name") && echo "Proceso $process_name terminado." || echo "Proceso no encontrado."
            ;;
        *) echo "Opción no válida." ;;
    esac
}

function manage_users {
    echo "Gestión de Usuarios"
    echo "1. Listar usuarios"
    echo "2. Listado de usuarios por antigüedad de contraseña"
    echo "3. Cambiar contraseña de un usuario"
    read -p "Seleccione una opción: " choice

    case $choice in
        1) cat /etc/passwd | cut -d: -f1 | less ;;
        2) 
            echo "Usuarios y antigüedad de contraseña:"
            chage -l $(whoami) | grep "Last password change" | sort
            ;;
        3) 
            read -p "Ingrese el nombre del usuario: " username
            sudo passwd $username
            ;;
        *) echo "Opción no válida." ;;
    esac
}

function perform_backup {
    read -p "Ingrese el directorio de destino para el backup: " backup_dir
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_file="$backup_dir/backup_$timestamp.tar.gz"

    user_dir="/home"
    if [ -d "$user_dir" ]; then
        tar -czvf "$backup_file" "$user_dir"
        echo "Backup realizado en $backup_file"
    else
        echo "El directorio de usuarios no existe."
    fi
}

function shutdown_system {
    echo "Apagando el equipo..."
    sudo shutdown now
}

while true; do
    show_menu
    read -p "Seleccione una opción: " option

    case $option in
        1) manage_processes ;;
        2) manage_users ;;
        3) perform_backup ;;
        4) shutdown_system ;;
        0) 
            echo "Saliendo..."
            break
            ;;
        *) echo "Opción no válida." ;;
    esac

    if [ "$option" -ne 0 ]; then
        read -p "Presione Enter para continuar..."
    fi
done