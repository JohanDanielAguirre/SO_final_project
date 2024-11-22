#!/bin/bash

mostrar_menu() {
    echo "================================="
    echo "      Herramienta de Administración"
    echo "        para Data Centers"
    echo "================================="
    echo "Seleccione una opción:"
    echo "---------------------------------"
    echo "1. Listar procesos"
    echo "2. Mostrar 5 procesos que más consumen CPU"
    echo "3. Mostrar 5 procesos que más consumen memoria"
    echo "4. Terminar un proceso"
    echo "5. Listar usuarios del sistema"
    echo "6. Listar usuarios por vejez de contraseña"
    echo "7. Cambiar contraseña de un usuario"
    echo "8. Realizar backup del directorio de usuarios"
    echo "9. Apagar el equipo"
    echo "0. Salir"
    echo "---------------------------------"
}

# Función para listar procesos
listar_procesos() {
    ps aux | awk '{printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4, $5, $6, $11}'
}

# Función para mostrar los 5 procesos que más consumen CPU
procesos_top_cpu() {
    ps aux --sort=-%cpu | head -n 6 | awk '{printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4, $5, $6, $11}'
}

# Función para mostrar los 5 procesos que más consumen memoria
procesos_top_memoria() {
    echo "================================="
    ps aux --sort=-%mem | head -n 6 | awk '{printf "%-10s %-10s %-10s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4, $5, $6, $11}'
}

# Función para terminar un proceso
terminar_proceso() {
    read -p "Ingrese el PID del proceso a terminar: " pid
    kill $pid
}

# Función para listar usuarios del sistema
listar_usuarios() {
    cut -d: -f1 /etc/passwd
}

# Función para listar usuarios por vejez de contraseña
listar_usuarios_vejez() {
    # No esta realizando correctamente el ordenamiento por fecha
    printf "%-20s %-20s\n" "Usuario" "Último cambio de contraseña"
    printf "%-20s %-20s\n" "-------" "--------------------------"
    for user in $(cut -d: -f1 /etc/passwd); do
        password_date=$(chage -l $user | grep "Last password change" | cut -d: -f2)
        printf "%-20s %-20s\n" "$user" "$password_date"
    done | sort -k1,1 -k2,2
    
}

# Función para cambiar la contraseña de un usuario
cambiar_contrasena() {
    read -p "Ingrese el nombre de usuario: " usuario
    passwd $usuario
}

# Función para realizar backup del directorio de usuarios
realizar_backup() {
    read -p "Ingrese el directorio de destino para el backup: " destino
    tar -czvf $destino/backup_$(date +%Y%m%d).tar.gz /home
}

# Función para apagar el equipo
apagar_equipo() {
    shutdown now
}

# Bucle principal
while true; do
    mostrar_menu
    read -p "Opción: " opcion
    case $opcion in
        1) listar_procesos ;;
        2) procesos_top_cpu ;;
        3) procesos_top_memoria ;;
        4) terminar_proceso ;;
        5) listar_usuarios ;;
        6) listar_usuarios_vejez ;;
        7) cambiar_contrasena ;;
        8) realizar_backup ;;
        9) apagar_equipo ;;
        0) exit 0 ;;
        *) echo "Opción no válida" ;;
    esac
done